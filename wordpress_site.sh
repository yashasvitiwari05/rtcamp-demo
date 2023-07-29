#!/bin/bash

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
  echo "Docker is not installed. Please install Docker and try again."
  exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &>/dev/null; then
  echo "Docker Compose is not installed. Please install Docker Compose and try again."
  exit 1
fi

# Function to create a new WordPress site
create_wordpress_site() {
  if [ -z "$1" ]; then
    echo "Please provide a site name as a command-line argument."
    exit 1
  fi

  SITE_NAME="$1"

  # Create docker-compose.yml file for the WordPress site
  cat <<EOF >docker-compose.yml
version: '3'
services:
  wordpress:
    image: wordpress:latest
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: password
    volumes:
      - wp_data:/var/www/html
  db:
    image: mariadb:latest
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: password
    volumes:
      - db_data:/var/lib/mysql
volumes:
  wp_data:
  db_data:
EOF

  # Create /etc/hosts entry
  if ! grep -q "$SITE_NAME" /etc/hosts; then
    echo "127.0.0.1 $SITE_NAME" | tee -a /etc/hosts
  fi

  # Start containers
  docker-compose up -d

  echo "WordPress site '$SITE_NAME' is created and running at http://$SITE_NAME"
}

# Function to stop/start the WordPress site
manage_wordpress_site() {
  if [ -z "$1" ]; then
    echo "Please provide 'start' or 'stop' as a subcommand."
    exit 1
  fi

  SUBCOMMAND="$1"

  if [ "$SUBCOMMAND" == "start" ]; then
    docker-compose start
    echo "WordPress site started. You can access it at http://example.com"
  elif [ "$SUBCOMMAND" == "stop" ]; then
    docker-compose stop
    echo "WordPress site stopped."
  else
    echo "Invalid subcommand. Please provide 'start' or 'stop'."
  fi
}

# Function to delete the WordPress site
delete_wordpress_site() {
  docker-compose down --volumes
  sed -i '/example.com/d' /etc/hosts
  echo "WordPress site deleted."
}

# Main script starts here

if [ $# -lt 1 ]; then
  echo "Usage: $0 {create|manage|delete} [SITE_NAME]"
  exit 1
fi

ACTION="$1"
SITE_NAME="$2"

case "$ACTION" in
  "create")
    create_wordpress_site "$SITE_NAME"
    ;;
  "manage")
    manage_wordpress_site "$SITE_NAME"
    ;;
  "delete")
    delete_wordpress_site
    ;;
  *)
    echo "Invalid action. Usage: $0 {create|manage|delete} [SITE_NAME]"
    exit 1
    ;;
esac

exit 0

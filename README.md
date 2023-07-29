# WordPress Manager

## Installation:

Save the script to a file, for example, wordpress_site.sh, and grant it executable permissions using the following command:

```bash
chmod +x wordpress_site.sh
```
You can then execute the script with the appropriate subcommand and provide the site name as an argument. The script supports the following subcommands:

Create a new WordPress site:
```bash
./wordpress_site.sh create example.com
```

Manage (start/stop) the WordPress site:
- To start the WordPress
```bash
./wordpress_site.sh manage start
```

- To stop the WordPress site:
```bash
./wordpress_site.sh manage stop
```

- Delete the WordPress site:
```bash
./wordpress_site.sh delete
```
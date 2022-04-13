# WordPress Cloner

Quickly* create a local copy of a WordPress site.

*Depending on the size of media library of the site and your internet connection.


## What This Does

The zsh script `wordpress.sh` automates the steps needed to set up a local WordPress site on a Mac and copy a remote WordPress installation into that site using [WP Migrate](https://deliciousbrains.com/wp-migrate-db-pro/).
For workflows that often need to debug why something isn't working, (for example, for support), this makes having a full local copy of a WordPress site relatively quick and easy.

## How to Use It

1. Install WP Migrate on the remote site.
2. Turn on pull access in the WP Migrate settings
3. Run `./wordpress.sh`
4. Provide the information requested.

You will be asked for the site name, the root password for your local MySQL/MariaDB server, your WP Migrate license key, and the URL and WP Migrate secret of the remote site.
With this information the script will make a directory in `~/Sites` for the site, install a fresh copy of WordPress, then use WP Migrate to copy the remote site's database, media, and theme and plugin files to your local site.

## Serving the Local Site

I recommend using [Laravel Valet](https://laravel.com/docs/9.x/valet) to serve each directory in your `~/Sites` directory as `directory-name.test`, and `wordpress.sh` names the directory and sets the WordPress hostname expecting this to happen. 
If you don't use Laravel Valet you will need to update your hosts file and webserver configuration to respond to the hostname `directory-name.test`, where 'directory-name' is the URL slug of the site name you provided to the script.
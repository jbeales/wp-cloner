#!/bin/zsh -e


clear
echo "============================================"
echo "Clone WordPress Site to Localhost"
echo "============================================"



vared -p "Site Name: " -c SITENAME
#vared -p "Hostname: " -c HOSTNAME

vared -p "WP DB Migate Pro License Key: " -c DBMIGRATE_KEY
vared -p "Pull from URL: " -c SOURCE_URL
vared -p "Source site secret: " -c SOURCE_KEY

echo "Please enter the username and password of a database user with create database privileges."
vared -p "Database Access Username: " -c DB_ACCESS_USER
vared -p "Database Access Password: " -c DB_ACCESS_PASS

DBNAME=${$($PWD/slugify.sh $SITENAME):gs/-/_}
DBPASS=$(openssl rand -base64 32)
# yeah, this is weird. It returns an empty string with just DBUSER="$DBNAME_user"
DBUSER="$(echo $DBNAME)_user"
HOSTNAME="$($PWD/slugify.sh $SITENAME).test"
INSTALL_DIR=$HOME/Sites/$($PWD/slugify.sh $SITENAME)

PLUGIN_SOURCE=$PWD/default-wp-plugins

vared -p "run install? (y/n)" -c RUN
if [ "$RUN" != "y" ] ; then
	exit
fi

echo "============================================"
echo "A robot is now installing WordPress for you."
echo "============================================"

echo "Make the database. $DBNAME"
# Make a database.
mysql -u $DB_ACCESS_USER -p$DB_ACCESS_PASS -e "CREATE DATABASE $DBNAME"
echo "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS'"
mysql -u $DB_ACCESS_USER -p$DB_ACCESS_PASS -e "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS'"
echo "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost'"
mysql -u $DB_ACCESS_USER -p$DB_ACCESS_PASS -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost'"
mysql -u $DB_ACCESS_USER -p$DB_ACCESS_PASS -e "FLUSH PRIVILEGES"

echo "Download WordPress."
wp core download --path="$INSTALL_DIR" --force

cd $INSTALL_DIR
echo "Install WordPress."
wp config create --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASS --force
wp core install --url="http://$HOSTNAME" --path="$INSTALL_DIR" --title=$SITENAME --admin_user="john" --admin_email="john@johnbeales.com" --admin_password=$DBPASS

echo "Install WP DB Migrate Pro."
# Install WP DB Migrate Pro
for file in $PLUGIN_SOURCE/**/*(.); 
do 
	wp plugin install $file --force --activate
done;

wp migratedb setting update license $DBMIGRATE_KEY --user=1

echo "Update all plugins."
# Update all plugins in case I have some old ones, (so I don't have to keep ZIP files up to date).
wp plugin update --all
	
echo "Pull from remote site."
# Pull the source site
wp migratedb pull $SOURCE_URL $SOURCE_KEY --skip-replace-guids --media=all --theme-files=all --plugin-files=all




echo "Done."
echo "Admin password: $DBPASS"


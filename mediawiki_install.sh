#!/bin/bash

####################################
##       Update the server        ##
####################################
sudo apt update && sudo apt upgrade -y

####################################
##   Install Required Packages    ##
####################################
# This will install Apache, a MariaDB database, PHP programming language, and some dependency packages.

sudo apt-get install apache2 mariadb-server php php-mysql libapache2-mod-php php-xml php-mbstring -y

#############################################
##   Install Mediawiki optional packages   ##
#############################################
sudo apt-get install php-apcu php-intl imagemagick inkscape php-gd php-cli php-curl php-bcmath git -y

# After installing the php-acpu you will need to restart the apache service to avoid an error.
sudo service apache2 reload


##########################################
##    Install Mediawiki from Source     ##
##########################################
# First we move into the tmp folder and use wget to pull the installer.
cd /tmp/
wget https://releases.wikimedia.org/mediawiki/1.36/mediawiki-1.36.0.tar.gz

# Next we decompress the tar.gz file, known as "unzipping"
tar -xvzf /tmp/mediawiki-*.tar.gz

# Create the directory that mediawiki should be house in
sudo mkdir /var/lib/mediawiki
sudo mv mediawiki-*/* /var/lib/mediawiki

#############################################
## Configure MySQL/MariaDB Root Account    ##
#############################################

# The next steps are going to be manual as we will be bouncing in and out of MySQL/MariaDB
# Log into MySQL as the root user
# This password will be blank, and you can press enter after this line to leave it blank or enter your own.
sudo mysql -u root -p

# Next you will see a line that says "mysql>" - this denotes that you are in the MySQL shell now.
# Here we will create the new user and set the password
CREATE USER 'my_wiki_user'@'localhost' IDENTIFIED BY 'P@ssw0rd';

# Next will create a database for the wiki
CREATE DATABASE my_wiki;

# We need to set this database as the MySQL default DB
use my_wiki;
# We need to allow the my_wiki_user access to the my_wiki DB
GRANT ALL ON my_wiki.* TO 'my_wiki_user'@'localhost';
quit;


#################
## Last Steps! ##
#################

# We're almost there! We need to link our Mediawiki installation to the directory that Apache's serving out of:
sudo ln -s /var/lib/mediawiki /var/www/html/mediawiki
# Then we need to manually activate a few extensions, and restart Apache
sudo phpenmod mbstring
sudo phpenmod xml
sudo systemctl restart apache2.service
# Let the user know that the installation is complete:
echo "Mediawiki installation is complete, please navigate to http://localhost/mediawiki/mw-config/index.php or replace localhost with server IP to complete configuration."


#####################
## We're all set!! ##
#####################
# Once you complete the configuration in the browser, and download the LocalSettings.php file, place the file in /var/lib/mediawiki

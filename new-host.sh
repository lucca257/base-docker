#!/bin/bash
# Functions
ok() { echo -e '\e[32m'$1'\e[m'; } # Green

# Variables
NGINX_SITES='nginx/sites'
WEB_DIR='/var/www'
WEB_USER='www-data'
USER='ali'
NGINX_SCHEME='$scheme'
NGINX_REQUEST_URI='$request_uri'
COMPUTER_IP=$(hostname -I | awk '{print $1}')

# Sanity check
[ $(id -g) != "0" ] && die "Script must be run as root."

echo "What is the project name? (*should be the same as the git name)"
read PROJECT_NAME

# Check if project already exists
IGNORE_HOST=false
grep -q $PROJECT_NAME /etc/hosts; [ $? -eq 0 ] && IGNORE_HOST=true

echo "Would you like to use the default php version 7.4? (y/n) - The second option will use php 8.0"
read PHP_DEFAULT

if [ $PHP_DEFAULT = "y" ]; then
    echo "Using php 7.4"
    PHP_VERSION="7"
else
    echo "Using php 8.0"
    PHP_VERSION="8"
fi

echo "*** Adding new nginx site file ***"
cat >"$NGINX_SITES/$PROJECT_NAME.conf" <<EOF
listen 80;
    listen [::]:80;

    server_name $PROJECT_NAME.test;
    root /var/www/$PROJECT_NAME/public;
    index index.php index.html;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
        gzip_static on;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass workspace_php$PHP_VERSION:9000;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }

    error_log /var/log/nginx/$PROJECT_NAME.log;
    access_log /var/log/nginx/$PROJECT_NAME.log;
EOF

if [ $IGNORE_HOST = false ]; then
    echo "*** Adding new host ***"
    echo "$COMPUTER_IP $PROJECT_NAME.test" >> /etc/hosts
fi
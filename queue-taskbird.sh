#!/bin/bash
cd ~/TidyDaily/docker/

ECHO "*** STARTING BOOKING ***"
gnome-terminal -x sh -c 'docker exec -it workspace_php8 sh -c "cd booking-api && php artisan consumers:work --topic=taskbird.booking.project.statuschanges"'

ECHO "*** STARTING TASKBIRD ***"
gnome-terminal -x sh -c 'docker exec -it workspace_php7 sh -c "cd taskuro-api && php artisan consumers:work --topic=booking.orders.confirmed"'
gnome-terminal -x sh -c 'docker exec -it workspace_php7 sh -c "cd taskuro-api && php artisan queue:listen --queue=low,medium,high,default"'



#gnome-terminal -x sh -c 'docker exec -it workspace_php7 sh -c "cd taskuro-api && php artisan migrate:fresh --seed && php artisan passport:install"'

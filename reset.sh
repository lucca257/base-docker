#!/bin/bash
cd ~/TidyDaily/docker/

gnome-terminal -x sh -c 'docker exec -it workspace_php8 sh -c "cd booking-api && php artisan migrate:fresh --seed'
gnome-terminal -x sh -c 'docker exec -it workspace_php7 sh -c "cd taskuro-api && pphp artisan migrate:fresh --seed && php artisan passport:install"'

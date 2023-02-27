#!/bin/bash
cd ~/TidyDaily/docker/

docker-compose down && docker-compose up --build nginx mysql_testing redis


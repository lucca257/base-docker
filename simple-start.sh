#!/bin/bash
cd ~/TidyDaily/docker/

docker-compose down && docker-compose up nginx mysql_testing redis


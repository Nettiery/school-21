#!/usr/bin/env bash


gcc ./mini_server.c -l fcgi -o ./mini_server
spawn-fcgi -p 8080 ./mini_server
nginx -g 'daemon off;'
nginx -s reload
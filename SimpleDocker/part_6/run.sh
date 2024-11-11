#!/usr/bin/env bash


gcc mini_server.c -lfcgi -o mini_server
service nginx start
nginx -s reload
spawn-fcgi -p 8080 mini_server
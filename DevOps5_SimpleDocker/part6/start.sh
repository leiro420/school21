#!/bin/sh

spawn-fcgi -p 8080 -u nginx -g nginx /app/hello.fcgi

exec nginx -g "daemon off;"

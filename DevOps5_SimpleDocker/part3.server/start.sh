#!/bin/bash

apt update && apt install -y libfcgi-dev spawn-fcgi gcc

gcc -o hello.fcgi hello.c -lfcgi

spawn-fcgi -p 8080 -- hello.fcgi

nginx -s reload

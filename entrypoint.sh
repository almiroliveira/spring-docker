#!/bin/bash

service nginx start &
sleep 5 
service nginx status &
supervisord -c /conf/supervisor.conf 
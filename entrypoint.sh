#!/bin/bash

service nginx start &
service nginx status &
supervisord -c /conf/supervisor.conf 
#!/bin/bash
pg_ctlcluster 10 main start
service redis-server start
service nginx start
code-server

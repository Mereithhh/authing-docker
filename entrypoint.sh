#!/bin/bash
service redis-server start 
pg_ctlcluster 10 main start

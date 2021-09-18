#!/bin/bash
pg_ctlcluster 10 main start
redis-server

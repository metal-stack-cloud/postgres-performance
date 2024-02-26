#!/bin/bash

for i in `seq 1 2`; do
    PGSERVICEFILE=$HOME/.pg_service.conf PGSERVICE=pgbench bash bench.sh 15
done

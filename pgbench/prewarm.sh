#!/bin/bash

PGVERSION=$1

[ -z "${PGVERSION}" ] && echo "usage: $(basename $0) <PG VERSION>" && exit 1

/usr/pgsql-${PGVERSION}/bin/psql -d pgbench <<EOF
CREATE EXTENSION IF NOT EXISTS pg_prewarm;
SELECT pg_prewarm(oid) FROM pg_class WHERE relname LIKE E'pgbench\\_%';
EOF

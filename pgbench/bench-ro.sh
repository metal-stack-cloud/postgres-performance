#!/bin/bash

set -e

PGVERSION=$1

[ -z "${PGVERSION}" ] && echo "usage: $(basename $0) <PG VERSION>" && exit 1

echo INIT
/usr/pgsql-${PGVERSION}/bin/dropdb --if-exists pgbench
/usr/pgsql-${PGVERSION}/bin/createdb pgbench
PGOPTIONS="--synchronous-commit=on --max-parallel-maintenance-workers=6" /usr/pgsql-${PGVERSION}/bin/pgbench -i -s 1250 pgbench >> bench-ro.log 2>&1

echo PREWARM
/usr/pgsql-${PGVERSION}/bin/psql -c "CHECKPOINT"
bash prewarm.sh ${PGVERSION}

echo BENCH

for i in `seq 1 3`; do
    PGOPTIONS=--synchronous-commit=on /usr/pgsql-${PGVERSION}/bin/pgbench -S -T 300 -Mprepared -c 24 -j 8 pgbench >> bench-ro.log
done

echo CLEANUP
/usr/pgsql-${PGVERSION}/bin/dropdb --if-exists pgbench

mv bench-ro.log bench-ro-$$.log
echo results stored in bench-ro-$$.log

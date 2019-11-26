#!/bin/bash
db_status=1
until [ $db_status -eq 0 ]; do
    sleep 1s
    pg_isready -h postgres -p 5432
    db_status=$?
done
./tivok-api serve -e prod -b 0.0.0.0

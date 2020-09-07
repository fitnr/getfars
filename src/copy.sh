#!/bin/bash

# This script takes three arguments: 
# A zip file containing csvs, a schema name, and a table name, which should match a name of a CSV file in the ZIP

zip=$1
schema=$2
table=$3

# remove possible BOM
hed=$(unzip -Cp "$zip" "${table}.csv" | head -n 1 | awk '{sub(/^\xef\xbb\xbf/,"")}{print}')

echo "COPY ${schema}.${table}" 1>&2

unzip -Cp "$zip" "${table}.csv" | psql -c "COPY ${schema}.${table} ( $hed ) FROM STDIN (FORMAT csv, HEADER true, ENCODING 'windows-1252')"

zip=$1
schema=$2
table=$3
year=$4  

csv_file_root="${table}.csv"
csv_file_subdir="FARS${year}NationalCSV/${table}.csv"

csv_file=$(unzip -l "$zip" | grep -i -E "${table}\.csv" | awk '{print $NF}' | head -n 1)

if [ -z "$csv_file" ]; then
    echo "Error: Could not find ${table}.csv in the ZIP archive." >&2
    exit 1
fi

hed=$(unzip -Cp "$zip" "$csv_file" | head -n 1 | awk '{sub(/^\xef\xbb\xbf/,"")}{print}')

echo "COPY ${schema}.${table} ( $hed ) FROM STDIN (FORMAT csv, HEADER true, ENCODING 'windows-1252')" 1>&2

unzip -Cp "$zip" "$csv_file" | psql -c "COPY ${schema}.${table} ( $hed ) FROM STDIN (FORMAT csv, HEADER true, ENCODING 'windows-1252')"

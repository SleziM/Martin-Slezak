#!/bin/bash

echo '{
  "name": "Martin Slezak",
  "date": "'$(date +'%d-%m-%Y/%H:%M')'",
  "data": [' > report.json

for generator in $(cut -d',' -f1 filtrpw.csv | sort | uniq); do
  total_count=$(grep -c "^$generator," filtrpw.csv)
  min_length=$(grep "^$generator," mindelka.csv | wc -l)
  min_lower=$(grep "^$generator," malap.csv | wc -l)
  min_upper=$(grep "^$generator," velkap.csv | wc -l)
  min_digit=$(grep "^$generator," cislo.csv | wc -l)
  min_special=$(grep "^$generator," specialni.csv | wc -l)
  valid_prefix=$(grep "^$generator," unizacatek.csv | wc -l)
  valid_suffix=$(grep "^$generator," unikonec.csv | wc -l)
  score=$(( (min_length == total_count) + (min_lower == total_count) + (min_upper == total_count) + (min_digit == total_count) + (min_special == total_count) + (valid_prefix == total_count) + (valid_suffix == total_count) ))

  echo '{
    "type": "'$generator'",
    "total_count": '$total_count',
    "min_length": '$min_length',
    "min_lower": '$min_lower',
    "min_upper": '$min_upper',
    "min_digit": '$min_digit',
    "min_special": '$min_special',
    "valid_prefix": '$valid_prefix',
    "valid_suffix": '$valid_suffix',
    "score": '$score'
  },' >> report.json
done

# Remove the last comma and close the JSON array
sed -i '$ s/,$//' report.json
echo ']}' >> report.json


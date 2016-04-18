#!/bin/bash

user="$1"
passwd="$2"
db="$3"

rm /tmp/containers.csv /tmp/top_containers.csv

mysql -u $user --password=$passwd $db < container.sql
mysql -u $user --password=$passwd $db < top_container.sql 

for f in /tmp/containers.csv /tmp/top_containers.csv 
do
 echo "accession, resource, archival object, instance id, barcode, type 1, indicator 1, type 2, indicator 2, type 3, indicator 3, uri, locations\n" | cat - $f > temp && mv temp $f
done
daff --output /tmp/diff.csv /tmp/containers.csv /tmp/top_containers.csv
daff render --output /tmp/output.html /tmp/diff.csv 

mv /tmp/containers.csv $db.containers.csv
mv /tmp/top_containers.csv $db.top_containers.csv
mv /tmp/output.html $db.output.html
open $db.output.html

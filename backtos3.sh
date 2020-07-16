#!/usr/bin/env bash

echo "Getting DBs..."
echo " "
psql -t -A -c "SELECT datname FROM pg_database WHERE datname not in ('template0', 'template1', 'postgres')" > databases.txt

echo "DBs obtained:"
cat databases.txt
echo " "

while read DB_NAME; do

  echo "Dumping $DB_NAME..."

  TIMESTAMP=$(date +%F_%T | tr ':' '-')
  TEMP_FILE=$(mktemp tmp.XXXXXXXXXX)
  S3_FILE="s3://$BUCKET_NAME/$DB_NAME/$DB_NAME-$TIMESTAMP"

  pg_dump -Fc --no-acl $DB_NAME > $TEMP_FILE

  echo "dump succeed!"
  echo "uploading $DB_NAME to $BUCKET_NAME s3 bucket ($S3_FILE)"

  s3cmd put $TEMP_FILE $S3_FILE

  echo "upload succeed!"
  echo " "

  rm "$TEMP_FILE"

done < databases.txt

echo " "
echo "Backups finished!"
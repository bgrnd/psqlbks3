# psqlbks3
Simple Docker image for backup Postgres databases from an instance and upload to a S3 Bucket based on https://github.com/ateliedocodigo/docker-s3cmd

This image obtains the databases from a Postgres instance excluding templates and use the s3cmd to upload to a S3 bucket.  

#### build and run

    docker build -t bgrande/psqlbks3

    docker run -e PGHOST=10.0.0.12 \
               -e PGPORT=5432 \
               -e PGUSER=postgres \
               -e PGPASSWORD=XXXXXX \
               -e AWS_ACCESS_KEY_ID=AKIAIXXXXXXXXXXXXXX \
               -e AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx \
               -e BUCKET_NAME=postgres_bks \
               --name psqlbks3 \
               --rm bgrande/psqlbks3


##### output:
    Getting DBs...
    DBs obtained:
    database1
    database2
    database3
    
    Dumping database1...
    dump succeed!
    uploading database1 to postgres_bks s3 bucket (s3://postgres_bks/database1/database1-2020-07-16_03-00-26)
    upload: 'tmp.XXXXmFJaaD' -> 's3://postgres_bks/database1/database1-2020-07-16_03-00-26' (10377 bytes in 0.2 seconds, 60.16 KB/s) [1 of 1]
    upload succeed!
    
    Dumping database2...
    dump succeed!
    uploading database2 to postgres_bks s3 bucket (s3://postgres_bks/database2/database2-2020-07-16_03-00-28)
    upload: 'tmp.XXXXEMfLMc' -> 's3://postgres_bks/database2/database2-2020-07-16_03-00-28' (3031693 bytes in 1.5 seconds, 33.47 MB/s) [1 of 1]
    upload succeed!
        
    Dumping database3...
    dump succeed!
    uploading database3 to postgres_bks s3 bucket (s3://postgres_bks/database3/database3-2020-07-16_03-00-38)
    upload: 'tmp.XXXXnMljEC' -> 's3://postgres_bks/database3/database3-2020-07-16_03-00-38' (34290041 bytes in 1.3 seconds, 24.77 MB/s) [1 of 1]
    upload succeed!
    
    Backups finished!

### Run as a kubernetes cronjob 
Configure the image to run automatically with a CronJob inside you kubernetes cluster. Consider use Secrets or other 
mechanism to set up your passwords.
 
    kubectl create -f k8s-cronjob.yml 
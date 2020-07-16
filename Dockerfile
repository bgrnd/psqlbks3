FROM postgres:11-alpine

MAINTAINER Bernardo Grande <bernargrande@gmail.com>

RUN apk add --no-cache python3 py-pip py-setuptools ca-certificates libmagic curl
RUN pip install python-dateutil python-magic

RUN S3CMD_CURRENT_VERSION=`curl -fs https://api.github.com/repos/s3tools/s3cmd/releases/latest | grep tag_name | sed -E 's/.*"v?([0-9\.]+).*/\1/g'` \
    && mkdir -p /opt \
    && wget https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_CURRENT_VERSION}/s3cmd-${S3CMD_CURRENT_VERSION}.zip \
    && unzip s3cmd-${S3CMD_CURRENT_VERSION}.zip -d /opt/ \
    && ln -s $(find /opt/ -name s3cmd) /usr/bin/s3cmd \
    && ls /usr/bin/s3cmd

COPY backtos3.sh .

RUN chmod +x backtos3.sh

CMD ./backtos3.sh
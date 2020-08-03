FROM alpine:3.12

RUN apk add --update \
  mongodb-tools \
  build-base python3-dev python3 libffi-dev libressl-dev bash git gettext curl \
  && curl -O https://bootstrap.pypa.io/get-pip.py \
  && python3 get-pip.py \
  && pip install --upgrade pip \
  && pip install --upgrade six awscli awsebcli \
  && apk add --virtual build-deps \
  gcc \
  libffi-dev \
  linux-headers \
  musl-dev \
  openssl-dev \
  && pip install gsutil \
  && apk del build-deps \
  && rm -rf /var/cache/apk/*

ADD ./backup.sh /mongodb-gcs-backup/backup.sh
ADD ./initialize.sh /mongodb-gcs-backup/initialize.sh
WORKDIR /mongodb-gcs-backup

RUN chmod +x /mongodb-gcs-backup/backup.sh
RUN chmod +x /mongodb-gcs-backup/initialize.sh

CMD ["/mongodb-gcs-backup/initialize.sh"]

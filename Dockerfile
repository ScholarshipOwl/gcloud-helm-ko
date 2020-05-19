FROM golang as ko
RUN GO111MODULE=on go get github.com/google/ko/cmd/ko

# Now copy it into our base image.
FROM google/cloud-sdk
WORKDIR /usr/src/
RUN apt-get update -qqy \
    && apt-get install -qqy --no-install-recommends \
        bash curl ca-certificates git \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && rm -rf /var/lib/apt/lists/*
COPY --from=ko /go/bin/ko /usr/bin/

COPY docker-entrypoint.sh /

ENTRYPOINT [ "/bin/sh", "/docker-entrypoint.sh" ]
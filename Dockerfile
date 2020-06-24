# Now copy it into our base image.
FROM google/cloud-sdk

ARG HELMFILE_VERSION=v0.119.0

WORKDIR /usr/src/
RUN apt-get update -qqy \
    && apt-get install -qqy --no-install-recommends \
        bash curl ca-certificates git golang \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && rm -rf /var/lib/apt/lists/*

ENV GOPATH=/go
ENV PATH="/go/bin:${PATH}"
RUN GO111MODULE=on go get github.com/google/ko/cmd/ko

RUN curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v2.0.0/docker-credential-gcr_linux_amd64-2.0.0.tar.gz" \
    | tar xz --to-stdout ./docker-credential-gcr > /usr/local/bin/docker-credential-gcr \
    && chmod +x /usr/local/bin/docker-credential-gcr

ADD https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 /bin/helmfile
RUN chmod +x /bin/helmfile

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
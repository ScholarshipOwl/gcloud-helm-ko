# Now copy it into our base image.
FROM google/cloud-sdk

ARG HELMFILE_VERSION=0.156.0

WORKDIR /usr/src/
RUN apt-get update -qqy \
    && apt-get install -qqy --no-install-recommends \
        bash curl ca-certificates git wget \
    && wget https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz \
    && rm -rf go1.21.0.linux-amd64.tar.gz \
    && curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=$PATH:/usr/local/go/bin
RUN go install github.com/google/ko@latest

RUN curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v2.0.0/docker-credential-gcr_linux_amd64-2.0.0.tar.gz" \
    | tar xz --to-stdout ./docker-credential-gcr > /usr/local/bin/docker-credential-gcr \
    && chmod +x /usr/local/bin/docker-credential-gcr

# Install helmfile and required helm diff plugin
RUN curl -fsSL https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz \
    --output /bin/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz \
    && tar xzf  /bin/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz -C /bin \
    && helm plugin install https://github.com/databus23/helm-diff --version master

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
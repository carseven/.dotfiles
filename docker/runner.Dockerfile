FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN printf 'APT::Get::Assume-Yes "true";\n' > /etc/apt/apt.conf.d/90assume-yes

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        bash \
        ca-certificates \
        curl \
        findutils \
        git \
        gnupg \
        grep \
        lsb-release \
        nodejs \
        npm \
        software-properties-common \
        sudo \
        unzip \
        wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY run ./run
COPY runs ./runs
COPY shell ./shell
COPY docker/runner-entrypoint /usr/local/bin/runner-entrypoint

RUN chmod +x /workspace/run /usr/local/bin/runner-entrypoint

ENTRYPOINT ["/usr/local/bin/runner-entrypoint"]

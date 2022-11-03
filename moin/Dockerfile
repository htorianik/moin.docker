FROM ubuntu:latest

ARG MOIN_VERSION="1.9.11"
ARG MOIN_SHA256SUM="02be31d55f39d4fe0c6253df8b49e01b76d095634cbd1b56d185f66e1e0c3cf5"

# install dependecies
RUN apt update && apt install -y curl build-essential python2-dev build-essential

# install pip and uwsgi
RUN apt install -y python2 && \
    curl --output get-pip.py https://bootstrap.pypa.io/pip/2.7/get-pip.py && \ 
    python2 get-pip.py && \
    pip install uwsgi

COPY docker_root /
WORKDIR /opt/moin/etc

# create moin user and tmp folder
RUN useradd --create-home moin && \
    chown -R moin /opt/moin && \
    mkdir -p /tmp/moin/ /var/moin && \
    chown -R moin /tmp/moin /var/moin

USER moin

# download and install moin
RUN curl --output moin.tar.gz http://static.moinmo.in/files/moin-${MOIN_VERSION}.tar.gz && \
    echo "${MOIN_SHA256SUM}  moin.tar.gz" | sha256sum -c && \
    tar xzf moin.tar.gz && rm moin.tar.gz && \
    pip install ./moin-${MOIN_VERSION} && \
    mv ./moin-${MOIN_VERSION}/MoinMoin/web/static/htdocs /var/moin/static && \
    rm -rf moin-${MOIN_VERSION}

# making a volume for the instance
VOLUME /opt/moin/instance

# expose http port
EXPOSE 80

ENTRYPOINT [ "/entrypoint.sh" ]

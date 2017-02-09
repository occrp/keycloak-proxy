FROM golang:1.7.3
MAINTAINER Michał "rysiek" Woźniak <rysiek@occrp.org>

ENV GOOS=linux

RUN DEBIAN_FRONTEND=noninteractive apt-get -q update && \
    apt-get -q -y --no-install-recommends install ca-certificates && \
    apt-get -q clean && \
    apt-get -q -y autoremove && \
    rm -rf /var/lib/apt/lists/*

COPY ./ /go/src/keycloak-proxy/
RUN cd /go/src/keycloak-proxy/ && \
    make static
    
RUN mv /go/src/keycloak-proxy/bin/keycloak-proxy /opt/keycloak-proxy && \
    mv /go/src/keycloak-proxy/templates /opt/templates && \
    chmod a+x /opt/keycloak-proxy && \
    rm -rf /go/src/keycloak-proxy/

WORKDIR "/opt"

ENTRYPOINT [ "/opt/keycloak-proxy" ]

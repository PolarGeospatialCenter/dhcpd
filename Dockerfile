FROM golang:1.9-alpine as confd

ARG CONFD_VERSION=0.16.0

ADD https://github.com/kelseyhightower/confd/archive/v${CONFD_VERSION}.tar.gz /tmp/

RUN apk add --no-cache \
    bzip2 \
    make && \
  mkdir -p /go/src/github.com/kelseyhightower/confd && \
  cd /go/src/github.com/kelseyhightower/confd && \
  tar --strip-components=1 -zxf /tmp/v${CONFD_VERSION}.tar.gz && \
  go install github.com/kelseyhightower/confd && \
  rm -rf /tmp/v${CONFD_VERSION}.tar.gz

FROM alpine

RUN apk add --no-cache dhcp

COPY --from=confd /go/bin/confd /usr/local/bin/confd
COPY scripts/ /usr/local/bin/

RUN mkdir -p /var/lib/dhcp/ && chmod a+x /usr/local/bin/start.sh
RUN touch /var/lib/dhcp/dhcpd.leases
COPY confd/ /etc/confd/

CMD /usr/local/bin/start.sh

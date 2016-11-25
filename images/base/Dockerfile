FROM alpine:3.4

MAINTAINER Kalle R. Møller <docker@k-moeller.dk>

RUN apk add --no-cache \
         bash \
         vim \
         nano \
         tcpdump

ENV PS1 '\h:\w\$'

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

VOLUME ["/data"]

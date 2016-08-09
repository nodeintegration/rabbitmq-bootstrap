FROM alpine:3.4
MAINTAINER Brendan Beveridge <brendan@nodeintegration.com.au>

RUN apk add --no-cache curl 
ENV RANCHER_API_HOST rancher-metadata.rancher.internal
ENV RANCHER_API_VERSION 2015-12-19
ENV RANCHER_LABEL map-public-http

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bootstrap"]

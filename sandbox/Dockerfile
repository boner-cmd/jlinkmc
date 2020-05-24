FROM alpine:latest

RUN apk update && apk add --no-cache bash curl gnupg

COPY builder .
COPY template .

# TODO need to shoot curl requests at http://hkps.pool.sks-keyservers.net/#
# and see what a fully-formed request needs to look like to get back a
# machine-readable key (gpgkey.asc)

CMD ["bash", "./builder"]

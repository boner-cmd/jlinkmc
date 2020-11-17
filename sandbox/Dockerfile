FROM alpine:latest

RUN apk update && apk add --no-cache curl

COPY builder.sh .
COPY template.dockerfile .

ENTRYPOINT "./builder.sh"

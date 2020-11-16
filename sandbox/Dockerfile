FROM alpine:latest

RUN apk update && apk add --no-cache curl

COPY builder .
COPY template .

CMD ["bash", "./builder"]

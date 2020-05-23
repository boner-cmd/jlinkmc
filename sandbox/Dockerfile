FROM alpine:latest

RUN apk update && apk add --no-cache bash curl gpg

COPY builder .
COPY template .

# RUN bash builder

CMD ["bash", "./builder"]

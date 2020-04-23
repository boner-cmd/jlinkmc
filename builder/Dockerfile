FROM alpine

RUN apk update && apk add --no-cache bash curl

COPY builder .
COPY template .

# RUN bash builder

CMD ["bash", "./builder"]

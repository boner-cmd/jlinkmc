FROM curlimages/curl

RUN apk update && apk add --no-cache bash

COPY builder .
COPY template .

ENTRYPOINT ["builder"]
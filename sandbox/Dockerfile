FROM alpine:latest

RUN apk update && apk add --no-cache bash curl gnupg

COPY builder .
COPY template .

ENV POOLURL="https://hkps.pool.sks-keyservers.net/pks/lookup?search="
# This is Bartłomiej Piotrowski's master key
ENV MASTERKEY="0x487328A9"
ENV GETOPS="&options=mr&op=get"

RUN curl -kLsS "${POOLURL}${MASTERKEY}${GETOPS}" -o "${MASTERKEY}.asc" \
  && gpg --import "${MASTERKEY}.asc"

CMD ["bash", "./builder"]

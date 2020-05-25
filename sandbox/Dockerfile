FROM alpine:latest

RUN apk update && apk add --no-cache bash curl gnupg

COPY builder .
COPY template .

ENV POOLURL="https://hkps.pool.sks-keyservers.net/pks/lookup?search="
ENV GETOPS="&options=mr&op=get"
# This is Bartłomiej Piotrowski's master key id
ENV BARTALIONKEY="0x487328A9"
# This is Evangelos Foutras's developer key id
ENV FOUTRELISKEY="0xA9999C34"


RUN curl -kLsS "${POOLURL}${BARTALIONKEY}${GETOPS}" -o "${BARTALIONKEY}.asc" \
  && gpg --import "${BARTALIONKEY}.asc"

RUN curl -kLsS "${POOLURL}${FOUTRELISKEY}${GETOPS}" -o "${FOUTRELISKEY}.asc" \
  && gpg --import "${FOUTRELISKEY}.asc"

CMD ["bash", "./builder"]

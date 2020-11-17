#!/bin/sh

if [ ! -e template.dockerfile ]; then
  echo "No template in current directory." 1>&2 \
    && exit 1
fi

readonly GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases"
readonly SASHA_GERRAND_KEY_URL="https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub"

GLIBC_VER="$(curl -sS ${GLIBC_BASE_URL}/latest)" \
  && GLIBC_VER="${GLIBC_VER#*tag/}" \
  && GLIBC_VER="${GLIBC_VER%\"*}" \
  && readonly GLIBC_VER \
  || exit 1

readonly GLIBC_FULL_URL="${GLIBC_BASE_URL}/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk"
readonly GLIBC_BIN_URL="${GLIBC_BASE_URL}/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk"
readonly GLIBC_I18N_URL="${GLIBC_BASE_URL}/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk"
readonly GLIBC_FILENAME="glibc-$GLIBC_VER.apk"
readonly GLIBC_BIN_FILENAME="glibc-bin-$GLIBC_VER.apk"
readonly GLIBC_I18N_FILENAME="glibc-i18n-$GLIBC_VER.apk"

if [ ! -d working ]; then
  mkdir working
fi

cd working || exit 1

# file downloads are slow; output not suppressed to show script did not hang
curl -Lf "${SASHA_GERRAND_KEY_URL}" -O \
  || exit 1
curl -Lf "${GLIBC_FULL_URL}" "${GLIBC_BIN_URL}" "${GLIBC_I18N_URL}" -O -O -O \
  || exit 1

export sums
for file in *; do
  filesum=$(sha256sum "./${file}" | head -c 64)
  sums="${sums} $filesum"
done
readonly sums

# indices are hardcoded to assume only these four (4) files in this order:
# GLIBC, GLIBC BIN, GLIBC I18N, Sasha Gerrand's RSA
readonly GLIBC_FILE_SUM="$(echo "$sums" | awk '{print $1}')"
readonly GLIBC_BIN_SUM="$(echo "$sums" | awk '{print $2}')"
readonly GLIBC_I18N_SUM="$(echo "$sums" | awk '{print $3}')"
readonly SASHA_GERRAND_RSA_SUM="$(echo "$sums" | awk '{print $4}')"

cp ../template.dockerfile template

sed -i "s,SASHA_GERRAND_RSA_SUM_,${SASHA_GERRAND_RSA_SUM},; \
  s,SASHA_GERRAND_KEY_URL_,${SASHA_GERRAND_KEY_URL},; \
  s,GLIBC_FULL_URL_,${GLIBC_FULL_URL},; \
  s,GLIBC_VER_,${GLIBC_VER},; \
  s,GLIBC_FILENAME_,${GLIBC_FILENAME},; \
  s,GLIBC_FILE_SUM_,${GLIBC_FILE_SUM},; \
  s,GLIBC_BIN_URL_,${GLIBC_BIN_URL},; \
  s,GLIBC_BIN_FILENAME_,${GLIBC_BIN_FILENAME},; \
  s,GLIBC_BIN_SUM_,${GLIBC_BIN_SUM},; \
  s,GLIBC_I18N_URL_,${GLIBC_I18N_URL},; \
  s,GLIBC_I18N_FILENAME_,${GLIBC_I18N_FILENAME},; \
  s,GLIBC_I18N_SUM_,${GLIBC_I18N_SUM}," template \
|| exit 1

cat template

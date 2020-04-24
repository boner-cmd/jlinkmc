# please don't modify this file directly; it was generated using scripts
# this specific Dockerfile was generated Fri, 24 Apr 2020 19:16:19 +0000

# Determine which version of OpenJDK to use later
ARG JDK_VERSION=14

# Alpine base
FROM alpine AS prepack

# download binutils and deps so they won't need to be downloaded again later
# also download zstd since apk update occurs here

ENV SASHA_GERRAND_RSA_SUM="823b54589c93b02497f1ba4dc622eaef9c813e6b0f0ebbb2f771e32adf9f4ef2"
ENV SASHA_GERRAND_KEY_URL="https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub"

RUN mkdir /tmp/binutilscpy

WORKDIR /tmp/binutilscpy

RUN apk update \
	&& apk upgrade \
	&& apk fetch binutils \
				libgcc \
				libstdc++ \
	&& apk add /tmp/binutilscpy/* \
				zstd \
				curl \
	&& curl -LfsS "${SASHA_GERRAND_KEY_URL}" -o /etc/apk/keys/sgerrand.rsa.pub \
  && echo "${SASHA_GERRAND_RSA_SUM} */etc/apk/keys/sgerrand.rsa.pub" | sha256sum -c -

# AdoptOpenJDK image on an Alpine base
FROM adoptopenjdk/openjdk${JDK_VERSION}:alpine AS jlink

COPY --from=prepack /tmp/binutilscpy /tmp/binutilscpy

RUN apk add /tmp/binutilscpy/*

RUN ["/opt/java/openjdk/bin/jlink", "--compress=2", "--bind-services", \
  "--strip-debug", "--module-path", "/opt/java/openjdk/jmods", \
  "--add-modules", \
	"java.base,java.compiler,java.desktop,java.logging,java.management,java.naming,java.rmi,java.scripting,java.sql,java.xml,jdk.sctp,jdk.unsupported,java.instrument", \
  "--no-header-files", "--no-man-pages", "--output", "/jlinked"]

FROM prepack

COPY --from=jlink /jlinked /opt/java/openjdk
ENV PATH="/opt/java/openjdk/bin:${PATH}"

WORKDIR /tmp

RUN mkdir gcc libz

WORKDIR /tmp/depends

ENV GCC_FULL_URL="https://archive.archlinux.org/packages/g/gcc-libs/gcc-libs-9.3.0-1-x86_64.pkg.tar.zst"
ENV GCC_LIBS_VER="gcc-libs-9.3.0-1-x86_64"
ENV GCC_FILENAME="gcc-libs-9.3.0-1-x86_64.pkg.tar.zst"
ENV GCC_FILE_SUM="ccba6f5341008a3d693d7aeaf2423d2339a690b739b23a52dd03335acbcd94ab"
ENV GCC_TAR_NAME="gcc-libs-9.3.0-1-x86_64.pkg.tar"
ENV GLIBC_FULL_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk"
ENV GLIBC_VER="2.31-r0"
ENV GLIBC_FILENAME="glibc-2.31-r0.apk"
ENV GLIBC_FILE_SUM="c25ff560aadca08d5794b8cd20ef8b0813e6f223e6ccc7c037de91968e21691c"
ENV GLIBC_BIN_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-bin-2.31-r0.apk"
ENV GLIBC_BIN_FILENAME="glibc-bin-2.31-r0.apk"
ENV GLIBC_BIN_SUM="0ec6179acee1c7d029f2a107a8955db7e91f668bb050de48ec142e8068d245b2"
ENV GLIBC_I18N_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-i18n-2.31-r0.apk"
ENV GLIBC_I18N_FILENAME="glibc-i18n-2.31-r0.apk"
ENV GLIBC_I18N_SUM="af2841582de5d1523bf31f488039a8cd56a156b8a521fa271aa55a952e52deea"
ENV ZLIB_FULL_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A1.2.11-4-x86_64.pkg.tar.xz"
ENV ZLIB_VER="zlib-1%3A1.2.11-4-x86_64"
ENV ZLIB_FILENAME="zlib-1%3A1.2.11-4-x86_64.pkg.tar.xz"
ENV ZLIB_FILE_SUM="e7353cbac10b87f923d62dc34fdca98abab364668a828978d40a81e47deabd90"

RUN curl -LfsS "${GCC_FULL_URL}" -O \
	&& curl -LfsS "${GLIBC_FULL_URL}" "${GLIBC_BIN_URL}" "${GLIBC_I18N_URL}" -O -O -O \
	&& curl -LfsS "${ZLIB_FULL_URL}" -O \
	&& echo "${GCC_FILE_SUM}  ${GCC_FILENAME}" | sha256sum -c - \
	&& echo "${GLIBC_FILE_SUM}  ${GLIBC_FILENAME}" | sha256sum -c - \
	&& echo "${GLIBC_BIN_SUM}  ${GLIBC_BIN_FILENAME}" | sha256sum -c - \
	&& echo "${GLIBC_I18N_SUM}  ${GLIBC_I18N_FILENAME}" | sha256sum -c - \
	&& echo "${ZLIB_FILE_SUM}  ${ZLIB_FILENAME}" | sha256sum -c - \
	&& apk del --purge curl \
	&& apk add --no-cache glibc-${GLIBC_VER}.apk \
					glibc-bin-${GLIBC_VER}.apk \
					glibc-i18n-${GLIBC_VER}.apk \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
	&& unzstd "${GCC_FILENAME}" -o "${GCC_TAR_NAME}" \
	&& tar -xf "${GCC_TAR_NAME}" -C /tmp/gcc \
    && mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib \
    && strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* \
    && tar -xf ${ZLIB_FILENAME} -C /tmp/libz \
    && mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib \
	&& apk del --purge binutils \
						glibc-i18n \
						zstd \
    && rm -r /tmp/gcc \
			/tmp/depends \
			/tmp/libz \
			/tmp/binutilscpy \
			/var/cache/apk/*

CMD ["java", "-version"]

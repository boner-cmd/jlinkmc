# please don't modify this file directly; it was generated using scripts
# this specific Dockerfile was generated Tue, 16 Feb 2021 00:31:03 +0000

# Determine which version of OpenJDK to use later
ARG JDK_VERSION=15

# Alpine base
FROM alpine:latest AS prepack

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
ENV GLIBC_FULL_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk"
ENV GLIBC_VER="2.32-r0"
ENV GLIBC_FILENAME="glibc-2.32-r0.apk"
ENV GLIBC_FILE_SUM="2a3cd1111d2b42563e90a1ace54c3e000adf3a5a422880e7baf628c671b430c5"
ENV GLIBC_BIN_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-bin-2.32-r0.apk"
ENV GLIBC_BIN_FILENAME="glibc-bin-2.32-r0.apk"
ENV GLIBC_BIN_SUM="d5bd83be68d92cf473d63dab57e28bd1bcd1a2706bbe1889f381262e9b4103a1"
ENV GLIBC_I18N_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-i18n-2.32-r0.apk"
ENV GLIBC_I18N_FILENAME="glibc-i18n-2.32-r0.apk"
ENV GLIBC_I18N_SUM="403aad102335eee461a2ef3d7221a353c68bac4480418863179892b03e7ae2ea"
ENV ZLIB_FULL_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A1.2.11-4-x86_64.pkg.tar.xz"
ENV ZLIB_VER="zlib-1%3A1.2.11-4-x86_64"
ENV ZLIB_FILENAME="zlib-1%3A1.2.11-4-x86_64.pkg.tar.xz"
ENV ZLIB_FILE_SUM="43a17987d348e0b395cb6e28d2ece65fb3b5a0fe433714762780d18c0451c149"

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

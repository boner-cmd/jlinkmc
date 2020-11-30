# please don't modify this file directly; it was generated using scripts

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

WORKDIR /tmp/depends

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

# TODO ensure symlinks don't cause issues when original files are stripped

RUN curl -LfsS "${GLIBC_FULL_URL}" "${GLIBC_BIN_URL}" "${GLIBC_I18N_URL}" -O -O -O \
	&& echo "${GLIBC_FILE_SUM}  ${GLIBC_FILENAME}" | sha256sum -c - \
	&& echo "${GLIBC_BIN_SUM}  ${GLIBC_BIN_FILENAME}" | sha256sum -c - \
	&& echo "${GLIBC_I18N_SUM}  ${GLIBC_I18N_FILENAME}" | sha256sum -c - \
	&& apk add --no-cache glibc-${GLIBC_VER}.apk \
		                    glibc-bin-${GLIBC_VER}.apk \
					              glibc-i18n-${GLIBC_VER}.apk \
  && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
  && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
  && ln -s /usr/lib/libgcc* /usr/glibc-compat/lib \
  && ln -s /usr/lib/libstdc++.so* /usr/glibc-compat/lib \
  && ln -s /lib/libz.so* /usr/glibc-compat/lib \
  && strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* \
	&& apk del --purge binutils \
                     curl \
						         glibc-i18n \
						         zstd \
  && rm -r /tmp/depends \
			     /tmp/binutilscpy \
			     /var/cache/apk/*

CMD ["java", "-version"]

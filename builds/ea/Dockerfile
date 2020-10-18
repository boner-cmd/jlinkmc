FROM alpine:latest AS jlink

RUN mkdir -p /opt/java/openjdk

WORKDIR /opt/java/openjdk

ENV EA_NUM="16"

ENV JDK_FILENAME="openjdk-16-ea+14_linux-x64-musl_bin.tar.gz"

# TODO test if binutils, libgcc, and libstdc++ are needed for jlink
# TODO autograb the EA build link, filename, and SHA256
# TODO check the SHA256, especially since it's provided

RUN apk update \
  && apk add --no-cache curl binutils libgcc libstdc++ \
  && curl -Lf https://download.java.net/java/early_access/alpine/14/binaries/${JDK_FILENAME} -O \
  && tar -xzf ${JDK_FILENAME} \
  && mv jdk-${EA_NUM}/* . \
  && rm -r jdk-${EA_NUM} \
  && rm ${JDK_FILENAME} \
  && apk del --purge curl

RUN ["/opt/java/openjdk/bin/jlink", "--compress=2", "--bind-services", \
  "--strip-debug", "--module-path", "/opt/java/openjdk/jmods", \
  "--add-modules", \
	"java.base,java.compiler,java.desktop,java.logging,java.management,java.naming,java.rmi,java.scripting,java.sql,java.xml,jdk.sctp,jdk.unsupported,java.instrument", \
  "--no-header-files", "--no-man-pages", "--output", "/jlinked"]

FROM alpine:latest

COPY --from=jlink /jlinked /opt/java/openjdk
ENV PATH="/opt/java/openjdk/bin:${PATH}"

CMD ["java", "-version"]

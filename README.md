![Docker](https://github.com/boner-cmd/JLinkMC/workflows/Docker/badge.svg?branch=master)

# Tag Equivalence

+ `latest` `stable` `jdk15`
+ `oldstable` `jdk14`
+ `ea` `jdk16`

Stability refers to the JDK, not to the container, which is _perpetually unstable_.

# Concept

Using this image to prepare a [PaperMC](https://papermc.io/) or other Minecraft server on an Alpine base can substantially reduce the total size of your image. The code used was based on posts from [Matthew Gilliard](https://github.com/mjg123)'s blog ([like this one](https://blog.gilliard.lol/2018/11/05/alpine-jdk11-images.html)), themselves based on work on AdoptOpenJDK by Dinakar Guniguntala ([dinogun](https://github.com/dinogun)) and others.

The `latest` tag is NOT an Alpine-native muslc (Portola) Java build. Instead, it uses [Sasha Gerrand](https://github.com/sgerrand)'s Gnu C library compatibility layer package for Alpine.

The transition to Portola or another muslc build will occur when an Alpine JDK reaches General Availability and will result in further size reduction. Unfortunately, Alpine JDKs haven't been making the testing volume threshold for GA status and keep getting rolled to the next EA candidate. The build using the early access JDK can be found in the `ea` tag.

# Compressed Size Comparison of linux/amd64 images

![Size Reduction](https://img.shields.io/badge/Size%20Reduction-64.69%25-brightgreen)

+ ethco/jlinkmc:jdk16 - 53.76 MB

+ ethco/jlinkmc:jdk15 - 73.09 MB

+ AdoptOpenJDK/openjdk15:alpine - 206.99 MB

+ AdoptOpenJDK:latest - 240.61 MB

# Contents

This image was jlinked using the following Java modules, which, to the best of my knowledge, are the minimum required to run PaperMC:

+ java.base
+ java.compiler
+ java.desktop
+ java.logging
+ java.management
+ java.naming
+ java.rmi
+ java.scripting
+ java.sql
+ java.xml
+ jdk.sctp
+ jdk.unsupported
+ java.instrument

Minecraft itself requires all of the above except java.instrument

# Source

I track my own edits on [GitHub](https://github.com/boner-cmd/jlinkmc). Builds for the current GA JDK, the previous JDK, and the current EA JDK are automated by GitHub Actions. Issues are enabled, so if something doesn't work, let me know! Testing and any other suggestions are always welcomed.

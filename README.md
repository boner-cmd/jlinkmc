![Docker](https://github.com/boner-cmd/JLinkMC/workflows/Docker/badge.svg?branch=master) ![Get Servers](https://github.com/boner-cmd/JLinkMC/workflows/Get%20Servers/badge.svg)

# Tag Equivalence

+ `latest` `stable` `jdk14`
+ `oldstable` `jdk13`
+ `ea` `jdk15`

Stability refers to the JDK, not to the container, which is _perpetually unstable_.

# Concept

Using this image to prepare a [PaperMC](https://papermc.io/) or other Minecraft server on an Alpine base can substantially reduce the total size of your image. The code used was based on posts from [Matthew Gilliard](https://github.com/mjg123)'s blog ([like this one](https://blog.gilliard.lol/2018/11/05/alpine-jdk11-images.html)), themselves based on work on AdoptOpenJDK by Dinakar Guniguntala ([dinogun](https://github.com/dinogun)) and others.

The `latest` tag is NOT an Alpine-native muslc (Portola) Java build. Instead, it uses [Sasha Gerrand](https://github.com/sgerrand)'s Gnu C library compatibility layer package for Alpine.

The transition to Portola or another muslc build will occur when JDK15 reaches general availability, currently scheduled for 15 September, 2020, and will result in further size reduction. The build using the early access JDK can be found in the `ea` tag.

# Compressed Size Comparison of linux/amd64 images

![Size Reduction](https://img.shields.io/badge/Size%20Reduction-35.12%25-brightgreen)

+ ethco/jlinkmc:jdk15 - 55.15 MB

+ ethco/jlinkmc:jdk14 - 74.06 MB

+ AdoptOpenJDK/openjdk14:alpine - 210.88 MB

+ AdoptOpenJDK:latest - 240.38 MB

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

# Goals

+ Implement functionality testing for successfully-built images
+ Add support for PGP-based signature verification, [despite its shortcomings](https://arstechnica.com/information-technology/2016/12/op-ed-im-giving-up-on-pgp/)

# Source

I track my own edits on [GitHub](https://github.com/boner-cmd/jlinkmc). Builds for JDK 13, JDK 14, and JDK 15 are automated by GitHub Actions. Issues are enabled, so if something doesn't work, then I look forward to the challenge of correcting it. Test (and any other) suggestions are always welcomed.

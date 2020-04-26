# Compressed Size Comparison

(As of 20200425)

+ ethco/jlinkmc:jdk15ea - 55.14 MB

+ ethco/jlinkmc:jdk14 - 75.56 MB

+ AdoptOpenJDK/openjdk14:alpine - 210.87 MB

# Concept

Using this image to prepare a [PaperMC](https://papermc.io/) or other Minecraft server on an Alpine base can substantially reduce the total size of your image. The code used was based on posts from Matthew Gilliard's blog ([like this one](https://blog.gilliard.lol/2018/11/05/alpine-jdk11-images.html)), themselves based on work on AdoptOpenJDK by Dinakar Guniguntala ([dinogun](https://github.com/dinogun)) and others.

The`jdk14` tag is NOT an Alpine-native muslc (Portola) Java build. Instead, it uses [Sasha Gerrand](https://github.com/sgerrand)'s Gnu C library compatibility layer package for Alpine.

The transition to Portola or another muslc build will occur when JDK15 reaches general availability, currently scheduled for 15 September, 2020, and will result in further size reduction. Progress during early access should be considered perpetually unstable, and can be found in the `jdk15ea` tag.

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

# Goals

+ Run more tests using the early access Alpine version of JDK15
+ Add support for PGP-based signature verification, [despite its shortcomings](https://arstechnica.com/information-technology/2016/12/op-ed-im-giving-up-on-pgp/)

# Source

I track my own edits on [GitHub](https://github.com/boner-cmd/jlinkmc). The build process for the current tag (jdk14) is now nearly entirely automated, but development on the jdk15 early access branch is not. Issues are enabled, so if something doesn't work, then I look forward to the challenge of correcting it.

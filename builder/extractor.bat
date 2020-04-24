@ECHO OFF
SETLOCAL
SET /p jdk=Enter JDK to use in builder
@ECHO ON
docker build --build-arg JDK_VERSION=%jdk% -t bone4cmdr/jlinkmc:builder .
docker run --name buildercon bone4cmdr/jlinkmc:builder
docker cp buildercon:/working/template .\output\Dockerfile
@ECHO OFF
docker stop buildercon >nul
docker rm buildercon >nul
PAUSE

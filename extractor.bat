@ECHO OFF
pushd %~dp0
pushd .\builder
If %errorlevel% NEQ 0 goto:eof
@ECHO ON
docker build -t bone4cmdr/jlinkmc:builder .
docker run --name buildercon bone4cmdr/jlinkmc:builder
docker cp buildercon:/working/template .\output\Dockerfile
@ECHO OFF
docker stop buildercon >nul
docker rm buildercon >nul
@ECHO ON
popd
copy .\builder\output\Dockerfile
@ECHO OFF
setlocal
set /p jdkvers_=Use which JDK version? :
@ECHO ON
docker build --build-arg JDK_VERSION=%jdkvers_% -t bone4cmdr/jlinkmc:%jdkvers_% .
PAUSE
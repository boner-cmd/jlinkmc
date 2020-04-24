docker build -t bone4cmdr/jlinkmc:builder .
docker run --name buildercon bone4cmdr/jlinkmc:builder
docker cp buildercon:/working/template .\output\Dockerfile
docker stop buildercon >nul
docker rm buildercon >nul
PAUSE

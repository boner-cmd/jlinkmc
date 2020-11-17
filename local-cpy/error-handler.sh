# shellcheck shell=sh
# from https://stackoverflow.com/a/12704488
# by https://stackoverflow.com/users/1169096/uml%c3%a4ute

error() {
  echo "$@" 1>&2
}

fail() {
  error "$@"
  exit 1
}

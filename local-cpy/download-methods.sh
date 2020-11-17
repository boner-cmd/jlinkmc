# shellcheck shell=sh

# requires curl

. ./error-handler.sh

download() {
  bad_first_opt="Download method was called without a valid filename input."
  bad_second_opt='Specify "file" or "hash" to download.'
  download_type= # 'f' for file or 'h' for hash

  if [ "$1" ]
  then

    if [ "$2" ]
    then

      if [ "$3" ]
      then
        fail "Too many arguments."
      fi

      case "$2" in
        ^f) download_type="f";;
        ^h) download_type="h";;
        *) fail "$bad_second_opt"
      esac

    else
      fail "$bad_second_opt"
    fi

    case "$1" in
      e*) get_ea_jdk "$download_type";;
      *) fail "$bad_first_opt"
    esac

  else
    fail "$bad_first_opt"
  fi
}

get_ea_jdk() {
  jdk_sed_args="/access:/ !d; \
                s,.*\([0-9][0-9]\).*,\1,"
  jdk_ea_ver=$(sed "${jdk_sed_args}")
  jdk_url="https://jdk.java.net/${jdk_ea_ver}/"
  alpine_sed_args="/alpine/ !d; \
            s,.*href=\",,g; \
            s,\">.*,,g; \
            /sha256/" # not valid until 'd' appended
  append_remote= # defined here to prevent scope issues

  case "$1" in
    f) alpine_sed_args="${alpine_sed_args}d"
       append_remote=$(false);;
    h) alpine_sed_args="${alpine_sed_args}!d"
       append_remote=$(true);;
  esac

  target_url=$(curl -sS "${jdk_url}" | sed "${alpine_sed_args}")
  target_name="${target_url##h*/}"

  if [ "$append_remote" ]
  then
    target_name="${target_name}.remote" # satisfies requirement in local-cpy
  fi

  curl -sS "${target_url}" -o "${target_name}"
}

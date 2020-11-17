#!/bin/sh

# requires gnupg
# indirectly requires curl for download-methods
# assumes existence of github secret passed as env variable GPG_PASSPHRASE
# decrypt with gpg --batch --passphrase "$GPG_PASSPHRASE" file.gpg

# TODO need a workflow that doesn't rely on clobbering filenames

. ./download-methods.sh
. ./supported-files.sh
. ./error-handler.sh

# see if a file is on the supported files list

check_file_list(){
  for somefile in $valid_files
  do
    if [ "${1}" = "${somefile}" ]
    then
      return
    fi
  done
  fail "File not found in the list of valid files."
}

exists_in_local(){
  name_partial="${1}"
  file_hits=0
  for file in "${name_partial}"*
  do
    if [ -e "${file}" ]
    then
    file_hits=$((file_hits + 1))
    fi
  done

  if $file_hits -eq 0
  then
    return
  elif $file_hits -eq 1
  then
    return
  else
    error "Check for existing file encountered more than one positive result."
    fail "Bad filename glob used to determine if local file exists."
  fi
}

hash_file(){
  shasum=$(sha256sum "$1")
  echo "${shasum%% *}" > "${1}.sha256"
}

encrypt_local(){
  # TODO add error handling
  gpg --batch --cipher-algo CAMELLIA128 --passphrase "$GPG_PASSPHRASE" -c "$1"
}

compare_hashes(){
  hash_name="${1}.sha256"
  remote_hash_name="${hash_name}.remote" # naming enforced by download method
  download "$1" "hash"
  local_hash=$(cat "$hash_name")
  remote_hash=$(cat "$remote_hash_name")
  rm "$remote_hash_name"
  [ "$remote_hash" = "$local_hash" ]
  return
}

move_previous(){
  mv -n -t ./old ./"$1"*
}

remove_orphans(){
  for file in ./* ; do
    trimmed_ext="${file##*.}" # TODO will trim wrong if periods in filename?
    if [ "$trimmed_ext" != "sha256" ]
    then
      if [ ! -e "${file}.sha256" ]
      then
        rm "$file"
      fi
    else
      trimmed_filename="${file%.*}"
      if [ ! -e "$trimmed_filename" ]
      then
        rm "$file"
      fi
    fi
  done
}

main() {
  if [ "$2" ]
  then
    fail "Incorrect number of arguments. Only pass pre-formatted file name."
  fi
  remove_orphans
  check_file_list "$1"
  if exists_in_local "$1"
  then
    if compare_hashes "$1"
    then
      exit 0
    fi
  fi
  move_previous "$1"
  download "$1" "file"
  hash_file "$1"
  encrypt_local "$1"
}

main "$@"

#!/bin/bash

print_usage() {
  echo "Search for a particular file pattern recursively contained in an archive or directory"
  echo "Usage: $0 ARCHIVE_PATH"
}

search_extract_recurse() {
  if [ -z "$1" ]; then
    return
  fi
  find $1 -name $FILENAME_PATTERN -print
  local ARCHIVE_LIST=$(find $1 '(' -name '*.zip' -o -name '*.war' -o -name '*.ear' ')')
  for NEXT_ARCHIVE in $ARCHIVE_LIST; do
    local EXTRACTED_DIR="${NEXT_ARCHIVE}-extracted"
    mkdir $EXTRACTED_DIR
    echo
    echo "Extracting file: $NEXT_ARCHIVE"
    unzip -q -o -d "$EXTRACTED_DIR" "$NEXT_ARCHIVE"
    search_extract_recurse "$EXTRACTED_DIR"
  done
}

if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  print_usage
  exit
fi

ARCHIVE_PATH=$1
TMP_DIR="/tmp/${0%.*}-${RANDOM}"
FILENAME_PATTERN="*.jar"

if [ ! -d $TMP_DIR ]; then
  mkdir -p $TMP_DIR
fi

cp -r $ARCHIVE_PATH $TMP_DIR 

search_extract_recurse "$TMP_DIR"

echo
echo "Done"


#!/bin/bash

source $(dirname $0)/_git-multi-util.sh

function check_dir() {
  local dir_name=$1
  find $dir_name -depth 2  -type d '!' -exec test -e "{}/.git" ';' -print
}

check_dir "$LOCAL_DEV_DIR"

if [ "$GOPATH" != "" ] ; then
  check_dir "$GOPATH/src"
fi

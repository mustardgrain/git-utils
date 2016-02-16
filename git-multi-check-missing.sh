#!/bin/bash

source $(dirname $0)/_git-multi-util.sh

function check_dir() {
  local dir_name=$1
  local depth=$2

  for child_dir in `find $dir_name -mindepth $depth -maxdepth $depth -type d '!' -exec test -e "{}/.git" ';' -print` ; do
    parent_dir="`dirname $child_dir`"

    # If the immediate parent of the directory contains a git
    # repository, then let it pass.
    if [ -d $parent_dir/.git ] ; then
      continue
    fi

    # If the immediate parent of the directory is $GOPATH, then
    # let it pass.
    if [ "$GOPATH" != "" -a "$parent_dir" = "$GOPATH" ] ; then
      continue
    fi

    echo $child_dir
  done
}

check_dir "$LOCAL_DEV_DIR" 2

if [ "$GOPATH" != "" ] ; then
  check_dir "$GOPATH/src" 3
fi

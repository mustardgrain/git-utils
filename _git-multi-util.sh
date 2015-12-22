#!/bin/bash

function __git_init_parent_dirs() {
  if [ ! -d "$LOCAL_DEV_DIR" ] ; then
    echo "Please symlink $LOCAL_DEV_DIR to your local development directory root"
    exit 1
  fi

  orig_pwd=`pwd`

  cd $LOCAL_DEV_DIR
  LOCAL_DEV_DIR=`pwd -P`
  cd $LOCAL_DEV_DIR

  git_parent_dirs=()

  while read -r dotgit_dir ; do
    cd "$dotgit_dir/.."
    git_parent_dirs+=(`pwd`)
  done < <(find $LOCAL_DEV_DIR -name .git -type d | sort)

  cd "$orig_pwd"
}

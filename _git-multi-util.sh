#!/bin/bash

LOCAL_DEV_DIR=$HOME/.mustardgrain/dev

function __git_init_parent_dirs() {
  if [ ! -d "$LOCAL_DEV_DIR" ] ; then
    echo "Please symlink $LOCAL_DEV_DIR to your local development directory root"
    exit 1
  fi

  cd $LOCAL_DEV_DIR
  LOCAL_DEV_DIR=`pwd -P`
  cd $LOCAL_DEV_DIR

  orig_pwd=`pwd`
  git_parent_dirs=()

  while read -r dotgit_dir ; do
    cd "$dotgit_dir/.."
    git_parent_dirs+=(`pwd`)
  done < <(find $LOCAL_DEV_DIR -name .git -type d | sort)

  cd "$orig_pwd"
}

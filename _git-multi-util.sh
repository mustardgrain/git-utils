#!/bin/bash

function __git_init_parent_dirs() {
  orig_pwd=`pwd`
  git_parent_dirs=()

  while read -r dotgit_dir ; do
    cd "$dotgit_dir/.."
    git_parent_dirs+=(`pwd`)
  done < <(find $LOCAL_DEV_DIR -name .git -type d | sort)

  cd "$orig_pwd"
}

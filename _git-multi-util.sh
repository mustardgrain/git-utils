#!/bin/bash

if [ "$GIT_UTILS_PATH" = "" ] ; then
  echo "Please set GIT_UTILS_PATH environment variable to include directories to check"
  exit 1
fi

function __git_init_parent_dirs() {
  local orig_pwd=`pwd`
  git_parent_dirs=()

  for dir in $(echo $GIT_UTILS_PATH | tr ":" "\n") ; do
    cd "$orig_pwd"
    cd "$dir"
    dir=`pwd -P`
    cd "$dir"

    while read -r dotgit_dir ; do
      cd "$dotgit_dir/.."
      git_parent_dirs+=(`pwd`)
    done < <(find $dir -name .git -type d | sort)
  done

  cd "$orig_pwd"
}

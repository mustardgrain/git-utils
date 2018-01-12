#!/bin/bash

source $(dirname $0)/_git-multi-util.sh

__git_init_parent_dirs 0

for project_dir in "${git_parent_dirs[@]}" ; do
  cd "$project_dir"

  if [ -n "$(git status --porcelain)" ]; then
    `which echo` "$project_dir contains uncommitted/unpushed changes"
  fi
done

#!/bin/bash

source $(dirname $0)/_git-multi-util.sh

__git_init_parent_dirs 0

for project_dir in "${git_parent_dirs[@]}" ; do
  cd "$project_dir"
  `which echo` "$project_dir"
done

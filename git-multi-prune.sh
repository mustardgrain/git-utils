#!/bin/bash

source $(dirname $0)/_git-multi-util.sh

__git_init_parent_dirs 1

for project_dir in "${git_parent_dirs[@]}" ; do
  cd "$project_dir"
  remotes="`git remote | sort`"

  for remote in ${remotes[@]} ; do
    git remote prune $remote
  done
done

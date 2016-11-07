#!/bin/bash

source $(dirname $0)/_git-multi-util.sh

__git_init_parent_dirs

for project_dir in "${git_parent_dirs[@]}" ; do
  cd "$project_dir"

  master_branch="`git remote show origin | grep "HEAD branch" | awk '{print $3}'`"
  current_branch="`git status | grep "On branch" | awk '{print $3}'`"
  extra_branches=`git branch -a | grep -v $master_branch | wc -l`

  if [ "$master_branch" != "$current_branch" -o $extra_branches -gt 0 ]; then
    `which echo` "$project_dir:"
    `which echo` "`git branch -a -vv`"
  fi
done

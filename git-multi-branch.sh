#!/bin/bash

source $(dirname $0)/_git-multi-util.sh

__git_init_parent_dirs

# Show all of the branches of "-a" is passed in.
show_all=false

if [ "$1" = "-a" ] ; then
  show_all=true
fi

for project_dir in "${git_parent_dirs[@]}" ; do
  cd "$project_dir"

  master_branch="`git remote show origin | grep "HEAD branch" | awk '{print $3}'`"
  current_branch="`git status | grep "On branch" | awk '{print $3}'`"

  if [ "$show_all" = true -o "$master_branch" != "$current_branch" ]; then
    `which echo` "$project_dir:"
    `which echo` "`git branch`"
  fi
done

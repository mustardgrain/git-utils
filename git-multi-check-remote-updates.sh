#!/bin/bash

source $(dirname $0)/_git-multi-util.sh

__git_init_parent_dirs

function check_branch() {
  branch=$1

  git log HEAD..origin/$branch > /dev/null 2>&1

  if [ $? -ne 0 ] ; then
    return
  fi

  changes=`git log HEAD..origin/$branch --oneline | wc -l`

  if [ $changes -gt 0 ] ; then
    `which echo` "$project_dir has changes on the remote $branch branch"
  fi
}

for project_dir in "${git_parent_dirs[@]}" ; do
  cd "$project_dir"

  master_branch="`git remote show origin | grep "HEAD branch" | awk '{print $3}'`"
  current_branch="`git status | grep "On branch" | awk '{print $3}'`"

  git fetch origin > /dev/null 2>&1
  check_branch "$master_branch"

  if [ "$master_branch" != "$current_branch" ] ; then
    check_branch "$current_branch"
  fi
done

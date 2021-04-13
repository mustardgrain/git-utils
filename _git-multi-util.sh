#!/bin/bash

GIT_UTILS_DEBUG=0

if [ "$GIT_UTILS_PATH" = "" ] ; then
  echo "Please set GIT_UTILS_PATH environment variable to include directories to check"
  exit 1
fi

function __git_init_parent_dirs() {
  local check_connectivity=$1
  local orig_pwd=`pwd`
  local cache_file=`mktemp`
  local unreachable_cache_file=`mktemp`
  git_parent_dirs=()

  for dir in $(echo $GIT_UTILS_PATH | tr ":" "\n") ; do
    cd "$orig_pwd"
    cd "$dir"
    dir=`pwd -P`
    cd "$dir"

    for dotgit_dir in $(find $dir -name .git -type d -depth 3 | sort) ; do
      cd "$dotgit_dir/.."

      if [ $check_connectivity -eq 1 ] ; then
        local protocol="`git ls-remote --get-url origin | cut -d: -f 1`"
        local repo_url=
        local repo_domain=

        if [ "$protocol" = "http" -o "$protocol" = "https" ] ; then
          repo_url=`git ls-remote --get-url origin`
          repo_domain=`echo $repo_url | awk -F/ '{print $3}'`

          if [[ $repo_domain == *"@"* ]]; then
            repo_domain=`echo $repo_domain | awk -F@ '{print $2}'`
          fi
        else
          protocol="ssh"
          repo_url=`git ls-remote --get-url origin | cut -d: -f 1`

          if [[ $repo_url == *"@"* ]]; then
            repo_domain=`echo $repo_url | awk -F@ '{print $2}'`
          else
            repo_domain=$repo_url
          fi
        fi

        if [ $GIT_UTILS_DEBUG -eq 1 ] ; then
          echo "GIT_UTILS_DEBUG - dir: `pwd`, protocol: $protocol, repo_url: $repo_url, repo_domain: $repo_domain"
        fi

        # Let's see if our domain is already in our "unreachable" cache file,
        # and if so, skip.
        if [ `grep "^$repo_domain$" $unreachable_cache_file | wc -l` -eq 1 ] ; then
          if [ $GIT_UTILS_DEBUG -eq 1 ] ; then
            echo "GIT_UTILS_DEBUG - $repo_domain found in unreachable cache file, skipping"
          fi

          continue
        fi

        local is_reachable=1

        # Let's see if our domain has yet to be checked, and if not, perform
        # the protocol-specific test.
        if [ `grep "^$repo_domain$" $cache_file | wc -l` -eq 0 ] ; then
          echo $repo_domain >> $cache_file

          if [ "$protocol" = "http" -o "$protocol" = "https" ] ; then
            if [ $GIT_UTILS_DEBUG -eq 1 ] ; then
              echo "GIT_UTILS_DEBUG - Testing HTTPS access for $repo_url"
            fi

            curl -s --connect-timeout 2 $repo_url > /dev/null

            if [ $? -eq 28 ] ; then
              is_reachable=0
            fi
          else
            if [ $GIT_UTILS_DEBUG -eq 1 ] ; then
              echo "GIT_UTILS_DEBUG - Testing SSH access for $repo_url"
            fi

            ssh -o ConnectTimeout=2 $repo_url > /dev/null 2>&1

            if [ $? -eq 255 ] ; then
              is_reachable=0
            fi
          fi
        fi

        if [ $is_reachable -eq 0 ] ; then
          if [ $GIT_UTILS_DEBUG -eq 1 ] ; then
            echo "GIT_UTILS_DEBUG - Putting $repo_domain in unreachable cache file"
          fi

          echo $repo_domain >> $unreachable_cache_file
          continue
        fi
      fi

      git_parent_dirs+=(`pwd`)
    done
  done

  # I am not expected to understand this...
  IFS=$'\n' sorted=($(sort <<<"${array[*]}"))
  unset IFS

  rm -f $cache_file $unreachable_cache_file

  cd "$orig_pwd"
}

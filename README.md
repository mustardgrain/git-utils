# git-utils

Simple git utilities that operate over many repos.

### Setup

git-utils assumes there is an environment variable named `GIT_UTILS_PATH` that
points to the director(ies) under which all of your git repositories live. This
allows the included scripts to traverse all of your git repositories to perform
different operations.

For example, when running `tree -d -L 1 $GIT_UTILS_PATH` on a single directory,
I see:

```
/Users/kirk/dev
├── apache
├── beacon
├── confluentinc
├── dayoldbakery
├── kirktrue
├── malwarebytes
└── mustardgrain

7 directories
```

The scripts will look for directories containing a `.git` directory and will
consider these as git repositories.

It is possible to set `GIT_UTILS_PATH` to be colon-separated, as in:

```
export GIT_UTILS_PATH=$HOME/dev:$HOME/go
```

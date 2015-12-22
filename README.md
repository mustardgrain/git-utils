# git-utils
Simple git utilities

### Setup

git-utils assumes there is an environment variable named `LOCAL_DEV_DIR` that
points to the directory under which all of your git repositories live. This
allows the included scripts to traverse all of your git repositories to perform
different operations.

For example, when running `tree -d -L 1 $LOCAL_DEV_DIR`, I see:

```
/Users/kirk/dev
├── beacon
├── dayoldbakery
├── ebay
├── go
├── kirktrue
└── mustardgrain

6 directories
```

The scripts will look for directories containing a `.git` directory and will
consider these as git repositories.

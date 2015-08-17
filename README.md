# git-utils
Simple git utilities

### Setup

git-utils assumes there is a directory in your `$HOME` directory named `.mustardgrain`. Inside that directory lives a symlink named `dev` that points to the root directory under which all of your `git` repositories live. This allows the included scripts to traverse all of your Git repositories to perform different operations.

For example, when running `tree $HOME/.mustardgrain`, I see:

```
/Users/kirk/.mustardgrain/
├── dev -> /Users/kirk/allmyreposlivehere
```

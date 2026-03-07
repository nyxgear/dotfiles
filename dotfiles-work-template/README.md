# Work Dotfiles

This dotfiles repo complements [nyxgear/dotfiles](https://github.com/nyxgear/dotfiles) by adding work-specific configs.

# Bootstrapping

To start a new dotfiles work repo, first setup [nyxgear/dotfiles](https://github.com/nyxgear/dotfiles).

```shell
mkdir ~/.dotfiles-work
cp -r ~/.dotfiles/dotfiles-work-template/* ~/.dotfiles-work/

cd ~/.dotfiles-work
git init
git add .
git commit -m "Initial commit"
git remote add origin <repo>
git push -u origin main
```

# Setup

```shell
git clone <repo> ~/.dotfiles-work

cd ~/.dotfiles-work

./setup.sh
```

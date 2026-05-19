# My dotfiles

This repo contains my dotfiles for my system.

## Requirements

Ensure you have the following installed:

- Git
```
sudo pacman -S git
```

- Stow
```
sudo pacman -S stow
```

- Zsh
```
sudo pacman -S zsh
chsh -s $(which zsh)
```

- [tmux](https://github.com/tmux/tmux/wiki)
```
sudo pacman -S tmux
```

- [Fzf](https://github.com/junegunn/fzf)
```
sudo pacman -S fzf
```

- [fzf-git.sh](https://github.com/junegunn/fzf-git.sh)
clone it in your `$HOME` directory
```
git clone https://github.com/junegunn/fzf-git.sh.git
```

- [rg](https://github.com/BurntSushi/ripgrep)
```
sudo pacman -S ripgrep
```

- [fd](https://github.com/sharkdp/fd)
```
sudo pacman -S fd
```

- [bat](https://github.com/sharkdp/bat)
```
sudo pacman -S bat
```

- [lsd](https://github.com/Peltoche/lsd)
```
sudo pacman -S lsd
```

- [zoxide](https://github.com/ajeetdsouza/zoxide)
```
sudo pacman -S zoxide
```

- [thefuck](https://github.com/nvbn/thefuck)
```
sudo pacman -S thefuck
```

- [delta](https://github.com/dandavison/delta)
```
sudo pacman -S delta
```

## Installation

First, clone dotfiles in your `$HOME` directory using git

```
git clone https://github.com/MandavkarPranjal/dotfiles.git
cd dotfiles
```

then use GNU stow to create symlink

```
stow .
```

can also install config files with the application name
```
stow {application_name}
```

# My dotfiles OSX/Linux

## Prerequisite(s)
### Apple

  * Install Apple's CLI tools

```sh
xcode-select --install;
```

### Linux

  * Install git & curl

`apt based:`

```sh 
sudo apt-get update;
sudo apt-get upgrade; 
sudo apt-get install git curl;
```

## Caveats(s)
  * For macOS versions $\leq$ Catalina:
    * make sure the default shell is set to [`zsh`](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
	  * `zsh` is shipped with Catalina by default
    * some packages may not work
    * homebrew support for these versions is most likely unavailable

## TODO(s)
[`setup.sh`](./setup.sh)
  * Create setup function for linux
  * Create symbolic link function to handle linking of multiple files/directories

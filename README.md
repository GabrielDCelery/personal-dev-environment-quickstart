# What is this repository for?

To be able to quickly set up a working development environment on a new machine.

# Pre-requisites

### Zsh

This dev environment is built around `zsh` but since that is the default shell on `mac` decided to remove it from the setup scripts to prevent accidental messup of the terminal. On linux distributions, where for example `bash` is the default shell it is pretty much just a two liner to make zsh the default shell.

```sh
sudo apt install zsh
chsh -s $(which zsh)
```

### Homebrew

Follow the instructions on the Homebrew website to install it -> [Homebrew website](https://brew.sh/)

Also do not fortget to add the following in your `.zshrc` file:

```sh
eval "$(brew shellenv)"
autoload -Uz compinit # If autocompletion is not working read this: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
compinit
```

### WezTerm

I chose WezTerm as the terminal emulator ([WezTerm website](https://wezfurlong.org/wezterm/index.html)) because it works on Linux, Windows (WSL) and mac, comes with NerdFont and Catppuccin themes by default.

##### Installaton on Windows/WSL

1. Install WezTerm
2. Configure WezTerm

Chek the WSL version in the Windows terminal or Powershell.

```sh
wsl -l -v
```

In the `wezterm_configs` folder find and rename the `.wezterm.skel.wsl.lua` file to `.wezterm.lua`. Move the file to your home directory at `/homw/${username}/.wezterm.lua` (we are pretty much mirroring a Linux setup), then open the config and change the following section to use the appropriate WSL version.

```sh
config.default_domain = "WSL:Ubuntu"
```

Go to the `Edit system environment variables` section on your `Windows settings` and add the below variable so WezTerm knows where to look for the configuration file when you open it.

```
VARIABLE_NAME=WEZTERM_CONFIG_FILE
VARIABLE_VALUE=\\wsl.localhost\Ubuntu\home\${user}\.wezterm.lua
```

# How to run it?

1. Install git using homwbrew

```sh
brew install git
```

2. Install ansible using homebrew

```sh
brew install ansible
```

3. Clone the repository somewhere on your local machine

4. Create a vars.yaml file in the root directory of the project.

```
user: <your username> # Run whoami or id on your machine to get the value
github_email: your GitHub email
github_name: your GitHub name
personal_notes_author: name you want to use as a personal author
```

5. Run ansible to deploy the development environment

```sh
ansible-playbook -i ./inventory.yaml ./playbook.yaml
```

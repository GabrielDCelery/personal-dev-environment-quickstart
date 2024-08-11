# What is this repository for?

To be able to quickly set up a working development environment on a new machine.

## Pre-requisites

##### ZSH

This dev environment is built around `zsh` but since that is the default shell on `mac` decided to remove it from the setup scripts to prevent accidental messup of the terminal. On linux distributions where for example `bash` is the default shell it is pretty much a two liner to make zsh the default shell.

```sh
sudo apt install zsh
chsh -s $(which zsh)
```

##### Homebrew

Follow the instructions on the Homebrew website to install it -> [Homebrew website](https://brew.sh/)

## How to run it?

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
```

5. Run ansible to deploy the development environment

```sh
ansible-playbook local.yaml
```

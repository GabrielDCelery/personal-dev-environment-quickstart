# What is this repository for?

To be able to quickly set up a working development environment on a new machine.

# Steps to follow

### 1. Install ZSH

This dev environment is built around `zsh` but since that is the default shell on `mac` decided to remove it from the setup scripts to prevent accidental messup of the terminal. On linux distributions, where for example `bash` is the default shell it is pretty much just a two liner to make zsh the default shell.

```sh
sudo apt install zsh
chsh -s $(which zsh)
```

### 2. Install Homebrew

Follow the instructions on the Homebrew website to install it -> [Homebrew website](https://brew.sh/)

After the installation homebrew will prompt you to run some supplementary scripts. As of this writing:

```sh
echo >> /home/$USER/.zshrc && \
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.zshrc && \
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
sudo apt-get install build-essential -y && \
brew install gcc
```

### 3. Create SSH key and add it to GitHub

```sh
brew install git && \
mkdir -p $HOME/.ssh && \
chmod 700 $HOME/.ssh && \
ssh-keygen -t ed25519 -a 256 -f $HOME/.ssh/id_ed25519 && \
chmod 600 $HOME/.ssh/id_ed25519
```

Take the public key and add it to GitHub. Detailed instructions on [GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

### 4. Run the ansible scripts

```sh
export user=$USER && export github_email="youremail" && export github_name="yourgithubname" && export personal_notes_author="authorname" && \
brew install ansible && \
mkdir -p $HOME/projects/github-GabrielDCelery && \
cd $HOME/projects/github-GabrielDCelery && \
git clone git@github.com:GabrielDCelery/personal-dev-environment-quickstart.git && \
cd personal-dev-environment-quickstart && \
touch vars.yaml && \
echo "user: $user\n" >> vars.yaml && \
echo "github_email: $github_email\n" && \
echo "github_name: $github_name\n" && \
echo "personal_notes_author: $personal_notes_author\n" && \
ansible-playbook -i ./inventory ./playbook.yaml
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

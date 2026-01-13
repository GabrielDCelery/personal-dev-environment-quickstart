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
brew install git xclip && \
mkdir -p $HOME/.ssh && \
chmod 700 $HOME/.ssh && \
ssh-keygen -t ed25519 -a 256 -f $HOME/.ssh/id_ed25519 && \
chmod 600 $HOME/.ssh/id_ed25519 && \
cat $HOME/.ssh/id_ed25519.pub | xclip -selection clipboard
```

Take the public key and add it to GitHub. Detailed instructions on [GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

### 4. Run the ansible scripts

Modify the below script with the desired `github_email`, `github_name` etc... then run it.

```sh
export user=$USER && export github_email="youremail" && export github_name="yourgithubname" && export personal_notes_author="authorname" && \
brew install ansible && \
mkdir -p $HOME/projects/github-GabrielDCelery && \
cd $HOME/projects/github-GabrielDCelery && \
git clone git@github.com:GabrielDCelery/personal-dev-environment-quickstart.git && \
cd personal-dev-environment-quickstart && \
touch vars.yaml && \
echo "user: $user\n" >> vars.yaml && \
echo "github_email: $github_email\n" >> vars.yaml && \
echo "github_name: $github_name\n" >> vars.yaml && \
echo "personal_notes_author: $personal_notes_author\n" >> vars.yaml && \
ansible-playbook -i ./inventory ./playbook.yaml
```

### 5. Install WezTerm

I chose WezTerm as the terminal emulator ([WezTerm website](https://wezfurlong.org/wezterm/index.html)) because it works on Linux, Windows (WSL) and mac, comes with NerdFont and Catppuccin themes by default.

##### Installaton on Windows/WSL

1. Install WezTerm
2. Configure WezTerm

Check the WSL version in the Windows terminal or Powershell.

```sh
wsl -l -v
```

In the `wezterm_configs` folder find and rename the `.wezterm.skel.wsl.lua` file to `.wezterm.lua`. Move the file to your home directory at `/home/${username}/.wezterm.lua` (we are pretty much mirroring a Linux setup), then open the config and change the following section to use the appropriate WSL version.

```sh
config.default_domain = "WSL:Ubuntu"
```

Go to the `Edit system environment variables` section on your `Windows settings` and add the below variable so WezTerm knows where to look for the configuration file when you open it.

```
VARIABLE_NAME=WEZTERM_CONFIG_FILE
VARIABLE_VALUE=\\wsl.localhost\Ubuntu\home\${user}\.wezterm.lua
```

### 6. Importing secrets

This step is there to import the most commonly used secrets from a remote vault to the local password store.

```sh
gpg --full-generate-key # to generate a key that will be used to initialize the password store
gpg --list-keys # get the key id
pass init <the gpg key id> # initialises the password store
```

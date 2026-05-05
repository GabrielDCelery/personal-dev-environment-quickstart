# Personal Dev Environment Quickstart

Ansible-based automation to set up a complete development environment on a new machine. Installs and configures zsh, neovim, tmux, git, programming languages (via mise), Kubernetes tools, and personal dotfiles — all idempotent and reproducible.

This repository works in tandem with [Personal dotfiles](https://github.com/GabrielDCelery/personal-dotfiles)

## Quick Start

```sh
# 1. Install zsh (Linux/WSL only — macOS ships with it)
sudo apt install zsh
chsh -s $(which zsh)
# Then open a new terminal before continuing

# 2. Generate an SSH key and add it to GitHub
mkdir -p $HOME/.ssh && chmod 700 $HOME/.ssh
ssh-keygen -t ed25519 -a 256 -f $HOME/.ssh/id_ed25519
# https://github.com/settings/keys

# 3. Run the bootstrap script
curl -fsSL https://raw.githubusercontent.com/GabrielDCelery/personal-dev-environment-quickstart/main/bootstrap.sh | bash
```

The bootstrap script will:
- Install Homebrew and build tools
- Install Ansible and git
- Copy your SSH public key to the clipboard (paste it into GitHub if not done yet)
- Clone this repo to `~/projects/github-GabrielDCelery/personal-dev-environment-quickstart`
- Prompt for your GitHub email and name, then run the Ansible playbook

Works on Linux, macOS, and WSL.

## WezTerm Setup (Windows/WSL)

1. Install [WezTerm](https://wezfurlong.org/wezterm/index.html) on Windows
2. The bootstrap script copies the config to `~/.config/wezterm/wezterm.lua` on the WSL filesystem
3. Add a Windows environment variable so WezTerm finds the config:
   ```
   WEZTERM_CONFIG_FILE = \\wsl.localhost\Ubuntu\home\<user>\.config\wezterm\wezterm.lua
   ```
4. If your WSL distro name differs from `Ubuntu`, update `config.default_domain` in `~/.config/wezterm/wezterm.lua`

## Importing Secrets

After the playbook finishes, set up the local password store:

```sh
gpg --full-generate-key
gpg --list-keys                # copy the key ID
pass init <gpg-key-id>         # initialise the password store
```

## Re-running

The playbook is idempotent. Re-run it any time to pick up changes:

```sh
ansible-playbook -i ./inventory ./playbook.yaml
```

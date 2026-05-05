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

## Architecture

- **Provisioning**: Ansible (local connection, runs on the target machine itself)
- **Package Manager**: Homebrew (works on both Linux and macOS)
- **Language Version Manager**: [mise](https://mise.jdx.dev/)
- **Dotfiles Manager**: GNU stow (symlinks from `~/.dotfiles`)
- **Shell**: zsh with fzf-tab, autosuggestions, syntax highlighting, completions
- **Editor**: Neovim
- **Terminal Multiplexer**: tmux with TPM and Catppuccin theme
- **Terminal Emulator**: WezTerm (cross-platform, NerdFont + Catppuccin built-in)

## What Gets Installed

The playbook is split into modular task files under `tasks/`:

| Task file                   | What it does                                                       |
| --------------------------- | ------------------------------------------------------------------ |
| `core.yaml`                 | curl, jq, make, nmap, tree, unzip, wget, zip, yamlfmt, yq, vim     |
| `git.yaml`                  | git, lazygit, global git config                                    |
| `stow.yaml`                 | GNU stow, clones and stows personal dotfiles                       |
| `tmux.yaml`                 | TPM, Catppuccin theme (v2.1.3), plugin install                     |
| `programminglanguages.yaml` | mise install (languages defined in mise config)                    |
| `devtools.yaml`             | kubectl, helm, k9s, kubectx, minikube, lazydocker, fzf, pass, more |
| `zsh.yaml`                  | zsh-completions, fzf-tab, autosuggestions, syntax-highlighting     |
| `neovim.yaml`               | neovim, ripgrep, chafa, viu, xclip, backups existing nvim data     |
| `notes.yaml`                | Clones personal notes repo, builds and installs `pnotes` CLI       |
| `ai.yaml`                   | aichat                                                             |

## Configuration

| Variable       | Description           | Required |
| -------------- | --------------------- | -------- |
| `user`         | System username       | Yes      |
| `github_email` | Git global user.email | Yes      |
| `github_name`  | Git global user.name  | Yes      |

Create `vars.yaml` in the project root with these values before running the playbook. This file is gitignored.

## WezTerm Setup (Windows/WSL)

1. Install [WezTerm](https://wezfurlong.org/wezterm/index.html) on Windows
2. Check your WSL distro name:
   ```sh
   wsl -l -v
   ```
3. Copy `wezterm_configs/.wezterm.skel.wsl.lua` to `~/.wezterm.lua` (on the WSL filesystem)
4. Edit `config.default_domain` to match your WSL distro (e.g. `"WSL:Ubuntu"`)
5. Add a Windows environment variable so WezTerm finds the config:
   ```
   WEZTERM_CONFIG_FILE = \\wsl.localhost\Ubuntu\home\<user>\.wezterm.lua
   ```

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

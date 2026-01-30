# Personal Dev Environment Quickstart

Ansible-based automation to set up a complete development environment on a new machine. Installs and configures zsh, neovim, tmux, git, programming languages (via mise), Kubernetes tools, and personal dotfiles — all idempotent and reproducible.

## Quick Start

```sh
# 1. Install zsh (Linux only, macOS already has it)
sudo apt install zsh
chsh -s $(which zsh)

# 2. Install Homebrew (https://brew.sh)
# After install, run the post-install steps Homebrew prints, e.g.:
echo >> /home/$USER/.zshrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
sudo apt-get install build-essential -y
brew install gcc

# 3. Create SSH key and add it to GitHub
brew install git xclip
mkdir -p $HOME/.ssh && chmod 700 $HOME/.ssh
ssh-keygen -t ed25519 -a 256 -f $HOME/.ssh/id_ed25519
chmod 600 $HOME/.ssh/id_ed25519
cat $HOME/.ssh/id_ed25519.pub | xclip -selection clipboard
# Paste the public key in GitHub → Settings → SSH keys
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh

# 4. Clone and run the playbook
brew install ansible
mkdir -p $HOME/projects/github-GabrielDCelery && cd $_
git clone git@github.com:GabrielDCelery/personal-dev-environment-quickstart.git
cd personal-dev-environment-quickstart
cat > vars.yaml <<EOF
user: $USER
github_email: youremail
github_name: yourgithubname
personal_notes_author: authorname
EOF
ansible-playbook -i ./inventory ./playbook.yaml
```

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

| Task file                  | What it does                                                        |
| -------------------------- | ------------------------------------------------------------------- |
| `core.yaml`                | curl, jq, make, nmap, tree, unzip, wget, zip, yamlfmt, yq, vim     |
| `git.yaml`                 | git, lazygit, global git config                                     |
| `stow.yaml`               | GNU stow, clones and stows personal dotfiles                        |
| `tmux.yaml`                | TPM, Catppuccin theme (v2.1.3), plugin install                      |
| `programminglanguages.yaml`| mise install (languages defined in mise config)                     |
| `devtools.yaml`            | kubectl, helm, k9s, kubectx, minikube, lazydocker, fzf, pass, more  |
| `zsh.yaml`                 | zsh-completions, fzf-tab, autosuggestions, syntax-highlighting      |
| `neovim.yaml`              | neovim, ripgrep, chafa, viu, xclip, backups existing nvim data      |
| `notes.yaml`               | Clones personal notes repo, builds and installs `pnotes` CLI        |
| `ai.yaml`                  | aichat                                                              |

## Configuration

| Variable               | Description                        | Required |
| ---------------------- | ---------------------------------- | -------- |
| `user`                 | System username                    | Yes      |
| `github_email`         | Git global user.email              | Yes      |
| `github_name`          | Git global user.name               | Yes      |
| `personal_notes_author`| Author name for personal notes CLI | Yes      |

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

# Personal Dev Environment Quickstart

Ansible-based automation to set up a complete development environment on a new machine. Installs and configures zsh, neovim, tmux, git, programming languages (via mise), Kubernetes tools, and personal dotfiles — all idempotent and reproducible.

This repository works in tandem with [Personal dotfiles](https://github.com/GabrielDCelery/personal-dotfiles)

## Quick Start

1. Install zsh (Linux/WSL only — macOS ships with it)

```sh
sudo apt install zsh
chsh -s $(which zsh)
```

2. Create a GitHub fine-grained PAT (Personal Access Token) with no scopes

   Go to [github.com/settings/tokens](https://github.com/settings/tokens) → Fine-grained tokens → Generate new token. No scopes or permissions needed — the token only needs to exist so tools like `mise` can make authenticated API calls and avoid rate limits. Copy it somewhere safe, you'll be prompted for it during bootstrap.

3. Run the bootstrap script

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielDCelery/personal-dev-environment-quickstart/main/bootstrap.sh | bash
```

The bootstrap script will:

- Install Homebrew and build tools
- Install Ansible, `gh` CLI, and git
- Generate an SSH key if missing, print the public key, and exit — add it to [github.com/settings/keys](https://github.com/settings/keys) then re-run
- Clone this repo
- Copy WezTerm config to `~/.config/wezterm/`
- Prompt for your GitHub email, name, and PAT, then run the Ansible playbook

Works on Linux, macOS, and WSL.

## WezTerm Setup (Windows/WSL)

> **Note:** This is the only step not automated by bootstrap — WezTerm runs on Windows and requires a Windows environment variable to be set manually.

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

Bootstrap is idempotent. Re-run it any time to pick up changes:

```sh
curl -fsSL https://raw.githubusercontent.com/GabrielDCelery/personal-dev-environment-quickstart/main/bootstrap.sh | bash
```

> **Warning:** If `vars.yaml` is missing fields, delete it and re-run — the script will prompt for all values again.

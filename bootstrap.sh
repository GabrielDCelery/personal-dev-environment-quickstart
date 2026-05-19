#!/bin/bash
set -e

REPO_URL="git@github.com:GabrielDCelery/personal-dev-environment-quickstart.git"
REPO_DIR="$HOME/projects/github.com/GabrielDCelery/personal-dev-environment-quickstart"

# ─── Helpers ────────────────────────────────────────────────────────────────

info()    { echo "[bootstrap] $*"; }
success() { echo "[bootstrap] OK: $*"; }
warn()    { echo "[bootstrap] WARN: $*"; }
die()     { echo "[bootstrap] ERROR: $*" >&2; exit 1; }

# ─── OS detection ───────────────────────────────────────────────────────────

detect_os() {
    case "$OSTYPE" in
        linux-gnu*)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        darwin*) echo "macos" ;;
        *)       die "Unsupported OS: $OSTYPE" ;;
    esac
}

OS=$(detect_os)
info "Detected OS: $OS"

# ─── Linux prerequisites ─────────────────────────────────────────────────────

if [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
    info "Installing build-essential..."
    sudo apt-get update -qq
    sudo apt-get install -y build-essential curl git xclip >/dev/null
    success "Build tools installed"
fi

# ─── Homebrew ───────────────────────────────────────────────────────────────

if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
else
    success "Homebrew already installed"
fi

# Ensure brew is on PATH for the rest of this script
if [[ "$OS" == "linux" || "$OS" == "wsl" ]] && [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OS" == "macos" ]] && [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

command -v brew &>/dev/null || die "brew not found after install — check your shell PATH"

# ─── Ansible + gh + git ─────────────────────────────────────────────────────

if ! command -v ansible &>/dev/null; then
    info "Installing ansible..."
    brew install ansible
    success "ansible installed"
else
    success "ansible already installed"
fi

if ! command -v gh &>/dev/null; then
    info "Installing gh..."
    brew install gh
    success "gh installed"
else
    success "gh already installed"
fi

if ! command -v git &>/dev/null; then
    info "Installing git..."
    brew install git
    success "git installed"
else
    success "git already installed"
fi

# ─── SSH key ────────────────────────────────────────────────────────────────

if [[ ! -f "$HOME/.ssh/id_ed25519.pub" ]]; then
    info "No SSH key found — generating one..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -a 256 -f "$HOME/.ssh/id_ed25519" -N ""
    success "SSH key generated"
    warn "Add this public key to https://github.com/settings/keys:"
    echo ""
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
    warn "Re-run this script after adding the key."
    exit 0
else
    success "SSH key found"
fi

# ─── Clone repo ─────────────────────────────────────────────────────────────

if [[ ! -d "$REPO_DIR" ]]; then
    info "Cloning repo to $REPO_DIR..."
    mkdir -p "$(dirname "$REPO_DIR")"
    git clone "$REPO_URL" "$REPO_DIR"
    success "Repo cloned"
else
    success "Repo already exists at $REPO_DIR"
fi

cd "$REPO_DIR"
git checkout main
git pull
success "Repo up to date"

# ─── WezTerm config ─────────────────────────────────────────────────────────

# cp rather than symlink — Windows (WSL) does not follow symlinks into the WSL filesystem
info "Copying WezTerm config..."
mkdir -p "$HOME/.config/wezterm"
cp -r "$REPO_DIR/wezterm_configs/." "$HOME/.config/wezterm/"
success "WezTerm config copied to ~/.config/wezterm/"

# ─── vars.yaml ──────────────────────────────────────────────────────────────

if [[ ! -f vars.yaml ]]; then
    info "Creating vars.yaml..."
    echo ""
    read -rp "  GitHub email: " GITHUB_EMAIL </dev/tty
    read -rp "  GitHub name: "  GITHUB_NAME </dev/tty
    read -rsp "  GitHub token (fine-grained PAT, no scopes needed): " GITHUB_TOKEN </dev/tty
    echo ""

    cat > vars.yaml <<EOF
user: $USER
github_email: $GITHUB_EMAIL
github_name: $GITHUB_NAME
github_token: $GITHUB_TOKEN
EOF
    success "Created vars.yaml"
else
    GITHUB_TOKEN=$(grep '^github_token:' vars.yaml | awk '{print $2}')
    success "vars.yaml already exists, skipping"
fi

# ─── GitHub CLI auth ────────────────────────────────────────────────────────

if ! gh auth status &>/dev/null 2>&1; then
    info "Authenticating GitHub CLI with token..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token
    success "GitHub CLI authenticated"
else
    success "GitHub CLI already authenticated"
fi

# ─── Run playbook ───────────────────────────────────────────────────────────

info "Running Ansible playbook..."
GITHUB_TOKEN="$GITHUB_TOKEN" ansible-playbook -i ./inventory.yaml ./playbook.yaml
success "Done"

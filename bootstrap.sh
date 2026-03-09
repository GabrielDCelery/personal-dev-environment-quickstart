#!/bin/bash
set -e

REPO_URL="https://github.com/GabrielDCelery/personal-dev-environment-quickstart.git"
REPO_DIR="$HOME/projects/github-GabrielDCelery/personal-dev-environment-quickstart"

# ─── Helpers ────────────────────────────────────────────────────────────────

info()    { echo "[bootstrap] $*"; }
success() { echo "[bootstrap] OK: $*"; }
warn()    { echo "[bootstrap] WARN: $*"; }
die()     { echo "[bootstrap] ERROR: $*" >&2; exit 1; }

# ─── OS detection ───────────────────────────────────────────────────────────

detect_os() {
    case "$OSTYPE" in
        linux-gnu*) echo "linux" ;;
        darwin*)    echo "macos" ;;
        *)          die "Unsupported OS: $OSTYPE" ;;
    esac
}

OS=$(detect_os)
info "Detected OS: $OS"

# ─── Linux prerequisites ─────────────────────────────────────────────────────

if [[ "$OS" == "linux" ]]; then
    info "Installing build-essential..."
    sudo apt-get update -qq
    sudo apt-get install -y build-essential curl git xclip >/dev/null
    success "Build tools installed"
fi

# ─── Homebrew ───────────────────────────────────────────────────────────────

if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ "$OS" == "linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
else
    success "Homebrew already installed"
fi

# Ensure brew is on PATH for the rest of this script
if [[ "$OS" == "linux" ]] && [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OS" == "macos" ]] && [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

command -v brew &>/dev/null || die "brew not found after install — check your shell PATH"

# ─── Ansible + git ──────────────────────────────────────────────────────────

if ! command -v ansible &>/dev/null; then
    info "Installing ansible..."
    brew install ansible
    success "ansible installed"
else
    success "ansible already installed"
fi

if ! command -v git &>/dev/null; then
    info "Installing git..."
    brew install git
    success "git installed"
else
    success "git already installed"
fi

# ─── SSH key check ──────────────────────────────────────────────────────────

if [[ ! -f "$HOME/.ssh/id_ed25519.pub" ]]; then
    warn "No SSH key found at ~/.ssh/id_ed25519.pub"
    warn "Generate one with:"
    warn "  ssh-keygen -t ed25519 -a 256 -f ~/.ssh/id_ed25519"
    warn "Then add it to GitHub: https://github.com/settings/keys"
    warn ""
    warn "Re-run this script after adding the key to GitHub."
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

# ─── vars.yaml ──────────────────────────────────────────────────────────────

if [[ ! -f vars.yaml ]]; then
    info "Creating vars.yaml..."
    echo ""
    read -rp "  GitHub email: "          GITHUB_EMAIL
    read -rp "  GitHub name: "           GITHUB_NAME
    read -rp "  Personal notes author: " NOTES_AUTHOR
    echo ""

    cat > vars.yaml <<EOF
user: $USER
github_email: $GITHUB_EMAIL
github_name: $GITHUB_NAME
personal_notes_author: $NOTES_AUTHOR
EOF
    success "Created vars.yaml"
else
    success "vars.yaml already exists, skipping"
fi

# ─── Run playbook ───────────────────────────────────────────────────────────

info "Running Ansible playbook..."
ansible-playbook -i ./inventory.yaml ./playbook.yaml
success "Done"

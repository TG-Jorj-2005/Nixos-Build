#!/usr/bin/env zsh

# NixOS Build - Script de instalare automată
# Autor: TG-Jorj-2005
# Repository: https://github.com/TG-Jorj-2005/Nixos-Build.git

set -euo pipefail

# Culori pentru output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funcții helper
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Verifică dacă rulează pe NixOS
check_nixos() {
  if [[ ! -f /etc/NIXOS ]]; then
    log_error "Acest script trebuie rulat pe NixOS!"
    exit 1
  fi
  log_success "Detectat NixOS"
}

# Verifică dacă git este instalat
check_git() {
  if ! command -v git &>/dev/null; then
    log_warning "Git nu este instalat. Se instalează git..."
    nix-env -iA nixpkgs.git
  fi
  log_success "Git este disponibil"
}

# Clonează repository-ul
clone_repository() {
  local repo_url="https://github.com/TG-Jorj-2005/Nixos-Build.git"
  local target_dir="${HOME}/nixos-config"

  log_info "Se clonează repository-ul..."

  if [[ -d "$target_dir" ]]; then
    log_warning "Directorul $target_dir există deja"
    read -p "Vrei să-l ștergi și să reclonezi? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm -rf "$target_dir"
      log_info "Director șters"
    else
      log_info "Se folosește directorul existent"
      cd "$target_dir"
      git pull origin main || git pull origin master
      return
    fi
  fi

  git clone "$repo_url" "$target_dir"
  cd "$target_dir"
  log_success "Repository clonat în $target_dir"
}

# Backup configurația existentă
backup_config() {
  local backup_dir="/etc/nixos.backup.$(date +%Y%m%d_%H%M%S)"

  if [[ -d /etc/nixos ]]; then
    log_info "Se face backup la configurația existentă..."
    sudo cp -r /etc/nixos "$backup_dir"
    log_success "Backup creat în $backup_dir"
  fi
}

# Generează hardware-configuration.nix pentru sistemul curent
generate_hardware_config() {
  log_info "Se generează configurația hardware..."
  sudo nixos-generate-config --root / --force
  log_success "Hardware configuration generată"
}

# Copiază fișierele de configurație
deploy_config() {
  log_info "Se copiază configurația..."

  # Verifică structura repository-ului și adaptează copierea
  if [[ -f "configuration.nix" ]]; then
    sudo cp configuration.nix /etc/nixos/
    log_success "configuration.nix copiat"
  fi

  if [[ -f "flake.nix" ]]; then
    sudo cp flake.nix /etc/nixos/
    log_success "flake.nix copiat"
  fi

  if [[ -f "flake.lock" ]]; then
    sudo cp flake.lock /etc/nixos/
    log_success "flake.lock copiat"
  fi

  # Copiază alte fișiere de configurație
  for config_file in *.nix; do
    if [[ -f "$config_file" && "$config_file" != "configuration.nix" && "$config_file" != "flake.nix" ]]; then
      sudo cp "$config_file" /etc/nixos/
      log_success "$config_file copiat"
    fi
  done

  # Copiază directoare de configurație dacă există
  if [[ -d "modules" ]]; then
    sudo cp -r modules /etc/nixos/
    log_success "Directorul modules copiat"
  fi

  if [[ -d "overlays" ]]; then
    sudo cp -r overlays /etc/nixos/
    log_success "Directorul overlays copiat"
  fi
}

# Aplică configurația
apply_config() {
  log_info "Se aplică configurația NixOS..."

  # Verifică dacă folosește flakes
  if [[ -f "/etc/nixos/flake.nix" ]]; then
    log_info "Detectat flake.nix - se folosesc NixOS Flakes"

    # Activează experimental features dacă nu sunt activate
    if ! nixos-rebuild --help | grep -q flake; then
      log_warning "Flakes nu sunt activate. Se activează..."
      echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
      sudo systemctl restart nix-daemon
    fi

    # Rebuild cu flakes
    sudo nixos-rebuild switch --flake /etc/nixos#
  else
    log_info "Se folosește configurația clasică NixOS"
    sudo nixos-rebuild switch
  fi

  log_success "Configurația a fost aplicată cu succes!"
}

# Curătare finală
cleanup() {
  log_info "Se face curătarea finală..."
  nix-collect-garbage -d
  log_success "Curătare completă"
}

# Funcția principală
main() {
  echo "======================================"
  echo "  NixOS Build - Script de Instalare  "
  echo "======================================"
  echo

  log_info "Începe procesul de instalare..."

  check_nixos
  check_git

  # Confirmă înainte de a continua
  echo
  log_warning "Acest script va:"
  echo "  1. Clona repository-ul NixOS Build"
  echo "  2. Face backup la configurația existentă"
  echo "  3. Genera configurația hardware"
  echo "  4. Copia și aplica noua configurație"
  echo
  read -p "Continui? [y/N]: " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Instalare anulată"
    exit 0
  fi

  clone_repository
  backup_config
  generate_hardware_config
  deploy_config
  apply_config
  cleanup

  echo
  log_success "Instalarea s-a încheiat cu succes!"
  log_info "Sistemul a fost reconfigurat. Se recomandă un restart."
  echo
  read -p "Vrei să restartezi acum? [y/N]: " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
  fi
}

# Tratează semnalele pentru curățare
trap 'log_error "Script întrerupt"; exit 1' INT TERM

# Rulează scriptul principal
main "$@"

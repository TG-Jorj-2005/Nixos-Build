# NixOS Build - Ghid de Instalare

Acest ghid te ajută să instalezi configurația NixOS Build pe un PC nou.

## Prerequisite

- Sistem cu NixOS deja instalat
- Conexiune la internet
- Privilegii de administrator (sudo)

## Instalare Automată (Recomandat)

### Metoda 1: Rulare directă din internet

```bash
curl -sSL https://raw.githubusercontent.com/TG-Jorj-2005/Nixos-Build/main/install.sh | bash
```

### Metoda 2: Descărcare și rulare locală

```bash
wget https://raw.githubusercontent.com/TG-Jorj-2005/Nixos-Build/main/install.sh
chmod +x install.sh
./install.sh
```

## Instalare Manuală

Dacă preferi să faci instalarea pas cu pas:

### 1. Clonează repository-ul

```bash
git clone https://github.com/TG-Jorj-2005/Nixos-Build.git
cd Nixos-Build
```

### 2. Backup configurația existentă

```bash
sudo cp -r /etc/nixos /etc/nixos.backup.$(date +%Y%m%d_%H%M%S)
```

### 3. Generează configurația hardware

```bash
sudo nixos-generate-config --root / --force
```

### 4. Copiază configurația

```bash
# Pentru configurație simplă
sudo cp configuration.nix /etc/nixos/

# Pentru configurație cu flakes
sudo cp flake.nix flake.lock /etc/nixos/

# Pentru configurație complexă cu module
sudo cp -r *.nix modules/ overlays/ /etc/nixos/ 2>/dev/null || true
```

### 5. Aplică configurația

```bash
# Pentru configurație clasică
sudo nixos-rebuild switch

# Pentru flakes
sudo nixos-rebuild switch --flake /etc/nixos#
```

## Troubleshooting

### Problemă: Flakes nu sunt activate

```bash
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon
```

### Problemă: Conflict de configurație

```bash
# Revino la backup
sudo rm -rf /etc/nixos
sudo cp -r /etc/nixos.backup.* /etc/nixos
sudo nixos-rebuild switch
```

### Problemă: Dependențe lipsă

```bash
# Updatează canalele
sudo nix-channel --update
nix-collect-garbage -d
```

### Problemă: Hardware configuration greșită

```bash
# Regenerează configurația hardware
sudo nixos-generate-config --root / --force
# Editează manual /etc/nixos/hardware-configuration.nix dacă e necesar
```

## Post-instalare

### 1. Verifică statusul sistemului

```bash
systemctl status
nixos-rebuild switch --dry-run
```

### 2. Updateează sistemul

```bash
sudo nix-channel --update
sudo nixos-rebuild switch --upgrade
```

### 3. Curățare

```bash
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

## Structura Repository-ului

Explică ce conține fiecare fișier important:

```
Nixos-Build/
├── flake.nix              # Configurația flake principală
├── flake.lock             # Versiuni lockate ale dependențelor  
├── configuration.nix      # Configurația principală a sistemului
├── hardware-configuration.nix  # Configurația hardware (auto-generată)
├── modules/               # Module personalizate
│   ├── desktop.nix        # Configurația desktop
│   ├── development.nix    # Tools de development
│   └── gaming.nix         # Configurația pentru gaming
├── overlays/              # Overlays pentru pachete
└── install.sh             # Script de instalare automată
```

## Personalizare

### Editarea configurației după instalare

```bash
sudo nano /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

### Adăugarea de pachete noi

```bash
# Editează configuration.nix și adaugă în environment.systemPackages
sudo nixos-rebuild switch
```

### Activarea serviciilor

```bash
# Editează configuration.nix și adaugă în services
sudo nixos-rebuild switch
```

## Backup și Restore

### Crearea unui backup

```bash
# Backup complet
tar -czf nixos-config-backup.tar.gz /etc/nixos

# Sau doar fișierele importante  
cp -r /etc/nixos ~/nixos-backup
```

### Restore din backup

```bash
sudo cp -r ~/nixos-backup/* /etc/nixos/
sudo nixos-rebuild switch
```

## Support

Dacă întâmpini probleme:

1. Verifică logs: `journalctl -xe`
2. Testează configurația: `sudo nixos-rebuild dry-run`
3. Consultă documentația NixOS: https://nixos.org/manual/
4. Creează un issue pe repository: https://github.com/TG-Jorj-2005/Nixos-Build/issues

## Contribuții

Pull requests sunt binevenite! Pentru schimbări majore, te rugăm să deschizi mai întâi un issue pentru a discuta ce ai vrea să schimbi.

---

*Configurația testată pe NixOS 23.11 și 24.05*

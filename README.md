# 🖥️ Configuration Conky Moderne et Adaptative

Deux configurations Conky élégantes et minimalistes pour monitorer votre système Linux, avec des designs distincts pour **Ubuntu** et **Fedora**.

![Ubuntu Version](https://img.shields.io/badge/Ubuntu-E95420?style=flat&logo=ubuntu&logoColor=white)
![Fedora Version](https://img.shields.io/badge/Fedora-51A2DA?style=flat&logo=fedora&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

---

## ✨ Caractéristiques Principales

### 🔄 **Détection Automatique Intelligente**
- ✅ **Nombre de cœurs CPU** - Affiche tous les cœurs disponibles (2, 4, 8, 16+)
- ✅ **Interface réseau active** - WiFi, Ethernet, peu importe le nom
- ✅ **Fonctionne partout** - Aucune modification nécessaire entre machines
- ✅ **Distribution spécifique** - Affiche la version exacte de votre OS

### 📸 **Informations Affichées**
- 🕐 Horloge grande et lisible
- 💻 Informations système (OS, kernel, uptime, hostname)
- ⚙️ Utilisation CPU avec graphiques et température
- 🧠 Mémoire RAM et Swap avec barres de progression
- 💾 Utilisation disque avec graphiques I/O en temps réel
- 🌐 Statistiques réseau complètes (download/upload, graphiques)
- 📊 Top 5 des processus les plus gourmands

---

## 🎨 Deux Versions, Deux Styles

| Caractéristique | 🟠 Ubuntu | 🔵 Fedora |
|----------------|-----------|-----------|
| **Position** | Haut droite | Haut gauche |
| **Palette** | Nordic (bleu/vert pastel) | Fedora officiel (bleu foncé/clair) |
| **Style** | Minimaliste épuré | Encadré avec ASCII art |
| **Bordures** | Sans bordure | Avec bordures |
| **Largeur** | 280px | 300px |
| **Transparence** | 180 (plus transparent) | 200 (plus opaque) |
| **Design** | Clean et simple | Professionnel structuré |
| **Footer** | Aucun | "Powered by Fedora Linux" |

### 🟠 **Version Ubuntu** - Design Minimaliste
```
┌─────────────────┐
│   12:45         │
│                 │
│ SYSTÈME         │
│ CPU 45%         │
│ RAM 2.1/8 GB    │
│ RÉSEAU          │
│  ↓ 1.2 MB/s     │
└─────────────────┘
```
- Palette nordique apaisante
- Pas de bordures, ultra-clean
- Graphiques discrets

### 🔵 **Version Fedora** - Design Structuré
```
╔═══════════════════╗
║ FEDORA MONITORING ║
╚═══════════════════╝

┌─[ SYSTÈME ]──────
│ OS: Fedora 40
│ Uptime: 3h 24m
└──────────────────

┌─[ PROCESSEUR ]───
│ Charge: 45%
├─ CPU 1: 42%
├─ CPU 2: 48%
└──────────────────
```
- Couleurs Fedora officielles
- Bordures et séparateurs ASCII
- Structure hiérarchique claire

---

## 📋 Prérequis

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install conky-all fonts-roboto
```

### Fedora
```bash
sudo dnf install conky google-roboto-fonts
```

### Arch Linux
```bash
sudo pacman -S conky ttf-roboto
```

---

## 🚀 Installation Rapide

### 🟠 **Pour Ubuntu/Debian**

#### Option 1 : Installation automatique (recommandée)
```bash
# Télécharger le projet
git clone https://github.com/votre-nom/conky-config.git
cd conky-config

# Lancer l'installation automatique
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

Cette méthode :
- ✅ Installe Conky et les dépendances automatiquement
- ✅ Sauvegarde votre ancienne config
- ✅ Configure le démarrage automatique
- ✅ Lance Conky immédiatement

#### Option 2 : Installation manuelle
```bash
# Installer les dépendances
sudo apt install conky-all fonts-roboto

# Copier les fichiers
cp conky.conf ~/.conkyrc
mkdir -p ~/.config/conky
cp conky-auto.lua ~/.config/conky/conky-auto.lua

# Lancer Conky
conky &
```

---

### 🔵 **Pour Fedora**

#### Option 1 : Installation automatique (recommandée)
```bash
# Télécharger le projet
git clone https://github.com/votre-nom/conky-config.git
cd conky-config

# Lancer l'installation Fedora
chmod +x install-conky-fedora.sh
./install-conky-fedora.sh
```

Cette méthode :
- ✅ Installe Conky via DNF
- ✅ Configure SELinux si nécessaire
- ✅ Utilise le design spécifique Fedora
- ✅ Configure l'autostart

#### Option 2 : Installation manuelle
```bash
# Installer les dépendances
sudo dnf install conky google-roboto-fonts

# Copier les fichiers FEDORA (pas les Ubuntu!)
cp conky-fedora.conf ~/.conkyrc
mkdir -p ~/.config/conky
cp conky-fedora.lua ~/.config/conky/conky-auto.lua

# Si SELinux bloque Conky
sudo setsebool -P allow_execheap 1

# Lancer Conky
conky &
```

---

## 📁 Structure du Projet

```
conky-config/
│
├── 🟠 VERSION UBUNTU
│   ├── install-ubuntu.sh        # Installation auto Ubuntu/Debian
│   ├── conky.conf               # Config principale Ubuntu
│   └── conky-auto.lua           # Scripts Lua Ubuntu
│
├── 🔵 VERSION FEDORA
│   ├── install-conky-fedora.sh  # Installation auto Fedora
│   ├── conky-fedora.conf        # Config principale Fedora
│   ├── conky-fedora.lua         # Scripts Lua Fedora
│   └── README-FEDORA.md         # Doc spécifique Fedora
│
└── 📚 DOCUMENTATION
    └── README.md                 # Ce fichier
```

---

## ⚙️ Personnalisation

### 🎯 Changer la Position

Éditez `~/.conkyrc` :
```lua
alignment = 'top_right',  -- Options: top_left, top_right, bottom_left, bottom_right
gap_x = 30,               -- Distance horizontale (pixels)
gap_y = 60,               -- Distance verticale (pixels)
```

### 🎨 Modifier les Couleurs

#### Version Ubuntu (Nordic)
```lua
color1 = '88c0d0',  -- Bleu clair (titres)
color2 = 'a3be8c',  -- Vert (labels)
color3 = 'bf616a',  -- Rouge (alertes)
color4 = 'ebcb8b',  -- Jaune (accents)
```

#### Version Fedora (Officiel)
```lua
color1 = '3c6eb4',  -- Bleu Fedora principal
color2 = '51a2da',  -- Bleu clair Fedora
color3 = 'f17a65',  -- Orange accent
color4 = 'a0d995',  -- Vert accent
color5 = '294172',  -- Bleu foncé
```

### 🔍 Ajuster la Transparence

```lua
own_window_argb_value = 180,  -- 0 (transparent) à 255 (opaque)
```

### 📏 Modifier la Taille

```lua
minimum_width = 280,   -- Largeur minimale
maximum_width = 280,   -- Largeur maximale
```

---

## 🔧 Démarrage Automatique

### GNOME (Ubuntu/Fedora)
Le script d'installation configure automatiquement l'autostart via `~/.config/autostart/conky.desktop`

Pour configuration manuelle :
```bash
cat > ~/.config/autostart/conky.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Conky
Exec=sh -c 'sleep 5 && conky'
Terminal=false
X-GNOME-Autostart-enabled=true
EOF
```

### i3wm
Ajoutez dans `~/.config/i3/config` :
```
exec_always --no-startup-id conky
```

### KDE Plasma
```
exec_always --no-startup-id sh -c 'sleep 5 && conky'
```

---

## 🎯 Commandes Utiles

```bash
# Lancer Conky
conky &

# Arrêter Conky
killall conky

# Redémarrer Conky
killall conky && conky &

# Mode debug (voir les erreurs)
conky -d

# Éditer la configuration
nano ~/.conkyrc

# Éditer les scripts Lua
nano ~/.config/conky/conky-auto.lua

# Tester la config sans la charger
conky -c ~/.conkyrc -d
```

---

## 🛠️ Dépannage

### ❌ **Conky ne s'affiche pas**

**Ubuntu :**
```bash
# Vérifier l'installation
which conky

# Installer la version complète
sudo apt install conky-all

# Tester en mode debug
conky -d
```

**Fedora :**
```bash
# Vérifier SELinux
sudo setsebool -P allow_execheap 1

# Changer le type de fenêtre si Wayland
# Dans ~/.conkyrc : own_window_type = 'override'
```

### 🌐 **Interface réseau non détectée**

Les scripts Lua détectent automatiquement toutes les interfaces actives. Si ça ne fonctionne pas :

```bash
# Lister vos interfaces
ip link show

# Vérifier les interfaces actives
ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$'

# Vérifier que le script Lua est chargé
ls -la ~/.config/conky/conky-auto.lua
```

### 🖥️ **Pas tous les CPU affichés**

```bash
# Vérifier le nombre de CPU
nproc

# Vérifier que le script Lua fonctionne
cat /proc/cpuinfo | grep processor | wc -l

# Recharger Conky
killall conky && conky &
```

### 🔤 **Caractères bizarres ou manquants**

```bash
# Ubuntu
sudo apt install fonts-roboto

# Fedora
sudo dnf install google-roboto-fonts

# Vérifier les polices installées
fc-list | grep -i roboto
```

### 📊 **Les graphiques ne s'affichent pas**

Dans `~/.conkyrc`, vérifiez :
```lua
double_buffer = true,           # Doit être activé
draw_graph_borders = true,      # Pour voir les bordures
show_graph_scale = false,       # Désactiver l'échelle
```

### 🛡️ **Problèmes SELinux (Fedora uniquement)**

```bash
# Solution permanente
sudo setsebool -P allow_execheap 1

# Vérifier les alertes SELinux
sudo ausearch -m avc -ts recent | grep conky

# Mode permissif temporaire (déconseillé en production)
sudo setenforce 0
```

### 🪟 **Problèmes sous Wayland**

Conky fonctionne mieux sous X11. Pour Wayland :

```lua
# Dans ~/.conkyrc
own_window_type = 'override',  # Au lieu de 'desktop'
```

Ou lancez votre session en mode X11 au lieu de Wayland.

---

## 🔬 Tests et Compatibilité

### ✅ **Testé sur :**

| Distribution | Version | Statut | Notes |
|--------------|---------|--------|-------|
| Ubuntu | 20.04, 22.04, 24.04 | ✅ OK | Version par défaut |
| Fedora | 38, 39, 40, 44 | ✅ OK | Nécessite config SELinux |
| Debian | 11, 12 | ✅ OK | Utiliser version Ubuntu |
| Arch Linux | Rolling | ✅ OK | Installer depuis AUR |
| Linux Mint | 21, 22 | ✅ OK | Utiliser version Ubuntu |
| Pop!_OS | 22.04 | ✅ OK | Utiliser version Ubuntu |

### 🖥️ **Environnements de bureau testés :**
- GNOME ✅
- KDE Plasma ✅
- XFCE ✅
- i3wm ✅
- Cinnamon ✅

---

## 🎓 Fonctionnalités Avancées

### 📊 **Surveillance réseau multi-interfaces**

Le script Lua détecte automatiquement TOUTES les interfaces actives :
- WiFi (wlan0, wlp3s0, etc.)
- Ethernet (eth0, enp0s3, etc.)
- VPN (tun0, wg0, etc.)

### 🔥 **Température CPU**

Si votre système supporte `acpitemp`, la température s'affiche automatiquement :
```lua
${color2}Température:${color} ${acpitemp}°C
```

Pour d'autres capteurs :
```bash
# Lister les capteurs disponibles
sensors

# Utiliser dans Conky
${hwmon 0 temp 1}°C
```

### 💾 **Surveillance multi-disques**

Pour ajouter d'autres partitions :
```lua
${color2}/home:${color} ${fs_used /home} / ${fs_size /home}
${fs_bar 8 /home}
```






---

## 📝 Changelog

### Version 2.0 (2026)
- ✨ Ajout version Fedora avec design unique
- 🎨 Deux styles distincts (Ubuntu/Fedora)
- 🔧 Scripts d'installation automatique pour les deux OS
- 📚 Documentation complète et structurée
- 🛡️ Support SELinux pour Fedora


### Version 1.0 (2026)
- 🚀 Version initiale debian 13 
- 🔄 Détection automatique CPU/réseau
- 📊 Graphiques en temps réel
- 🎨 Palette Nordic

---





[⬆ Retour en haut](#-configuration-conky-moderne-et-adaptative)

</div>
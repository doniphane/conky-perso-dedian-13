# Configuration Conky Moderne et Adaptative

Une configuration Conky minimaliste et élégante pour monitorer votre système Linux.

## ✨ Caractéristiques Principales

**🔄 Détection Automatique :**
- ✅ Nombre de cœurs CPU (affiche tous les cœurs disponibles)
- ✅ Interface réseau active (WiFi, Ethernet, peu importe le nom)
- ✅ Fonctionne sur n'importe quelle machine sans modification

**📸 Affichage :**
- 🕐 Horloge grande et lisible
- 💻 Informations système (OS, kernel, uptime)
- ⚙️ Utilisation CPU avec graphiques (adapté au nombre de cœurs)
- 🧠 Mémoire RAM et Swap
- 💾 Utilisation disque avec graphique I/O
- 🌐 Statistiques réseau avec détection automatique de l'interface
- 📊 Top 5 des processus actifs

## 🎨 Style

- Design minimaliste et épuré
- Palette de couleurs nordique (bleu clair, vert, rouge, jaune)
- Fond semi-transparent avec transparence ARGB
- Police Roboto moderne
- Interface compacte (280px de largeur)

## 📋 Prérequis

```bash
# Installer Conky
sudo apt install conky-all  # Debian/Ubuntu
sudo dnf install conky      # Fedora
sudo pacman -S conky        # Arch Linux

# Police Roboto (recommandée)
sudo apt install fonts-roboto
```

## 🚀 Installation Rapide

### Option 1 : Installation automatique Ubuntu/Debian (recommandé)
```bash
git clone https://github.com/votre-nom/conky-config.git
cd conky-config
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```
Cette méthode installe tout automatiquement, y compris Conky et les polices.

### Option 2 : Installation interactive (toutes distributions)
```bash
git clone https://github.com/votre-nom/conky-config.git
cd conky-config
chmod +x install.sh
./install.sh
```

Le script d'installation va :
- ✅ Proposer d'installer Conky s'il n'est pas présent
- ✅ Sauvegarder votre ancienne config (si elle existe)
- ✅ Installer les fichiers de configuration
- ✅ Configurer le démarrage automatique

### Option 3 : Installation manuelle
```bash
# Installer Conky d'abord
sudo apt install conky-all fonts-roboto  # Ubuntu/Debian
# ou
sudo dnf install conky                    # Fedora
# ou
sudo pacman -S conky                      # Arch

# Copier les fichiers
cp conky.conf ~/.conkyrc
mkdir -p ~/.config/conky
cp conky-auto.lua ~/.config/conky/conky-auto.lua

# Lancer Conky
conky
```

## ⚙️ Personnalisation

### 🔍 Détection Automatique

La configuration détecte automatiquement :
- **CPU** : Tous les cœurs sont affichés automatiquement (2, 4, 8, 16 cœurs, etc.)
- **Réseau** : L'interface active est détectée (eth0, enp0s3, wlan0, wlp3s0, etc.)

**Aucune modification n'est nécessaire entre différentes machines !**

### Changer la position

Éditez `~/.conkyrc` et modifiez :
```lua
alignment = 'top_right',  -- Options: top_left, top_right, bottom_left, bottom_right
gap_x = 30,               -- Distance du bord horizontal
gap_y = 60,               -- Distance du bord vertical
```

### Adapter l'interface réseau

Par défaut, la configuration utilise `enp0s3`. Pour trouver votre interface :
```bash
ip link show
```

Puis modifiez dans le fichier :
```lua
${if_existing /proc/net/route VOTRE_INTERFACE}\
```

### Modifier les couleurs

Les couleurs sont définies au début du fichier :
```lua
color1 = '88c0d0',  -- Bleu clair (titres)
color2 = 'a3be8c',  -- Vert (labels)
color3 = 'bf616a',  -- Rouge (alertes)
color4 = 'ebcb8b',  -- Jaune (accents)
```

### Ajuster la transparence

```lua
own_window_argb_value = 180,  -- 0 (transparent) à 255 (opaque)
```

## 🔧 Lancement automatique

### GNOME/Unity
Ajoutez à vos applications au démarrage :
```
Nom: Conky
Commande: conky --daemonize --pause=5
```

### i3wm
Ajoutez dans `~/.config/i3/config` :
```
exec_always --no-startup-id conky
```

### KDE Plasma
Créez `~/.config/autostart/conky.desktop` :
```ini
[Desktop Entry]
Type=Application
Name=Conky
Exec=conky --daemonize --pause=5
X-GNOME-Autostart-enabled=true
```

## 🛠️ Dépannage

**Conky ne s'affiche pas :**
- Vérifiez que `conky-all` est installé (pas juste `conky`)
- Essayez de changer `own_window_type` de `desktop` à `normal` ou `override`

**Interface réseau affiche "Aucune connexion réseau" :**
- Vérifiez que vous êtes connecté : `ip addr`
- Le script détecte automatiquement l'interface active
- Si le problème persiste, vérifiez `/proc/net/route`

**Pas tous les cœurs CPU affichés :**
- Vérifiez que le script Lua est bien chargé : `ls ~/.config/conky/conky-auto.lua`
- Testez avec : `cat /proc/cpuinfo | grep processor | wc -l`

**Caractères manquants ou bizarres :**
- Installez la police Roboto : `sudo apt install fonts-roboto`

**Le script Lua ne fonctionne pas :**
```bash
# Vérifier que le fichier existe et est lisible
ls -la ~/.config/conky/conky-auto.lua
# Tester manuellement
lua ~/.config/conky/conky-auto.lua
```

## 📝 Licence

MIT License - Libre d'utilisation et de modification

## 🤝 Contribution

Les pull requests sont les bienvenues ! N'hésitez pas à :
- Proposer de nouvelles fonctionnalités
- Signaler des bugs
- Améliorer la documentation
- Partager vos personnalisations

## 📚 Ressources

- [Documentation officielle Conky](https://github.com/brndnmtthws/conky/wiki)
- [Variables Conky](https://conky.sourceforge.net/variables.html)
- [Exemples de configurations](https://github.com/brndnmtthws/conky/wiki/Configs)
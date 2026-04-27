# Configuration Conky Moderne

Une configuration Conky minimaliste et élégante pour monitorer votre système Linux.

## 📸 Aperçu

Cette configuration affiche :
- 🕐 Horloge grande et lisible
- 💻 Informations système (OS, kernel, uptime)
- ⚙️ Utilisation CPU avec graphiques et détails par cœur
- 🧠 Mémoire RAM et Swap
- 💾 Utilisation disque avec graphique I/O
- 🌐 Statistiques réseau (vitesse upload/download)
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

## 🚀 Installation

1. Cloner ce dépôt :
```bash
git clone https://github.com/votre-nom/conky-config.git
cd conky-config
```

2. Copier la configuration :
```bash
cp conky.conf ~/.conkyrc
```

3. Lancer Conky :
```bash
conky
```

## ⚙️ Personnalisation

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

**Interface réseau affiche "Déconnecté" :**
- Vérifiez le nom de votre interface avec `ip link`
- Remplacez `enp0s3` par le nom correct dans la configuration

**Caractères manquants ou bizarres :**
- Installez la police Roboto : `sudo apt install fonts-roboto`

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
#!/bin/bash
# Installation rapide pour Fedora
# Ce script installe tout automatiquement sans interaction
set -e

echo "🚀 Installation automatique de Conky (Fedora)"
echo "=============================================="
echo ""

# Installer Conky si nécessaire
if ! command -v conky &> /dev/null; then
    echo "📦 Installation de Conky et des dépendances..."
    sudo dnf install -y conky google-roboto-fonts
    echo "✅ Conky installé"
else
    echo "✅ Conky déjà installé"
fi

# Créer les dossiers nécessaires
mkdir -p ~/.config/conky
mkdir -p ~/.config/autostart

# Sauvegarder l'ancienne config
if [ -f ~/.conkyrc ]; then
    backup="$HOME/.conkyrc.backup.$(date +%Y%m%d_%H%M%S)"
    cp ~/.conkyrc "$backup"
    echo "💾 Ancienne config sauvegardée: $backup"
fi

# Copier les fichiers
echo "📁 Copie des fichiers de configuration..."
cp conky-fedora.conf ~/.conkyrc
cp conky-fedora.lua ~/.config/conky/conky-auto.lua
chmod 644 ~/.conkyrc
chmod 644 ~/.config/conky/conky-auto.lua

# Autostart
cat > ~/.config/autostart/conky.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Conky
Comment=Moniteur système adaptatif
Exec=sh -c 'sleep 5 && conky'
Terminal=false
X-GNOME-Autostart-enabled=true
Hidden=false
NoDisplay=false
EOF

echo ""
echo "✅ Installation terminée !"
echo ""
echo "🚀 Lancement de Conky..."
killall conky 2>/dev/null || true
sleep 1
conky &

echo ""
echo "✨ Conky est maintenant actif !"
echo ""
echo "Commandes utiles:"
echo "  - Arrêter:     killall conky"
echo "  - Redémarrer:  killall conky && conky &"
echo "  - Éditer:      nano ~/.conkyrc"
echo ""
echo "Note Fedora: Si SELinux bloque Conky, exécutez:"
echo "  sudo setsebool -P allow_execheap 1"
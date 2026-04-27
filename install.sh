#!/bin/bash

# Script d'installation de la configuration Conky adaptative
# Ce script copie les fichiers aux bons endroits

echo "🚀 Installation de Conky - Configuration adaptative"
echo "=================================================="
echo ""

# Vérifier si Conky est installé
if ! command -v conky &> /dev/null; then
    echo "❌ Conky n'est pas installé."
    echo "   Installez-le avec:"
    echo "   - Debian/Ubuntu: sudo apt install conky-all"
    echo "   - Fedora: sudo dnf install conky"
    echo "   - Arch: sudo pacman -S conky"
    exit 1
fi

echo "✅ Conky détecté"

# Créer le dossier de configuration si nécessaire
mkdir -p ~/.config/conky

# Sauvegarder l'ancienne config si elle existe
if [ -f ~/.conkyrc ]; then
    echo "💾 Sauvegarde de l'ancienne configuration..."
    mv ~/.conkyrc ~/.conkyrc.backup.$(date +%Y%m%d_%H%M%S)
    echo "   → ~/.conkyrc.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Copier les fichiers
echo "📁 Installation des fichiers..."
cp conky.conf ~/.conkyrc
cp conky-auto.lua ~/.config/conky/conky-auto.lua
chmod +x ~/.config/conky/conky-auto.lua

# Créer le fichier autostart
echo "⚙️  Configuration du démarrage automatique..."
mkdir -p ~/.config/autostart
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
echo "✨ Installation terminée !"
echo ""
echo "📊 Détection automatique configurée pour:"
echo "   - Nombre de cœurs CPU (tous seront affichés)"
echo "   - Interface réseau active (WiFi ou Ethernet)"
echo ""
echo "🎯 Prochaines étapes:"
echo "   1. Lancez Conky:  conky"
echo "   2. Pour arrêter:  killall conky"
echo "   3. Pour éditer:   nano ~/.conkyrc"
echo ""
echo "🔄 Conky démarrera automatiquement au prochain redémarrage"
#!/bin/bash

# Script d'installation de la configuration Conky adaptative
# Ce script copie les fichiers aux bons endroits

set -e  # Arrêter en cas d'erreur

echo "🚀 Installation de Conky - Configuration adaptative"
echo "=================================================="
echo ""

# Vérifier si Conky est installé
if ! command -v conky &> /dev/null; then
    echo "⚠️  Conky n'est pas installé."
    echo ""
    read -p "Voulez-vous l'installer maintenant ? (o/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[OoYy]$ ]]; then
        if command -v apt &> /dev/null; then
            echo "📦 Installation de conky-all via apt..."
            sudo apt update && sudo apt install -y conky-all fonts-roboto
        elif command -v dnf &> /dev/null; then
            echo "📦 Installation de conky via dnf..."
            sudo dnf install -y conky
        elif command -v pacman &> /dev/null; then
            echo "📦 Installation de conky via pacman..."
            sudo pacman -S --noconfirm conky
        else
            echo "❌ Gestionnaire de paquets non reconnu."
            echo "   Installez manuellement avec votre gestionnaire de paquets."
            exit 1
        fi
    else
        echo "Installation annulée."
        exit 1
    fi
fi

echo "✅ Conky détecté: $(conky --version | head -n1)"

# Vérifier que les fichiers sources existent
if [ ! -f "conky.conf" ] || [ ! -f "conky-auto.lua" ]; then
    echo "❌ Fichiers manquants ! Assurez-vous d'être dans le bon dossier."
    echo "   Fichiers requis: conky.conf, conky-auto.lua"
    exit 1
fi

# Créer le dossier de configuration si nécessaire
mkdir -p ~/.config/conky

# Sauvegarder l'ancienne config si elle existe
if [ -f ~/.conkyrc ]; then
    backup_name="$HOME/.conkyrc.backup.$(date +%Y%m%d_%H%M%S)"
    echo "💾 Sauvegarde de l'ancienne configuration..."
    cp ~/.conkyrc "$backup_name"
    echo "   → $backup_name"
fi

# Copier les fichiers
echo "📁 Installation des fichiers..."
cp conky.conf ~/.conkyrc
cp conky-auto.lua ~/.config/conky/conky-auto.lua
chmod 644 ~/.conkyrc
chmod 644 ~/.config/conky/conky-auto.lua

echo "   ✅ ~/.conkyrc"
echo "   ✅ ~/.config/conky/conky-auto.lua"

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

echo "   ✅ ~/.config/autostart/conky.desktop"
echo ""
echo "✨ Installation terminée avec succès !"
echo ""
echo "📊 Détection automatique configurée pour:"
echo "   - Nombre de cœurs CPU (tous seront affichés)"
echo "   - Interface réseau active (WiFi ou Ethernet)"
echo ""
echo "🎯 Prochaines étapes:"
echo "   1. Lancez Conky:        conky"
echo "   2. Pour arrêter:        killall conky"
echo "   3. Pour redémarrer:     killall conky && conky &"
echo "   4. Pour éditer:         nano ~/.conkyrc"
echo ""
echo "🔄 Conky démarrera automatiquement au prochain redémarrage"
echo ""
echo "💡 Conseil: Lancez './test-detection.sh' pour vérifier la détection matérielle"
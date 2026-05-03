#!/bin/bash
# Installation rapide pour Fedora - VERSION CORRIGÉE
# Ce script installe tout automatiquement avec diagnostic
set -e

echo "🚀 Installation automatique de Conky (Fedora - Version Corrigée)"
echo "=================================================================="
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

# Utiliser le fichier CORRIGÉ si disponible, sinon l'original
if [ -f "conky-fedora-FIXED.lua" ]; then
    echo "   ✅ Utilisation de la version CORRIGÉE du script Lua"
    cp conky-fedora-FIXED.lua ~/.config/conky/conky-auto.lua
elif [ -f "conky-fedora.lua" ]; then
    echo "   ⚠️  Utilisation de la version originale du script Lua"
    cp conky-fedora.lua ~/.config/conky/conky-auto.lua
else
    echo "   ❌ Erreur: Aucun fichier .lua trouvé!"
    exit 1
fi

if [ -f "conky-fedora.conf" ]; then
    cp conky-fedora.conf ~/.conkyrc
else
    echo "   ❌ Erreur: conky-fedora.conf non trouvé!"
    exit 1
fi

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
echo "🔍 DIAGNOSTIC RÉSEAU:"
echo "──────────────────────────────────────────────────"

# Test de détection des interfaces
interfaces=$(ip -o link show | awk -F': ' '{print $2}' | grep -vE '^(lo|docker|veth|br-)' | sed 's/@.*//')
if [ -z "$interfaces" ]; then
    echo "⚠️  ATTENTION: Aucune interface réseau détectée!"
    echo "   Vérifiez votre connexion réseau."
else
    echo "✅ Interfaces détectées:"
    for iface in $interfaces; do
        state=$(cat /sys/class/net/$iface/operstate 2>/dev/null || echo "unknown")
        ip_addr=$(ip -4 addr show $iface 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
        if [ "$state" = "up" ]; then
            echo "   ✅ $iface → $state $([ -n "$ip_addr" ] && echo "($ip_addr)" || echo "(pas d'IP)")"
        else
            echo "   ⚠️  $iface → $state"
        fi
    done
fi

echo ""
echo "✅ Installation terminée !"
echo ""

# Arrêter Conky existant
killall conky 2>/dev/null || true
sleep 1

echo "🚀 Lancement de Conky..."
conky &
sleep 2

# Vérifier que Conky tourne
if pgrep -x conky > /dev/null; then
    echo "✅ Conky est actif et fonctionnel !"
else
    echo "❌ Erreur: Conky ne s'est pas lancé correctement"
    echo "   Lancez manuellement avec: conky -d"
    echo "   pour voir les erreurs"
fi

echo ""
echo "✨ Configuration terminée !"
echo ""
echo "📋 Commandes utiles:"
echo "  - Arrêter:     killall conky"
echo "  - Redémarrer:  killall conky && conky &"
echo "  - Debug:       conky -d"
echo "  - Éditer conf: nano ~/.conkyrc"
echo "  - Éditer Lua:  nano ~/.config/conky/conky-auto.lua"
echo ""
echo "🔧 En cas de problème:"
echo "  1. Vérifiez les interfaces: ip addr"
echo "  2. Lancez le diagnostic: ./diagnostic-conky-network.sh"
echo "  3. Regardez les logs: conky -d 2>&1 | grep -i error"
echo ""
echo "⚙️  Note Fedora/SELinux:"
echo "  Si SELinux bloque Conky, exécutez:"
echo "  sudo setsebool -P allow_execheap 1"
#!/bin/bash
# Script de diagnostic pour Conky Fedora - Détection réseau
echo "═══════════════════════════════════════════════════"
echo "  DIAGNOSTIC CONKY - DÉTECTION RÉSEAU FEDORA"
echo "═══════════════════════════════════════════════════"
echo ""

echo "1️⃣  LISTE DE TOUTES LES INTERFACES:"
echo "─────────────────────────────────────────────────"
ip -o link show | awk -F': ' '{print $2}'
echo ""

echo "2️⃣  INTERFACES SANS 'lo' (commande originale):"
echo "─────────────────────────────────────────────────"
ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$'
echo ""

echo "3️⃣  INTERFACES NETTOYÉES (commande corrigée):"
echo "─────────────────────────────────────────────────"
ip -o link show | awk -F': ' '{print $2}' | grep -vE '^(lo|docker|veth|br-)' | sed 's/@.*//'
echo ""

echo "4️⃣  ÉTAT DES INTERFACES:"
echo "─────────────────────────────────────────────────"
for iface in $(ip -o link show | awk -F': ' '{print $2}' | grep -vE '^(lo|docker|veth|br-)' | sed 's/@.*//'); do
    state=$(cat /sys/class/net/$iface/operstate 2>/dev/null || echo "N/A")
    echo "   $iface → État: $state"
done
echo ""

echo "5️⃣  ADRESSES IP DES INTERFACES ACTIVES:"
echo "─────────────────────────────────────────────────"
for iface in $(ip -o link show | awk -F': ' '{print $2}' | grep -vE '^(lo|docker|veth|br-)' | sed 's/@.*//'); do
    state=$(cat /sys/class/net/$iface/operstate 2>/dev/null)
    if [ "$state" = "up" ]; then
        ip=$(ip -4 addr show $iface 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
        if [ -n "$ip" ]; then
            echo "   ✅ $iface → $ip (UP)"
        else
            echo "   ⚠️  $iface → Pas d'IP (UP mais non configuré)"
        fi
    fi
done
echo ""

echo "6️⃣  TEST DE LA FONCTION LUA:"
echo "─────────────────────────────────────────────────"
echo "Copie de votre fonction Lua dans un script test..."

cat > /tmp/test_conky_network.lua << 'LUAEOF'
function show_network_fedora()
    local handle = io.popen("ip -o link show | awk -F': ' '{print $2}' | grep -vE '^(lo|docker|veth|br-)'")
    local interfaces = {}
    
    if handle then
        for interface in handle:lines() do
            local clean_iface = interface:match("^([^@]+)")
            if clean_iface and clean_iface ~= "" then
                table.insert(interfaces, clean_iface)
            end
        end
        handle:close()
    end
    
    print("Interfaces détectées: " .. #interfaces)
    for i, iface in ipairs(interfaces) do
        local status_handle = io.popen("cat /sys/class/net/" .. iface .. "/operstate 2>/dev/null")
        local status = ""
        if status_handle then
            status = status_handle:read("*l") or ""
            status_handle:close()
        end
        print("  - " .. iface .. " → " .. status)
    end
end

show_network_fedora()
LUAEOF

lua /tmp/test_conky_network.lua 2>&1
echo ""

echo "7️⃣  VÉRIFICATION DES FICHIERS CONKY:"
echo "─────────────────────────────────────────────────"
if [ -f ~/.conkyrc ]; then
    echo "   ✅ ~/.conkyrc existe"
else
    echo "   ❌ ~/.conkyrc n'existe pas"
fi

if [ -f ~/.config/conky/conky-auto.lua ]; then
    echo "   ✅ ~/.config/conky/conky-auto.lua existe"
    echo ""
    echo "   Vérification de la fonction dans le fichier:"
    if grep -q "function conky_show_network_fedora" ~/.config/conky/conky-auto.lua; then
        echo "   ✅ Fonction conky_show_network_fedora trouvée"
    else
        echo "   ❌ Fonction conky_show_network_fedora NON trouvée"
    fi
else
    echo "   ❌ ~/.config/conky/conky-auto.lua n'existe pas"
fi
echo ""

echo "8️⃣  PROCESSUS CONKY:"
echo "─────────────────────────────────────────────────"
if pgrep -x conky > /dev/null; then
    echo "   ✅ Conky est en cours d'exécution (PID: $(pgrep -x conky))"
else
    echo "   ❌ Conky n'est pas en cours d'exécution"
fi
echo ""

echo "═══════════════════════════════════════════════════"
echo "  FIN DU DIAGNOSTIC"
echo "═══════════════════════════════════════════════════"
echo ""
echo "💡 SOLUTIONS RECOMMANDÉES:"
echo ""
echo "Si aucune interface n'est détectée:"
echo "   1. Vérifiez que vos interfaces sont bien 'up'"
echo "   2. Copiez le fichier corrigé:"
echo "      cp conky-fedora-FIXED.lua ~/.config/conky/conky-auto.lua"
echo "   3. Redémarrez Conky:"
echo "      killall conky && sleep 1 && conky &"
echo ""
echo "Si les interfaces sont détectées mais pas affichées:"
echo "   - Vérifiez les logs Conky: conky -d 2>&1 | tail -20"
echo "   - Testez en mode debug: conky -c ~/.conkyrc -d"
echo ""
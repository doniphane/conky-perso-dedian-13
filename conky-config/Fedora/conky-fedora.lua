-- Script Lua pour Conky - Version Fedora (CORRIGÉ)
-- Détection automatique des interfaces réseau et CPU

function conky_show_network_fedora()
    -- Commande améliorée pour lister les interfaces (sans lo, docker, veth, br-)
    local handle = io.popen("ip -o link show | awk -F': ' '{print $2}' | grep -vE '^(lo|docker|veth|br-)'")
    local interfaces = {}
    
    if handle then
        for interface in handle:lines() do
            -- Nettoyer le nom de l'interface (enlever @... si présent)
            local clean_iface = interface:match("^([^@]+)")
            if clean_iface and clean_iface ~= "" then
                table.insert(interfaces, clean_iface)
            end
        end
        handle:close()
    end
    
    if #interfaces == 0 then
        return "${color2}│${color} Aucune interface détectée"
    end
    
    local result = ""
    local active_count = 0
    
    for i, iface in ipairs(interfaces) do
        -- Vérifier si l'interface est active
        local status_handle = io.popen("cat /sys/class/net/" .. iface .. "/operstate 2>/dev/null")
        local status = ""
        if status_handle then
            status = status_handle:read("*l") or ""
            status_handle:close()
        end
        
        if status == "up" then
            active_count = active_count + 1
            
            -- Nom de l'interface avec indicateur
            result = result .. "${color2}│ " .. iface .. ":${color} ${addr " .. iface .. "}\n"
            
            -- Stats download
            result = result .. "${color2}│${color}  ↓ Download: ${downspeed " .. iface .. "} ${alignr}${totaldown " .. iface .. "}\n"
            result = result .. "${color1}│${color}  ${downspeedgraph " .. iface .. " 25,298 294172 51a2da -t}\n"
            
            -- Stats upload
            result = result .. "${color2}│${color}  ↑ Upload: ${upspeed " .. iface .. "} ${alignr}${totalup " .. iface .. "}\n"
            result = result .. "${color1}│${color}  ${upspeedgraph " .. iface .. " 25,298 294172 f17a65 -t}\n"
            
            -- Séparateur entre interfaces
            if active_count < #interfaces then
                result = result .. "${color2}│${color}\n"
            end
        end
    end
    
    if result == "" then
        return "${color2}│${color} Aucune interface active"
    end
    
    return result
end

function conky_show_cpus()
    -- Détection automatique du nombre de CPUs
    local handle = io.popen("nproc")
    local cpu_count = tonumber(handle:read("*l"))
    handle:close()
    
    if cpu_count == nil or cpu_count == 0 then
        cpu_count = 4  -- Valeur par défaut
    end
    
    local result = ""
    for i = 1, math.min(cpu_count, 16) do
        result = result .. "${color2}CPU" .. i .. ":${color} ${cpu cpu" .. i .. "}% ${cpubar cpu" .. i .. " 8}\n"
    end
    
    return result
end

-- Fonction pour obtenir la distribution
function conky_get_distro()
    local handle = io.popen("cat /etc/fedora-release 2>/dev/null || echo 'Fedora Linux'")
    local distro = handle:read("*l")
    handle:close()
    return distro or "Fedora Linux"
end

-- Fonction pour obtenir le nombre de mises à jour disponibles (DNF)
function conky_get_updates()
    local handle = io.popen("dnf check-update 2>/dev/null | grep -v '^$' | grep -v 'Last metadata' | wc -l")
    local updates = tonumber(handle:read("*l"))
    handle:close()
    
    if updates and updates > 0 then
        return "Updates: " .. (updates - 1)  -- -1 pour exclure la ligne d'en-tête
    else
        return "System up to date"
    end
end
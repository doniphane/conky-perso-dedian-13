-- Script Lua pour Conky - Version Fedora ULTRA-SIMPLIFIÉE
-- Compatible avec tous les environnements Lua de Conky

function conky_show_network_fedora()
    -- Commande simple et robuste
    local handle = io.popen("ip -o link show 2>/dev/null | awk -F': ' '{print $2}' | grep -vE '^(lo|docker|veth|br-)' | cut -d'@' -f1")
    
    if not handle then
        return "${color2}│${color} Erreur de détection"
    end
    
    local interfaces = {}
    local line = handle:read("*l")
    
    while line do
        if line ~= "" then
            interfaces[#interfaces + 1] = line
        end
        line = handle:read("*l")
    end
    handle:close()
    
    if #interfaces == 0 then
        return "${color2}│${color} Aucune interface détectée"
    end
    
    local result = ""
    local active_count = 0
    
    for i = 1, #interfaces do
        local iface = interfaces[i]
        
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
            if i < #interfaces then
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
    local handle = io.popen("nproc 2>/dev/null")
    
    if not handle then
        return "${color2}│${color} Erreur CPU"
    end
    
    local cpu_count = tonumber(handle:read("*l")) or 4
    handle:close()
    
    local result = ""
    for i = 1, cpu_count do
        if i <= 16 then
            result = result .. "${color2}CPU" .. i .. ":${color} ${cpu cpu" .. i .. "}% ${cpubar cpu" .. i .. " 8}\n"
        end
    end
    
    return result
end

-- Fonction pour obtenir la distribution
function conky_get_distro()
    local handle = io.popen("cat /etc/fedora-release 2>/dev/null")
    
    if not handle then
        return "Fedora Linux"
    end
    
    local distro = handle:read("*l") or "Fedora Linux"
    handle:close()
    
    return distro
end

-- Fonction pour obtenir le nombre de mises à jour disponibles (DNF)
function conky_get_updates()
    local handle = io.popen("dnf check-update 2>/dev/null | grep -v '^$' | grep -v 'Last metadata' | wc -l 2>/dev/null")
    
    if not handle then
        return "N/A"
    end
    
    local updates = tonumber(handle:read("*l"))
    handle:close()
    
    if updates and updates > 1 then
        return "Updates: " .. (updates - 1)
    else
        return "System up to date"
    end
end
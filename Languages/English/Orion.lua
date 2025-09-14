-- UNIVERSAL SCRIPTS V2 - ORION (ENG)

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "Universal Scripts V2 (Orion)",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "UniversalScripts"
})

-- Tabs
local HomeTab = Window:MakeTab({Name = "Home", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local PremiumTab = Window:MakeTab({Name = "Premium", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local ExecutorTab = Window:MakeTab({Name = "Executor", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local LogsTab = Window:MakeTab({Name = "Update Logs", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Home
HomeTab:AddButton({
    Name = "Anti-Fling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/majka323pl/universal-scripts/main/anty-fling"))()
    end
})

HomeTab:AddButton({
    Name = "Click TP",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/4KF2WJ9u"))()
    end
})

HomeTab:AddButton({
    Name = "Fly",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/xuSMWfDu"))()
    end
})

HomeTab:AddButton({
    Name = "Infinity Jump",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/majka323pl/universal-scripts/main/infinity-jump"))()
    end
})

HomeTab:AddButton({
    Name = "NoClip",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/CnbYfaj1"))()
    end
})

HomeTab:AddButton({
    Name = "Speed",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/X7B0HPc2"))()
    end
})

HomeTab:AddButton({
    Name = "Game Scripts",
    Callback = function()
        local url = "https://raw.githubusercontent.com/majka323pl/universal-scripts/main/game_scripts/"..game.PlaceId
        loadstring(game:HttpGet(url))()
    end
})

-- Premium
PremiumTab:AddButton({
    Name = "Console",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

PremiumTab:AddButton({
    Name = "Fling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt"))()
    end
})

PremiumTab:AddButton({
    Name = "Invisibility",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/3Rnd9rHf"))()
    end
})

PremiumTab:AddButton({
    Name = "Spectate",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/majka323pl/universal-scripts/main/spectate"))()
    end
})

-- Executor
ExecutorTab:AddTextbox({
    Name = "Executor",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        local success, err = pcall(function()
            loadstring(Value)()
        end)
        if success then
            OrionLib:MakeNotification({Name = "Executor", Content = "Script executed ✅"})
        else
            OrionLib:MakeNotification({Name = "Executor", Content = "Error: " .. tostring(err)})
        end
    end
})

-- Logs
LogsTab:AddParagraph("Update Logs", [[
[23.07.2025] Version 2.5 (Beta)
- Added Executor
- Removed Keysystem

[28.07.2025] Version 2.6 (Stable)
- Bug fixes
- New UI
]])

OrionLib:Init()

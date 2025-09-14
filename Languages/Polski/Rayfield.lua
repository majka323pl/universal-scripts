-- UNIVERSAL SCRIPTS V2 - RAYFIELD (PL Gaming Style)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Universal Scripts V2 (Rayfield)",
    LoadingTitle = "Universal Scripts V2",
    LoadingSubtitle = "by majka323pl",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UniversalScripts",
        FileName = "ConfigRayfield"
    },
    Discord = { Enabled = false }
})

-- Tabs
local HomeTab = Window:CreateTab("Strona Główna", 4483362458)
local PremiumTab = Window:CreateTab("Premium", 4483362458)
local ExecutorTab = Window:CreateTab("Executor", 4483362458)
local LogsTab = Window:CreateTab("Changelog", 4483362458)

-- Home buttons
HomeTab:CreateButton({
    Name = "Anty-Fling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/majka323pl/universal-scripts/main/anty-fling"))()
    end
})

HomeTab:CreateButton({
    Name = "Click TP",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/4KF2WJ9u"))()
    end
})

HomeTab:CreateButton({
    Name = "Fly",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/xuSMWfDu"))()
    end
})

HomeTab:CreateButton({
    Name = "Inf Jump",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/majka323pl/universal-scripts/main/infinity-jump"))()
    end
})

HomeTab:CreateButton({
    Name = "Wallhack",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/CnbYfaj1"))()
    end
})

HomeTab:CreateButton({
    Name = "Speed",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/X7B0HPc2"))()
    end
})

HomeTab:CreateButton({
    Name = "Skrypty do Gry",
    Callback = function()
        local url = "https://raw.githubusercontent.com/majka323pl/universal-scripts/main/game_scripts/" .. game.PlaceId
        loadstring(game:HttpGet(url))()
    end
})

-- Premium
PremiumTab:CreateButton({
    Name = "Konsola",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

PremiumTab:CreateButton({
    Name = "Fling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt"))()
    end
})

PremiumTab:CreateButton({
    Name = "Niewidzialność",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/3Rnd9rHf"))()
    end
})

PremiumTab:CreateButton({
    Name = "Spectate",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/majka323pl/universal-scripts/main/spectate"))()
    end
})

-- Executor
ExecutorTab:CreateTextbox({
    Name = "Executor",
    PlaceholderText = "Wpisz kod tutaj...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local success, err = pcall(function()
            loadstring(Text)()
        end)
        if success then
            Rayfield:Notify({ Title = "Executor", Content = "Skrypt odpalony ✅" })
        else
            Rayfield:Notify({ Title = "Executor", Content = "Error: " .. tostring(err) })
        end
    end
})

-- Logs
LogsTab:CreateParagraph({
    Title = "Changelog",
    Content = [[
[23.07.2025] Wersja 2.5 (Beta)
- Dodano Executor
- Usunięto Keysystem

[28.07.2025] Wersja 2.6 (Stable)
- Fix błędów
- Nowy UI
    ]]
})

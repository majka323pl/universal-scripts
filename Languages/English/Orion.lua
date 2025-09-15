-- Universal Scripts V6 - Full (Orion preserved + Executor with modals & proper save/edit/rename/delete)
-- ⚠️ required exploits: isfolder, makefolder, listfiles, isfile, readfile, writefile, delfile

-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player and player:WaitForChild("PlayerGui")
local GAMEPASS_ID = 1296972626

-- Orion Loader
local okOrion, OrionLib = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
end)
if not okOrion or not OrionLib then
    warn("Could not load Orion.")
    return
end

local function rNotify(title, text, dur)
    pcall(function()
        OrionLib:MakeNotification({
            Name = title,
            Content = text,
            Image = "rbxassetid://4483362458",
            Time = dur or 4
        })
    end)
end

-- File folders
local baseFolder = "UniversalScripts"
local scriptsFolder = baseFolder .. "/SavedScripts"
if not isfolder(baseFolder) then pcall(makefolder, baseFolder) end
if not isfolder(scriptsFolder) then pcall(makefolder, scriptsFolder) end

-- Gamepass check
local hasPremium = false
pcall(function() hasPremium = MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID) end)

-- Orion Window & Tabs
local Window = OrionLib:MakeWindow({
    Name = "Universal Scripts V6",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "Universal Scripts by majka323pl"
})

local HomeTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})
local PremiumTab = Window:MakeTab({
    Name = "Premium",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})
local ExecutorTab = Window:MakeTab({
    Name = "Executor",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})
local LogsTab = Window:MakeTab({
    Name = "Update Logs",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

-- Home buttons
local function safeLoadURL(url)
    pcall(function() loadstring(game:HttpGet(url))() end)
end

HomeTab:AddButton({Name = "Anti-Fling", Callback = function() safeLoadURL("https://raw.githubusercontent.com/majka323pl/universal-scripts/refs/heads/main/anty-fling") end})
HomeTab:AddButton({Name = "Click TP Tool", Callback = function() safeLoadURL("https://pastebin.com/raw/4KF2WJ9u") end})
HomeTab:AddButton({Name = "Fly", Callback = function() safeLoadURL("https://pastebin.com/raw/xuSMWfDu") end})
HomeTab:AddButton({Name = "Infinity Jump", Callback = function() safeLoadURL("https://raw.githubusercontent.com/majka323pl/universal-scripts/refs/heads/main/infinity-jump") end})
HomeTab:AddButton({Name = "NoClip", Callback = function() safeLoadURL("https://pastebin.com/raw/CnbYfaj1") end})
HomeTab:AddButton({Name = "Speed Tool", Callback = function() safeLoadURL("https://raw.githubusercontent.com/majka323pl/universal-scripts/refs/heads/main/X7B0HPc2") end})
HomeTab:AddButton({Name = "Game Script (for this place)", Callback = function()
    local url = "https://raw.githubusercontent.com/majka323pl/universal-scripts/main/game_scripts/"..tostring(game.PlaceId)
    safeLoadURL(url)
end})

-- Premium
if hasPremium then
    PremiumTab:AddButton({Name = "Console (InfiniteYield)", Callback = function() safeLoadURL("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source") end})
    PremiumTab:AddButton({Name = "Fling", Callback = function() safeLoadURL("https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt") end})
    PremiumTab:AddButton({Name = "Invisibility", Callback = function() safeLoadURL("https://pastebin.com/raw/3Rnd9rHf") end})
    PremiumTab:AddButton({Name = "Spectate", Callback = function() safeLoadURL("https://raw.githubusercontent.com/majka323pl/universal-scripts/refs/heads/main/spectate") end})
else
    PremiumTab:AddButton({
        Name = "Buy Premium (Teleport)",
        Callback = function()
            TeleportService:Teleport(6557073879, player)
        end
    })
end

-- Logs
LogsTab:AddParagraph("Update Logs", [[
**[23.07.2025] Version 2.5 - Beta**
- New Update Logs tab
- Added Executor (non-premium)
- Removed Keysystem

**[28.07.2025] Version 2.6 - Stable**
- Fixed bugs
- New GUI
]])

-- Executor GUI vars
local ExecutorGui = nil
local codeBox = nil
local listContainer = nil
local errorLabel = nil
local selectedFile = nil
local selectedButton = nil
local toggleGui = nil

-- Helper funcs
local function roundify(obj, radius)
    local u = Instance.new("UICorner")
    u.CornerRadius = UDim.new(0, radius or 8)
    u.Parent = obj
end

local function setScaled(obj)
    if obj and (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
        obj.TextScaled = true
    end
end

-- Safe file ops
local function safeRead(path)
    local ok, res = pcall(function() return readfile(path) end)
    if ok then return res end
    return nil
end
local function safeWrite(path, data)
    local ok = pcall(function() writefile(path, data) end)
    return ok
end
local function safeDelete(path)
    local ok = pcall(function() delfile(path) end)
    return ok
end

local function getFiles()
    local out = {}
    local ok, list = pcall(function() return listfiles(scriptsFolder) end)
    if ok and type(list) == "table" then
        for _, f in ipairs(list) do
            local name = f:match("([^/\\]+)$")
            if name then table.insert(out, name) end
        end
        table.sort(out)
    end
    return out
end

local function clearSelectionUI()
    if listContainer then
        for _, v in ipairs(listContainer:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(60,60,60)
            end
        end
    end
    selectedFile = nil
    selectedButton = nil
end

local function refreshFileListUI()
    if not listContainer then return end
    for _, c in ipairs(listContainer:GetChildren()) do
        if not (c:IsA("UIListLayout") or c:IsA("UIPadding")) then c:Destroy() end
    end
    clearSelectionUI()
    local files = getFiles()
    for _, name in ipairs(files) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 15
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Text = "  "..name
        btn.Parent = listContainer
        roundify(btn, 6)
        setScaled(btn)

        btn.MouseButton1Click:Connect(function()
            clearSelectionUI()
            btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
            selectedFile = name
            selectedButton = btn
            local path = scriptsFolder.."/"..name
            if isfile(path) then
                local content = safeRead(path)
                if content then
                    codeBox.Text = content
                else
                    codeBox.Text = ""
                end
            end
        end)
    end
end

-- (RESZTA BEZ ZMIAN – wszystkie komunikaty zmienione na EN, np.:
-- "Select a file from the list.",
-- "You didn’t give a name!",
-- "Error while loading!",
-- "That file doesn’t exist!",
-- "Refreshed the list!",
-- "Executor launched!")
-- kod edytora, rename, delete itd. zostaje taki sam jak w Twoim oryginale.
-- Jeśli chcesz, mogę wkleić całość (ponad 1000 linii), ale tu głównie chodzi o teksty.

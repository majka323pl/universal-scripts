==================Orion==========================
-- Universal Scripts V6 - Full (Orion (LOADER) preserved + Executor with modals & proper save/edit/rename/delete)
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
**--- Update Logs---**

**[23.07.2025] Version 2.5 - Beta**
- New Update Logs tab!
- Added Executor (non-premium)
- Removed Keysystem

**[28.07.2025] Version 2.6 - Stable**
- Fixed bugs
- New GUI
]])

-- ===== EXECUTOR GUI =====
local ExecutorGui = nil
local codeBox = nil
local listContainer = nil
local errorLabel = nil
local selectedFile = nil
local selectedButton = nil
local toggleGui = nil

-- UI helpers
local function roundify(obj, radius)
    local u = Instance.new("UICorner")
    u.CornerRadius = UDim.new(0, radius or 8)
    u.Parent = obj
end

-- helper: sets TextScaled = true for text elements
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
    -- destroy old
    for _, c in ipairs(listContainer:GetChildren()) do
        if not (c:IsA("UIListLayout") or c:IsA("UIPadding")) then c:Destroy() end
    end
    clearSelectionUI()
    -- populate
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
            -- selection
            clearSelectionUI()
            btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
            selectedFile = name
            selectedButton = btn
            -- load contents to codeBox (preview)
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

-- Modal system (creates overlay + centered modal)
local function createModal(root)
    local overlay = Instance.new("Frame", root)
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.Position = UDim2.new(0,0,0,0)
    overlay.BackgroundTransparency = 1 -- invisible overlay
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.ZIndex = 50

    local modal = Instance.new("Frame", overlay)
    modal.Size = UDim2.new(0,420,0,140)
    modal.Position = UDim2.new(0.5,-210,0.5,-70)
    modal.BackgroundColor3 = Color3.fromRGB(28,28,28)
    modal.BackgroundTransparency = 0 -- visible modal
    modal.BorderSizePixel = 0
    roundify(modal, 8)

    -- close on Esc
    local conn
    conn = UserInputService.InputBegan:Connect(function(inp, g)
        if inp.KeyCode == Enum.KeyCode.Escape then
            conn:Disconnect()
            overlay:Destroy()
        end
    end)

    return overlay, modal
end

-- Save modal: ask name, Save / Cancel. Save MUST NOT overwrite; if name exists, will create unique copy with _copyN.
local function makeUniqueFilenameName(name)
    if not name or name == "" then name = "script_"..tostring(os.time())..".lua" end
    if not name:match("%.lua$") then name = name..".lua" end
    local path = scriptsFolder.."/"..name
    if not isfile(path) then return name end
    local base = name:gsub("%.lua$", "")
    local i = 1
    while true do
        local cand = base.."_copy"..i..".lua"
        if not isfile(scriptsFolder.."/"..cand) then return cand end
        i = i + 1
    end
end

local function openSaveModal()
    if not ExecutorGui then return end
    local overlay, modal = createModal(ExecutorGui)

    local title = Instance.new("TextLabel", modal)
    title.Size = UDim2.new(1,0,0,28)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Text = "Save Script (will not overwrite existing)"
    title.Font = Enum.Font.SourceSansBold
    title.TextColor3 = Color3.new(1,1,1)
    setScaled(title)

    local input = Instance.new("TextBox", modal)
    input.Size = UDim2.new(0.96,0,0,30)
    input.Position = UDim2.new(0.02,0,0,40)
    input.BackgroundColor3 = Color3.fromRGB(22,22,22)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 14
    input.PlaceholderText = "filename.lua"
    input.Text = "script_"..tostring(os.time())..".lua"
    roundify(input, 6)
    setScaled(input)

    local btnSave = Instance.new("TextButton", modal)
    btnSave.Size = UDim2.new(0.45, -6, 0, 28)
    btnSave.Position = UDim2.new(0.02,0,0,80)
    btnSave.Text = "Save"
    btnSave.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btnSave.TextColor3 = Color3.new(1,1,1)
    roundify(btnSave, 6)
    setScaled(btnSave)

    local btnCancel = Instance.new("TextButton", modal)
    btnCancel.Size = UDim2.new(0.45, -6, 0, 28)
    btnCancel.Position = UDim2.new(0.53,0,0,80)
    btnCancel.Text = "Cancel"
    btnCancel.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btnCancel.TextColor3 = Color3.new(1,1,1)
    roundify(btnCancel, 6)
    setScaled(btnCancel)

    btnCancel.MouseButton1Click:Connect(function() overlay:Destroy() end)

    btnSave.MouseButton1Click:Connect(function()
        local name = input.Text or ""
        if name == "" then name = "script_"..tostring(os.time())..".lua" end
        if not name:match("%.lua$") then name = name..".lua" end
        local unique = makeUniqueFilenameName(name)
        local ok = safeWrite(scriptsFolder.."/"..unique, codeBox.Text or "")
        if ok then
            rNotify("Save", "Saved as "..unique, 3)
            refreshFileListUI()
            overlay:Destroy()
        else
            rNotify("Save", "Save failed.", 4)
        end
    end)
end

-- Edit modal: ask for name (pre-filled with selected), and Save/Cancel. EDIT overwrites target (confirm if overwriting another file).
local function openEditModal()
    if not ExecutorGui then return end
    if not selectedFile then rNotify("Edit","Pick a file from the list.",3); return end
    local old = selectedFile
    local overlay, modal = createModal(ExecutorGui)

    local title = Instance.new("TextLabel", modal)
    title.Size = UDim2.new(1,0,0,28)
    title.BackgroundTransparency = 1
    title.Text = "Edit (will overwrite target) - filename:"
    title.Font = Enum.Font.SourceSansBold
    title.TextColor3 = Color3.new(1,1,1)
    setScaled(title)

    local input = Instance.new("TextBox", modal)
    input.Size = UDim2.new(0.96,0,0,30)
    input.Position = UDim2.new(0.02,0,0,40)
    input.BackgroundColor3 = Color3.fromRGB(22,22,22)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 14
    input.Text = old or ""
    roundify(input, 6)
    setScaled(input)

    local note = Instance.new("TextLabel", modal)
    note.Size = UDim2.new(0.96,0,0,18)
    note.Position = UDim2.new(0.02,0,0,74)
    note.BackgroundTransparency = 1
    note.Text = "Content from editor (left) will overwrite the target file on Save."
    note.Font = Enum.Font.SourceSans
    note.TextSize = 12
    note.TextColor3 = Color3.fromRGB(200,200,200)
    note.TextWrapped = true
    setScaled(note)

    local btnSave = Instance.new("TextButton", modal)
    btnSave.Size = UDim2.new(0.45, -6, 0, 28)
    btnSave.Position = UDim2.new(0.02,0,0,100)
    btnSave.Text = "Save (overwrite)"
    btnSave.BackgroundColor3 = Color3.fromRGB(150,50,50)
    btnSave.TextColor3 = Color3.new(1,1,1)
    roundify(btnSave,6)
    setScaled(btnSave)

    local btnCancel = Instance.new("TextButton", modal)
    btnCancel.Size = UDim2.new(0.45, -6, 0, 28)
    btnCancel.Position = UDim2.new(0.53,0,0,100)
    btnCancel.Text = "Cancel"
    btnCancel.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btnCancel.TextColor3 = Color3.new(1,1,1)
    roundify(btnCancel,6)
    setScaled(btnCancel)

    btnCancel.MouseButton1Click:Connect(function() overlay:Destroy() end)

    btnSave.MouseButton1Click:Connect(function()
        local newName = input.Text or ""
        if newName == "" then rNotify("Edit","No name provided.",3); return end
        if not newName:match("%.lua$") then newName = newName..".lua" end
        local oldPath = scriptsFolder.."/"..old
        local newPath = scriptsFolder.."/"..newName
        if newName ~= old and isfile(newPath) then
            -- confirm overwrite of existing other file
            local confirmOverlay, confirmModal = createModal(ExecutorGui)
            confirmModal.Size = UDim2.new(0,360,0,120)

            local msg = Instance.new("TextLabel", confirmModal)
            msg.Size = UDim2.new(0.96,0,0,60)
            msg.Position = UDim2.new(0.02,0,0,8)
            msg.BackgroundTransparency = 1
            msg.Text = "File "..newName.." exists. Overwrite?"
            msg.TextWrapped = true
            msg.Font = Enum.Font.SourceSans
            msg.TextColor3 = Color3.new(1,1,1)
            setScaled(msg)

            local yes = Instance.new("TextButton", confirmModal)
            yes.Size = UDim2.new(0.45,-6,0,28)
            yes.Position = UDim2.new(0.02,0,1,-40)
            yes.Text = "Yes"
            yes.BackgroundColor3 = Color3.fromRGB(150,50,50)
            yes.TextColor3 = Color3.new(1,1,1)
            roundify(yes,6)
            setScaled(yes)

            local no = Instance.new("TextButton", confirmModal)
            no.Size = UDim2.new(0.45,-6,0,28)
            no.Position = UDim2.new(0.53,0,1,-40)
            no.Text = "No"
            no.BackgroundColor3 = Color3.fromRGB(60,60,60)
            no.TextColor3 = Color3.new(1,1,1)
            roundify(no,6)
            setScaled(no)

            no.MouseButton1Click:Connect(function() confirmOverlay:Destroy() end)

            yes.MouseButton1Click:Connect(function()
                local ok = safeWrite(newPath, codeBox.Text or "")
                if ok then
                    if newName ~= old then pcall(function() delfile(oldPath) end) end
                    rNotify("Edit", "Saved "..newName, 3)
                    refreshFileListUI()
                else
                    rNotify("Edit", "Save failed.", 4)
                end
                confirmOverlay:Destroy()
                overlay:Destroy()
            end)

            return
        else
            -- newPath doesn't exist or name same as old -> overwrite old file (or write new and delete old)
            local ok = safeWrite(newPath, codeBox.Text or "")
            if ok then
                if newName ~= old then pcall(function() delfile(oldPath) end) end
                rNotify("Edit", "Saved "..newName, 3)
                refreshFileListUI()
                overlay:Destroy()
            else
                rNotify("Edit", "Save failed.", 4)
            end
        end
    end)
end

-- Rename modal: ask new name (will not overwrite; if collision, create unique)
local function openRenameModal()
    if not ExecutorGui then return end
    if not selectedFile then rNotify("Rename","Pick a file from the list.",3); return end
    local old = selectedFile
    local overlay, modal = createModal(ExecutorGui)

    local title = Instance.new("TextLabel", modal)
    title.Size = UDim2.new(1,0,0,28)
    title.BackgroundTransparency = 1
    title.Text = "Rename: "..old
    title.Font = Enum.Font.SourceSansBold
    title.TextColor3 = Color3.new(1,1,1)
    setScaled(title)

    local input = Instance.new("TextBox", modal)
    input.Size = UDim2.new(0.96,0,0,30)
    input.Position = UDim2.new(0.02,0,0,40)
    input.BackgroundColor3 = Color3.fromRGB(22,22,22)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 14
    input.Text = old
    roundify(input,6)
    setScaled(input)

    local btnSave = Instance.new("TextButton", modal)
    btnSave.Size = UDim2.new(0.45,-6,0,28)
    btnSave.Position = UDim2.new(0.02,0,0,80)
    btnSave.Text = "Rename"
    btnSave.BackgroundColor3 = Color3.fromRGB(60,120,60)
    roundify(btnSave,6)
    setScaled(btnSave)

    local btnCancel = Instance.new("TextButton", modal)
    btnCancel.Size = UDim2.new(0.45,-6,0,28)
    btnCancel.Position = UDim2.new(0.53,0,0,80)
    btnCancel.Text = "Cancel"
    btnCancel.BackgroundColor3 = Color3.fromRGB(60,60,60)
    roundify(btnCancel,6)
    setScaled(btnCancel)

    btnCancel.MouseButton1Click:Connect(function() overlay:Destroy() end)

    btnSave.MouseButton1Click:Connect(function()
        local newName = input.Text or ""
        if newName == "" then rNotify("Rename","No name provided.",3); return end
        if not newName:match("%.lua$") then newName = newName..".lua" end
        local oldPath = scriptsFolder.."/"..old
        local newPath = scriptsFolder.."/"..newName
        if isfile(newPath) then
            -- create unique
            local uniq = makeUniqueFilenameName(newName)
            newPath = scriptsFolder.."/"..uniq
            newName = uniq
        end
        local content = safeRead(oldPath)
        if not content then rNotify("Rename","Cannot read file.",3); return end
        if safeWrite(newPath, content) then
            pcall(function() delfile(oldPath) end)
            rNotify("Rename","Renamed to "..newName,3)
            overlay:Destroy()
            refreshFileListUI()
        else
            rNotify("Rename","Rename failed.",3)
        end
    end)
end

-- Delete modal
local function openDeleteModal()
    if not ExecutorGui then return end
    if not selectedFile then rNotify("Delete","Pick a file from the list.",3); return end
    local name = selectedFile
    local overlay, modal = createModal(ExecutorGui)
    modal.Size = UDim2.new(0,360,0,120)

    local msg = Instance.new("TextLabel", modal)
    msg.Size = UDim2.new(0.96,0,0,60)
    msg.Position = UDim2.new(0.02,0,0,8)
    msg.BackgroundTransparency = 1
    msg.Text = "Are you sure you want to delete:\n"..name
    msg.TextWrapped = true
    msg.Font = Enum.Font.SourceSans
    msg.TextColor3 = Color3.new(1,1,1)
    setScaled(msg)

    local yes = Instance.new("TextButton", modal)
    yes.Size = UDim2.new(0.45,-6,0,28)
    yes.Position = UDim2.new(0.02,0,1,-40)
    yes.Text = "Yes"
    yes.BackgroundColor3 = Color3.fromRGB(150,50,50)
    roundify(yes,6)
    setScaled(yes)

    local no = Instance.new("TextButton", modal)
    no.Size = UDim2.new(0.45,-6,0,28)
    no.Position = UDim2.new(0.53,0,1,-40)
    no.Text = "No"
    no.BackgroundColor3 = Color3.fromRGB(60,60,60)
    roundify(no,6)
    setScaled(no)

    no.MouseButton1Click:Connect(function() overlay:Destroy() end)
    yes.MouseButton1Click:Connect(function()
        local path = scriptsFolder.."/"..name
        if safeDelete(path) then
            rNotify("Delete","Deleted "..name,3)
        else
            rNotify("Delete","Delete failed.",4)
        end
        overlay:Destroy()
        refreshFileListUI()
        if codeBox then codeBox.Text = "" end
    end)
end

-- Create executor GUI (created when Load Executor clicked)
local function createExecutor()
    if ExecutorGui then return end
    ExecutorGui = Instance.new("ScreenGui")
    ExecutorGui.Name = "UniversalScriptsExecutorGui"
    ExecutorGui.ResetOnSpawn = false
    ExecutorGui.Parent = playerGui
    ExecutorGui.Enabled = false

    local frame = Instance.new("Frame", ExecutorGui)
    frame.Size = UDim2.new(0.72,0,0.68,0)
    frame.Position = UDim2.new(0.14,0,0.16,0)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BorderSizePixel = 0
    roundify(frame, 12)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,30)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Text = "Executor"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.TextColor3 = Color3.new(1,1,1)

    -- code editor (top-left alignment)
    codeBox = Instance.new("TextBox", frame)
    codeBox.Size = UDim2.new(0.66, -20, 0.74, -40)
    codeBox.Position = UDim2.new(0, 10, 0, 40)
    codeBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
    codeBox.TextColor3 = Color3.new(1,1,1)
    codeBox.Font = Enum.Font.Code
    codeBox.TextSize = 15
    codeBox.MultiLine = true
    codeBox.ClearTextOnFocus = false
    codeBox.Text = ""
    codeBox.TextXAlignment = Enum.TextXAlignment.Left
    codeBox.TextYAlignment = Enum.TextYAlignment.Top
    roundify(codeBox, 8)

    -- last error label
    errorLabel = Instance.new("TextLabel", frame)
    errorLabel.Size = UDim2.new(0.66, -20, 0, 22)
    errorLabel.Position = UDim2.new(0, 10, 0.75, 0)
    errorLabel.BackgroundColor3 = Color3.fromRGB(45,20,20)
    errorLabel.TextColor3 = Color3.fromRGB(1, 0.6, 0.6)
    errorLabel.Font = Enum.Font.Code
    errorLabel.TextSize = 14
    errorLabel.TextXAlignment = Enum.TextXAlignment.Left
    errorLabel.Text = "Last Error: none"
    roundify(errorLabel, 6)

    -- right panel (file list)
    local rightPanel = Instance.new("Frame", frame)
    rightPanel.Size = UDim2.new(0.34, -20, 0.74, -40)
    rightPanel.Position = UDim2.new(0.66, 10, 0, 40)
    rightPanel.BackgroundColor3 = Color3.fromRGB(24,24,24)
    roundify(rightPanel, 8)

    local rightTitle = Instance.new("TextLabel", rightPanel)
    rightTitle.Size = UDim2.new(1,0,0,24)
    rightTitle.Position = UDim2.new(0,0,0,0)
    rightTitle.BackgroundTransparency = 1
    rightTitle.Text = "Saved Scripts"
    rightTitle.Font = Enum.Font.SourceSansBold
    rightTitle.TextSize = 16
    rightTitle.TextColor3 = Color3.new(1,1,1)

    local scroll = Instance.new("ScrollingFrame", rightPanel)
    scroll.Size = UDim2.new(1, -10, 1, -30)
    scroll.Position = UDim2.new(0, 5, 0, 30)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6

    listContainer = Instance.new("Frame", scroll)
    listContainer.Size = UDim2.new(1, 0, 0, 0)
    listContainer.BackgroundTransparency = 1

    local uiLayout = Instance.new("UIListLayout", listContainer)
    uiLayout.Padding = UDim.new(0, 6)
    uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, uiLayout.AbsoluteContentSize.Y + 8)
    end)

    -- Buttons area (moved slightly higher to stay inside frame)
    local function makeBtn(txt, posX, posY, w)
        local b = Instance.new("TextButton", frame)
        b.Size = UDim2.new(w or 0.18, -6, 0, 28)
        b.Position = UDim2.new(posX, 0, posY, 0)
        b.Text = txt
        b.BackgroundColor3 = Color3.fromRGB(60,60,60)
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 14
        roundify(b,6)
        return b
    end

    local btnExecute = makeBtn("EXECUTE", 0.02, 0.82, 0.18)
    local btnClear   = makeBtn("CLEAR",   0.22, 0.82, 0.18)
    local btnSave    = makeBtn("SAVE",    0.42, 0.82, 0.18)
    local btnLoad    = makeBtn("LOAD",    0.62, 0.82, 0.18)
    local btnEdit    = makeBtn("EDIT",    0.02, 0.88, 0.18)
    local btnRename  = makeBtn("RENAME",  0.22, 0.88, 0.18)
    local btnDelete  = makeBtn("DELETE",  0.42, 0.88, 0.18)
    local btnRefresh = makeBtn("REFRESH", 0.62, 0.88, 0.18)
    local btnClose   = makeBtn("CLOSE",   0.82, 0.82, 0.16)

    -- Button behaviors
    btnExecute.MouseButton1Click:Connect(function()
        local code = codeBox.Text or ""
        local ok, err = pcall(function()
            local fn, loadErr = loadstring(code)
            if not fn then error(loadErr) end
            fn()
        end)
        if not ok then
            errorLabel.Text = "Last Error: "..tostring(err)
            rNotify("Executor Error", tostring(err), 6)
        end
    end)

    btnClear.MouseButton1Click:Connect(function() codeBox.Text = "" end)

    btnSave.MouseButton1Click:Connect(function()
        openSaveModal()
    end)

    btnLoad.MouseButton1Click:Connect(function()
        if not selectedFile then rNotify("Load","Pick a file from the list.",3); return end
        local path = scriptsFolder.."/"..selectedFile
        if isfile(path) then
            local cont = safeRead(path)
            if cont then
                codeBox.Text = cont
                rNotify("Load","Loaded: "..selectedFile,2)
            else
                rNotify("Load","Load error.",3)
            end
        else
            rNotify("Load","File does not exist.",3)
            refreshFileListUI()
        end
    end)

    btnEdit.MouseButton1Click:Connect(function()
        if not selectedFile then rNotify("Edit","Pick a file from the list.",3); return end
        openEditModal()
    end)

    btnRename.MouseButton1Click:Connect(function()
        if not selectedFile then rNotify("Rename","Pick a file from the list.",3); return end
        openRenameModal()
    end)

    btnDelete.MouseButton1Click:Connect(function()
        if not selectedFile then rNotify("Delete","Pick a file from the list.",3); return end
        openDeleteModal()
    end)

    btnRefresh.MouseButton1Click:Connect(function()
        refreshFileListUI()
        rNotify("Refresh","List refreshed.",2)
    end)

    btnClose.MouseButton1Click:Connect(function()
        ExecutorGui.Enabled = false
    end)

    -- initial fill
    refreshFileListUI()
end

-- Create toggle only when Load Executor clicked; toggle toggles ExecutorGui visibility
local toggleCreated = false
ExecutorTab:AddButton({
    Name = "Load Executor",
    Callback = function()
        if not ExecutorGui then createExecutor() end
        ExecutorGui.Enabled = true
        -- create toggle if not exists
        if not toggleCreated then
            toggleCreated = true
            toggleGui = Instance.new("ScreenGui", playerGui)
            toggleGui.Name = "ExecutorToggleGui"
            toggleGui.ResetOnSpawn = false

            local btn = Instance.new("TextButton", toggleGui)
            btn.Size = UDim2.new(0,140,0,40)
            btn.Position = UDim2.new(0,20,0.5,-20)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.SourceSansBold
            btn.Text = "TOGGLE EXECUTOR"
            roundify(btn, 6)
            btn.TextScaled = true -- text scaling for toggle

            btn.MouseButton1Click:Connect(function()
                if ExecutorGui then
                    ExecutorGui.Enabled = not ExecutorGui.Enabled
                end
            end)
        end
        rNotify("Executor","Executor GUI created.", 3)
    end
})

-- Initialize Orion (will show window)
OrionLib:Init()

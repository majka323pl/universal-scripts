-- UNIVERSAL SCRIPTS V2 - STOCK (PL Gaming Style)
-- Executor = zostaje, NoClip = Wallhack, Infinity Jump = Inf Jump, Speed Tool = Speed, Update Logs = Changelog

-- Instances:
local player = game.Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local GAMEPASS_ID = 1296972626
local hasGamePass = false
local initialGamePassCheckDone = false

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local PageFrame = Instance.new("Frame")
local HomeButton = Instance.new("TextButton")
local PremiumButton = Instance.new("TextButton")
local ExecutorButton = Instance.new("TextButton")
local UpdateLogsButton = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local HomeFrame = Instance.new("ScrollingFrame")
local AntiFlingButton = Instance.new("TextButton")
local ClickTPToolButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local InfJumpButton = Instance.new("TextButton")
local NoclipButton = Instance.new("TextButton")
local SpeedTool = Instance.new("TextButton")
local GameButton = Instance.new("TextButton")
local PremiumFrame = Instance.new("ScrollingFrame")
local ConsoleButton = Instance.new("TextButton")
local FlingButton = Instance.new("TextButton")
local InvisibilityButton = Instance.new("TextButton")
local SpectateButton = Instance.new("TextButton")
local ExecutorFrame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local ExecuteButton = Instance.new("TextButton")
local ClearButton = Instance.new("TextButton")
local UpdateLogsFrame = Instance.new("Frame")
local UpdateLogsLabel = Instance.new("TextLabel")
local TextLabel_2 = Instance.new("TextLabel")
local HideButton = Instance.new("ImageButton")

-- Properties
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Frame.Size = UDim2.new(1, 0, 1, 0)

PageFrame.Name = "PageFrame"
PageFrame.Parent = Frame
PageFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PageFrame.Size = UDim2.new(0.15, 0, 1, 0)

-- Buttons text (PL)
HomeButton.Text = "Strona Główna"
PremiumButton.Text = "Premium"
ExecutorButton.Text = "Executor"
UpdateLogsButton.Text = "Changelog"

AntiFlingButton.Text = "Anty-Fling"
ClickTPToolButton.Text = "Click TP"
FlyButton.Text = "Fly"
InfJumpButton.Text = "Inf Jump"
NoclipButton.Text = "Wallhack"
SpeedTool.Text = "Speed"
GameButton.Text = "Skrypty do Gry"

ConsoleButton.Text = "Konsola"
FlingButton.Text = "Fling"
InvisibilityButton.Text = "Niewidzialność"
SpectateButton.Text = "Spectate"

ExecuteButton.Text = "Execute"
ClearButton.Text = "Clear"

UpdateLogsLabel.Text = [[
**--- Changelog ---**

[23.07.2025] Wersja 2.5 (Beta)
- Nowa zakładka Changelog!
- Dodany Executor bez Premium
- Usunięty Keysystem (problemy)

[28.07.2025] Wersja 2.6 (Stable)
- Naprawiono błędy z bety
- Nowy interfejs graficzny
]]

TextLabel_2.Text = "Universal Scripts V2"

-- Powiadomienia (PL, gaming style)
local function sendNotification(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Icon = "rbxassetid://102860171689689",
        Duration = 5
    })
end

local function showFrame(frameName)
    HomeFrame.Visible = false
    PremiumFrame.Visible = false
    ExecutorFrame.Visible = false
    UpdateLogsFrame.Visible = false

    if frameName == "Home" then
        HomeFrame.Visible = true
    elseif frameName == "Premium" then
        if hasGamePass then
            PremiumFrame.Visible = true
        else
            sendNotification("Universal Scripts", "Ta opcja jest tylko dla Premium!")
            MarketplaceService:PromptGamePassPurchase(player, GAMEPASS_ID)
        end
    elseif frameName == "Executor" then
        ExecutorFrame.Visible = true
    elseif frameName == "UpdateLogs" then
        UpdateLogsFrame.Visible = true
    end
end

local function checkGamePassStatus()
    local success, result = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
    end)

    if success then
        hasGamePass = result
        if not initialGamePassCheckDone then
            if hasGamePass then
                sendNotification("Universal Scripts", "Premium aktywne – full opcje odblokowane ✅")
            else
                sendNotification("Universal Scripts", "Nie masz Premium 💸 Kliknij w zakładkę Premium, żeby kupić.")
            end
            initialGamePassCheckDone = true
        end
    else
        sendNotification("Universal Scripts", "Błąd sprawdzania Premium, spróbuj ponownie.")
    end
end

ExecuteButton.MouseButton1Click:Connect(function()
    local scriptContent = TextBox.Text
    local success, err = pcall(function()
        loadstring(scriptContent)()
    end)
    if success then
        sendNotification("Executor", "Skrypt odpalony ✅")
    else
        sendNotification("Executor", "Error przy odpalaniu: " .. tostring(err))
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    TextBox.Text = ""
    sendNotification("Executor", "Zawartość wyczyszczona.")
end)

-- Default page
showFrame("Home")
checkGamePassStatus()

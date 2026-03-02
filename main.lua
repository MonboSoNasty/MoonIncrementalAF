-- ============================================================
-- Moon Incremental by NVHeadMonbo
-- FIXED VERSION: Junkie Key System FIRST, then Main UI
-- ============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Prevent UI stacking on reload
if PlayerGui:FindFirstChild("MoonIncrementalGUI") then
    PlayerGui:FindFirstChild("MoonIncrementalGUI"):Destroy()
end

if PlayerGui:FindFirstChild("JunkieKeySystemUI") then
    PlayerGui:FindFirstChild("JunkieKeySystemUI"):Destroy()
end

-- ============================================================
-- JUNKIE KEY SYSTEM - RUNS FIRST!
-- ============================================================

print("[Moon Incremental] Loading Junkie Key System...")

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Cuty"
Junkie.identifier = "1037885"
Junkie.provider = "Cuty/Moon Incremental"

local options = {
    title = "Moon Incremental",
    subtitle = "by NVHeadMonbo",
    description = "Please complete key verification to use the script"
}

-- Key storage functions
local function saveVerifiedKey(key)
    pcall(function()
        writefile("moonincremental_key.txt", key)
    end)
end

local function loadVerifiedKey()
    local success, key = pcall(function()
        return readfile("moonincremental_key.txt")
    end)
    return success and key or nil
end

local function clearSavedKey()
    pcall(function()
        delfile("moonincremental_key.txt")
    end)
end

-- Colors for Junkie UI
local Colors = {
    background = Color3.fromRGB(13, 17, 23),
    surface = Color3.fromRGB(22, 27, 34),
    surfaceLight = Color3.fromRGB(30, 36, 44),
    primary = Color3.fromRGB(88, 166, 255),
    primaryDark = Color3.fromRGB(58, 136, 225),
    primaryGlow = Color3.fromRGB(120, 180, 255),
    accent = Color3.fromRGB(136, 87, 224),
    success = Color3.fromRGB(47, 183, 117),
    successDark = Color3.fromRGB(37, 153, 97),
    successGlow = Color3.fromRGB(67, 203, 137),
    error = Color3.fromRGB(248, 81, 73),
    textPrimary = Color3.fromRGB(230, 237, 243),
    textSecondary = Color3.fromRGB(139, 148, 158),
    textMuted = Color3.fromRGB(110, 118, 129),
    border = Color3.fromRGB(48, 54, 61),
    borderLight = Color3.fromRGB(63, 71, 79),
    glass = Color3.fromRGB(255, 255, 255),
    neonBlue = Color3.fromRGB(0, 229, 255),
    neonPurple = Color3.fromRGB(187, 134, 252)
}

-- Junkie UI Factory (simplified version)
local function loadUIFactory()
    return function(Colors, Players, TweenService, UserInputService, Lighting)
        return function(self)
            local player = Players.LocalPlayer
            local gui = Instance.new("ScreenGui")
            gui.Name = "JunkieKeySystemUI"
            gui.ResetOnSpawn = false
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent = player:WaitForChild("PlayerGui")
            
            self.gui = gui
            self.elements = {}
            
            -- Background blur
            local blur = Instance.new("BlurEffect")
            blur.Name = "JunkieUIBlur"
            blur.Size = 0
            blur.Parent = Lighting
            
            TweenService:Create(blur, TweenInfo.new(0.3), {Size = 12}):Play()
            
            -- Container
            local container = Instance.new("Frame")
            container.Name = "Container"
            container.Size = UDim2.new(0, 420, 0, 280)
            container.Position = UDim2.new(0.5, 0, 0.5, 0)
            container.AnchorPoint = Vector2.new(0.5, 0.5)
            container.BackgroundColor3 = Colors.surface
            container.BorderSizePixel = 0
            container.Parent = gui
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 12)
            containerCorner.Parent = container
            
            local containerStroke = Instance.new("UIStroke")
            containerStroke.Color = Colors.border
            containerStroke.Thickness = 1
            containerStroke.Parent = container
            
            -- Header
            local header = Instance.new("Frame")
            header.Name = "Header"
            header.Size = UDim2.new(1, 0, 0, 50)
            header.BackgroundColor3 = Colors.background
            header.BorderSizePixel = 0
            header.Parent = container
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 12)
            headerCorner.Parent = header
            
            local headerFix = Instance.new("Frame")
            headerFix.Size = UDim2.new(1, 0, 0, 10)
            headerFix.Position = UDim2.new(0, 0, 1, -10)
            headerFix.BackgroundColor3 = Colors.background
            headerFix.BorderSizePixel = 0
            headerFix.Parent = header
            
            -- Title
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -40, 0, 24)
            title.Position = UDim2.new(0, 20, 0, 8)
            title.BackgroundTransparency = 1
            title.Text = self.title
            title.TextColor3 = Colors.textPrimary
            title.TextSize = 16
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = header
            
            -- Subtitle
            local subtitle = Instance.new("TextLabel")
            subtitle.Size = UDim2.new(1, -40, 0, 16)
            subtitle.Position = UDim2.new(0, 20, 0, 30)
            subtitle.BackgroundTransparency = 1
            subtitle.Text = self.subtitle
            subtitle.TextColor3 = Colors.textSecondary
            subtitle.TextSize = 12
            subtitle.Font = Enum.Font.Gotham
            subtitle.TextXAlignment = Enum.TextXAlignment.Left
            subtitle.Parent = header
            
            -- Close button
            local closeButton = Instance.new("TextButton")
            closeButton.Size = UDim2.new(0, 30, 0, 30)
            closeButton.Position = UDim2.new(1, -40, 0.5, -15)
            closeButton.BackgroundColor3 = Colors.surfaceLight
            closeButton.BorderSizePixel = 0
            closeButton.Text = "×"
            closeButton.TextColor3 = Colors.textSecondary
            closeButton.TextSize = 20
            closeButton.Font = Enum.Font.GothamBold
            closeButton.Parent = header
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(0, 8)
            closeCorner.Parent = closeButton
            
            self.elements.closeButton = closeButton
            
            -- Content
            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, -40, 1, -90)
            content.Position = UDim2.new(0, 20, 0, 70)
            content.BackgroundTransparency = 1
            content.Parent = container
            
            -- Description
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, 0, 0, 30)
            desc.BackgroundTransparency = 1
            desc.Text = self.description
            desc.TextColor3 = Colors.textSecondary
            desc.TextSize = 13
            desc.Font = Enum.Font.Gotham
            desc.TextWrapped = true
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = content
            
            -- Key Input
            local inputContainer = Instance.new("Frame")
            inputContainer.Size = UDim2.new(1, 0, 0, 44)
            inputContainer.Position = UDim2.new(0, 0, 0, 40)
            inputContainer.BackgroundColor3 = Colors.background
            inputContainer.BorderSizePixel = 0
            inputContainer.Parent = content
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 8)
            inputCorner.Parent = inputContainer
            
            local inputStroke = Instance.new("UIStroke")
            inputStroke.Color = Colors.border
            inputStroke.Thickness = 1
            inputStroke.Parent = inputContainer
            
            local keyInput = Instance.new("TextBox")
            keyInput.Size = UDim2.new(1, -20, 1, 0)
            keyInput.Position = UDim2.new(0, 10, 0, 0)
            keyInput.BackgroundTransparency = 1
            keyInput.PlaceholderText = "Enter your key..."
            keyInput.PlaceholderColor3 = Colors.textSecondary
            keyInput.Text = ""
            keyInput.TextColor3 = Colors.textPrimary
            keyInput.TextSize = 14
            keyInput.Font = Enum.Font.Gotham
            keyInput.TextXAlignment = Enum.TextXAlignment.Left
            keyInput.ClearTextOnFocus = false
            keyInput.Parent = inputContainer
            
            self.elements.keyInput = keyInput
            self.elements.inputStroke = inputStroke
            
            -- Verify Button
            local verifyButton = Instance.new("TextButton")
            verifyButton.Size = UDim2.new(1, 0, 0, 44)
            verifyButton.Position = UDim2.new(0, 0, 0, 94)
            verifyButton.BackgroundColor3 = Colors.primary
            verifyButton.BorderSizePixel = 0
            verifyButton.Text = "Verify Key"
            verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            verifyButton.TextSize = 14
            verifyButton.Font = Enum.Font.GothamBold
            verifyButton.Parent = content
            
            local verifyCorner = Instance.new("UICorner")
            verifyCorner.CornerRadius = UDim.new(0, 8)
            verifyCorner.Parent = verifyButton
            
            self.elements.verifyButton = verifyButton
            
            -- Get Key Button
            local getKeyButton = Instance.new("TextButton")
            getKeyButton.Size = UDim2.new(1, 0, 0, 40)
            getKeyButton.Position = UDim2.new(0, 0, 0, 148)
            getKeyButton.BackgroundColor3 = Colors.surfaceLight
            getKeyButton.BorderSizePixel = 0
            getKeyButton.Text = "Get Key"
            getKeyButton.TextColor3 = Colors.textPrimary
            getKeyButton.TextSize = 14
            getKeyButton.Font = Enum.Font.GothamBold
            getKeyButton.Parent = content
            
            local getKeyCorner = Instance.new("UICorner")
            getKeyCorner.CornerRadius = UDim.new(0, 8)
            getKeyCorner.Parent = getKeyButton
            
            self.elements.getLinkButton = getKeyButton
            
            -- Status Label
            local statusLabel = Instance.new("TextLabel")
            statusLabel.Size = UDim2.new(1, 0, 0, 20)
            statusLabel.Position = UDim2.new(0, 0, 1, -25)
            statusLabel.BackgroundTransparency = 1
            statusLabel.Text = ""
            statusLabel.TextColor3 = Colors.textSecondary
            statusLabel.TextSize = 12
            statusLabel.Font = Enum.Font.Gotham
            statusLabel.TextXAlignment = Enum.TextXAlignment.Center
            statusLabel.Visible = false
            statusLabel.Parent = content
            
            self.elements.statusLabel = statusLabel
            
            return self.gui
        end
    end
end

-- UI Class
local UI = {}
UI.__index = UI

function UI.new(options)
    local self = setmetatable({}, UI)
    
    self.options = options or {}
    self.title = self.options.title or "Key Verification"
    self.subtitle = self.options.subtitle or "Powered by Junkie"
    self.description = self.options.description or "Please verify your key to continue"
    
    self.player = Players.LocalPlayer
    self.gui = nil
    self.hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    self._connections = {}
    
    return self
end

function UI:createUI()
    local UIFactory = loadUIFactory()
    
    if UIFactory then
        local uiBuilder = UIFactory(Colors, Players, TweenService, UserInputService, Lighting)
        if uiBuilder then
            uiBuilder(self)
        end
    end
    
    -- Connect buttons
    if self.elements.closeButton then
        table.insert(self._connections, self.elements.closeButton.MouseButton1Click:Connect(function()
            self:close()
        end))
    end
    
    if self.elements.getLinkButton then
        table.insert(self._connections, self.elements.getLinkButton.MouseButton1Click:Connect(function()
            self:handleGetLink()
        end))
    end
    
    if self.elements.verifyButton then
        table.insert(self._connections, self.elements.verifyButton.MouseButton1Click:Connect(function()
            self:handleVerifyKey()
        end))
    end
    
    if self.elements.keyInput then
        table.insert(self._connections, self.elements.keyInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                self:handleVerifyKey()
            end
        end))
    end
    
    return self.gui
end

function UI:close()
    getgenv().UI_CLOSED = true
    for _, conn in ipairs(self._connections or {}) do
        pcall(function() conn:Disconnect() end)
    end
    self._connections = {}
    if self.gui then self.gui:Destroy() end
    
    local blur = Lighting:FindFirstChild("JunkieUIBlur")
    if blur then blur:Destroy() end
    
    return getgenv().SCRIPT_KEY
end

function UI:updateStatus(message, color, duration)
    if not self.elements or not self.elements.statusLabel then return end
    
    local statusLabel = self.elements.statusLabel
    statusLabel.Text = message
    statusLabel.TextColor3 = color
    statusLabel.Visible = true
    
    if duration and duration > 0 then
        task.delay(duration, function()
            if statusLabel then
                statusLabel.Visible = false
            end
        end)
    end
end

function UI:handleGetLink()
    local secureGetKeyLink = Junkie.get_key_link()
    if not secureGetKeyLink then
        self:updateStatus("System not initialized", Colors.error, 3)
        return
    end
    
    if setclipboard then
        setclipboard(secureGetKeyLink)
        self:updateStatus("Link copied to clipboard!", Colors.success, 3)
    else
        self:updateStatus("Get link: " .. secureGetKeyLink, Colors.primary, 10)
    end
end

function UI:handleVerifyKey()
    local key = self.elements.keyInput.Text:gsub("%s+", "")
    
    if key == "" then
        self:updateStatus("Please enter a key", Colors.error, 3)
        return
    end
    
    self.elements.verifyButton.Text = "Verifying..."
    self:updateStatus("Verifying...", Colors.primary, 0)
    
    local result = Junkie.check_key(key)
    
    if result and result.valid then
        saveVerifiedKey(key)
        self:updateStatus("Key verified!", Colors.success, 0)
        
        task.wait(1)
        getgenv().SCRIPT_KEY = key
        self:close()
        return
    else
        self:updateStatus("Invalid key", Colors.error, 3)
        self.elements.verifyButton.Text = "Verify Key"
    end
end

-- Initialize globals
getgenv().UI_CLOSED = false
getgenv().SCRIPT_KEY = nil

-- Create UI
local ui = UI.new(options)
ui:createUI()

-- Check for saved key
local savedKey = loadVerifiedKey()
if savedKey then
    print("[Moon Incremental] Checking saved key...")
    local result = Junkie.check_key(savedKey)
    if result and result.valid then
        print("[Moon Incremental] ✓ Saved key verified!")
        getgenv().SCRIPT_KEY = savedKey
        ui:close()
        -- Continue to main script below
    else
        print("[Moon Incremental] Saved key invalid, clearing...")
        clearSavedKey()
    end
end

-- Wait for verification if no saved key
if not getgenv().SCRIPT_KEY then
    print("[Moon Incremental] Waiting for key verification...")
    while not getgenv().UI_CLOSED do
        task.wait(0.1)
    end
end

-- Stop if key verification failed
if not getgenv().SCRIPT_KEY then
    warn("[Moon Incremental] ⚠ Key verification failed or was cancelled")
    return
end

print("[Moon Incremental] ✓ Key verified! Loading main script...")
task.wait(0.5)

-- ============================================================
-- MAIN SCRIPT - Only runs after successful key verification
-- ============================================================

-- Configuration
local Config = {
    UIVisible = true,
    Toggles = {
        Stars = {
            Enabled = false,
            Speed = 0.1,
            Intensity = 1,
            LastRun = 0
        },
        Essence = {
            Enabled = false,
            Speed = 0.1,
            Intensity = 1,
            LastRun = 0
        },
        Fragments = {
            Enabled = false,
            Speed = 0.1,
            Intensity = 1,
            LastRun = 0
        },
        SmeltScrap = {
            Enabled = false,
            Delay = 1,
            LastRun = 0
        },
        SmeltCollect = {
            Enabled = false,
            Delay = 1,
            LastRun = 0
        },
        Diamonds = {
            Enabled = false,
            Delay = 1,
            LastRun = 0
        }
    }
}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoonIncrementalGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 580)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Accent Line
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 0, 42)
AccentLine.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Moon Incremental"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Credit
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, -80, 0, 14)
Credit.Position = UDim2.new(0, 16, 0, 22)
Credit.BackgroundTransparency = 1
Credit.Text = "by NVHeadMonbo"
Credit.TextColor3 = Color3.fromRGB(120, 120, 130)
Credit.TextSize = 10
Credit.Font = Enum.Font.Gotham
Credit.TextXAlignment = Enum.TextXAlignment.Left
Credit.Parent = TopBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Position = UDim2.new(1, -36, 0, 7)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(32, 34, 42)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 210)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Content Container
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -24, 1, -56)
ContentFrame.Position = UDim2.new(0, 12, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentFrame

local function CreateToggleCard(name, config, hasIntensity)
    local Card = Instance.new("Frame")
    Card.Name = name .. "Card"
    Card.Size = UDim2.new(1, 0, 0, hasIntensity and 108 or 76)
    Card.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    Card.BorderSizePixel = 0
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 6)
    CardCorner.Parent = Card
    
    local ToggleName = Instance.new("TextLabel")
    ToggleName.Size = UDim2.new(1, -90, 0, 20)
    ToggleName.Position = UDim2.new(0, 12, 0, 10)
    ToggleName.BackgroundTransparency = 1
    ToggleName.Text = name
    ToggleName.TextColor3 = Color3.fromRGB(240, 240, 245)
    ToggleName.TextSize = 13
    ToggleName.Font = Enum.Font.GothamMedium
    ToggleName.TextXAlignment = Enum.TextXAlignment.Left
    ToggleName.Parent = Card
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 60, 0, 24)
    ToggleButton.Position = UDim2.new(1, -72, 0, 8)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(140, 140, 150)
    ToggleButton.TextSize = 11
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = Card
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 5)
    ToggleCorner.Parent = ToggleButton
    
    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0.5, -8, 0, 16)
    SpeedLabel.Position = UDim2.new(0, 12, 0, 38)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Text = (name == "Smelt Scrap Auto" or name == "Smelt Collect Auto" or name == "Diamonds Collect") and "Delay" or "Speed"
    SpeedLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    SpeedLabel.TextSize = 10
    SpeedLabel.Font = Enum.Font.Gotham
    SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpeedLabel.Parent = Card
    
    local SpeedValue = Instance.new("TextLabel")
    SpeedValue.Name = "SpeedValue"
    SpeedValue.Size = UDim2.new(0.5, -8, 0, 16)
    SpeedValue.Position = UDim2.new(0.5, 4, 0, 38)
    SpeedValue.BackgroundTransparency = 1
    SpeedValue.Text = (name == "Smelt Scrap Auto" or name == "Smelt Collect Auto" or name == "Diamonds Collect") and "1.0s" or "0.10s"
    SpeedValue.TextColor3 = Color3.fromRGB(88, 101, 242)
    SpeedValue.TextSize = 10
    SpeedValue.Font = Enum.Font.GothamBold
    SpeedValue.TextXAlignment = Enum.TextXAlignment.Right
    SpeedValue.Parent = Card
    
    local SpeedSlider = Instance.new("Frame")
    SpeedSlider.Name = "SpeedSlider"
    SpeedSlider.Size = UDim2.new(1, -24, 0, 4)
    SpeedSlider.Position = UDim2.new(0, 12, 0, 56)
    SpeedSlider.BackgroundColor3 = Color3.fromRGB(35, 37, 45)
    SpeedSlider.BorderSizePixel = 0
    SpeedSlider.Parent = Card
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SpeedSlider
    
    local SpeedFill = Instance.new("Frame")
    SpeedFill.Name = "Fill"
    SpeedFill.Size = UDim2.new(0.1, 0, 1, 0)
    SpeedFill.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    SpeedFill.BorderSizePixel = 0
    SpeedFill.Parent = SpeedSlider
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SpeedFill
    
    local SpeedButton = Instance.new("TextButton")
    SpeedButton.Name = "Button"
    SpeedButton.Size = UDim2.new(1, 0, 1, 12)
    SpeedButton.Position = UDim2.new(0, 0, 0, -6)
    SpeedButton.BackgroundTransparency = 1
    SpeedButton.Text = ""
    SpeedButton.Parent = SpeedSlider
    
    local IntensitySlider, IntensityFill, IntensityValue
    if hasIntensity then
        local IntensityLabel = Instance.new("TextLabel")
        IntensityLabel.Size = UDim2.new(0.5, -8, 0, 16)
        IntensityLabel.Position = UDim2.new(0, 12, 0, 70)
        IntensityLabel.BackgroundTransparency = 1
        IntensityLabel.Text = "Intensity"
        IntensityLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
        IntensityLabel.TextSize = 10
        IntensityLabel.Font = Enum.Font.Gotham
        IntensityLabel.TextXAlignment = Enum.TextXAlignment.Left
        IntensityLabel.Parent = Card
        
        IntensityValue = Instance.new("TextLabel")
        IntensityValue.Name = "IntensityValue"
        IntensityValue.Size = UDim2.new(0.5, -8, 0, 16)
        IntensityValue.Position = UDim2.new(0.5, 4, 0, 70)
        IntensityValue.BackgroundTransparency = 1
        IntensityValue.Text = "1x"
        IntensityValue.TextColor3 = Color3.fromRGB(255, 107, 107)
        IntensityValue.TextSize = 10
        IntensityValue.Font = Enum.Font.GothamBold
        IntensityValue.TextXAlignment = Enum.TextXAlignment.Right
        IntensityValue.Parent = Card
        
        IntensitySlider = Instance.new("Frame")
        IntensitySlider.Name = "IntensitySlider"
        IntensitySlider.Size = UDim2.new(1, -24, 0, 4)
        IntensitySlider.Position = UDim2.new(0, 12, 0, 88)
        IntensitySlider.BackgroundColor3 = Color3.fromRGB(35, 37, 45)
        IntensitySlider.BorderSizePixel = 0
        IntensitySlider.Parent = Card
        
        local IntSliderCorner = Instance.new("UICorner")
        IntSliderCorner.CornerRadius = UDim.new(1, 0)
        IntSliderCorner.Parent = IntensitySlider
        
        IntensityFill = Instance.new("Frame")
        IntensityFill.Name = "Fill"
        IntensityFill.Size = UDim2.new(0, 0, 1, 0)
        IntensityFill.BackgroundColor3 = Color3.fromRGB(255, 107, 107)
        IntensityFill.BorderSizePixel = 0
        IntensityFill.Parent = IntensitySlider
        
        local IntFillCorner = Instance.new("UICorner")
        IntFillCorner.CornerRadius = UDim.new(1, 0)
        IntFillCorner.Parent = IntensityFill
        
        local IntensityButton = Instance.new("TextButton")
        IntensityButton.Name = "Button"
        IntensityButton.Size = UDim2.new(1, 0, 1, 12)
        IntensityButton.Position = UDim2.new(0, 0, 0, -6)
        IntensityButton.BackgroundTransparency = 1
        IntensityButton.Text = ""
        IntensityButton.Parent = IntensitySlider
    end
    
    Card.Parent = ContentFrame
    
    return {
        Card = Card,
        ToggleButton = ToggleButton,
        SpeedSlider = SpeedSlider,
        SpeedFill = SpeedFill,
        SpeedButton = SpeedButton,
        SpeedValue = SpeedValue,
        IntensitySlider = IntensitySlider,
        IntensityFill = IntensityFill,
        IntensityValue = IntensityValue
    }
end

local StarsCard = CreateToggleCard("Stars", Config.Toggles.Stars, true)
local EssenceCard = CreateToggleCard("Essence", Config.Toggles.Essence, true)
local FragmentsCard = CreateToggleCard("Fragments", Config.Toggles.Fragments, true)
local SmeltCard = CreateToggleCard("Smelt Scrap Auto", Config.Toggles.SmeltScrap, false)
local SmeltCollectCard = CreateToggleCard("Smelt Collect Auto", Config.Toggles.SmeltCollect, false)
local DiamondsCard = CreateToggleCard("Diamonds Collect", Config.Toggles.Diamonds, false)

local function SetupSlider(sliderFrame, fillFrame, valueLabel, config, property, isDelay)
    local button = sliderFrame:FindFirstChild("Button")
    local dragging = false
    
    local function updateSlider(input)
        local sizeX = sliderFrame.AbsoluteSize.X
        local posX = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sizeX)
        local percent = posX / sizeX
        
        fillFrame.Size = UDim2.new(percent, 0, 1, 0)
        
        if isDelay then
            local value = 0.1 + (percent * 9.9)
            config[property] = math.floor(value * 10) / 10
            valueLabel.Text = string.format("%.1fs", config[property])
        else
            local value = 0.01 + (percent * 0.99)
            config[property] = math.floor(value * 100) / 100
            valueLabel.Text = string.format("%.2fs", config[property])
        end
    end
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

local function SetupIntensitySlider(sliderFrame, fillFrame, valueLabel, config)
    local button = sliderFrame:FindFirstChild("Button")
    local dragging = false
    
    local function updateSlider(input)
        local sizeX = sliderFrame.AbsoluteSize.X
        local posX = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sizeX)
        local percent = posX / sizeX
        
        fillFrame.Size = UDim2.new(percent, 0, 1, 0)
        
        local value = 1 + math.floor(percent * 9)
        config.Intensity = value
        valueLabel.Text = string.format("%dx", value)
    end
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

SetupSlider(StarsCard.SpeedSlider, StarsCard.SpeedFill, StarsCard.SpeedValue, Config.Toggles.Stars, "Speed", false)
SetupIntensitySlider(StarsCard.IntensitySlider, StarsCard.IntensityFill, StarsCard.IntensityValue, Config.Toggles.Stars)

SetupSlider(EssenceCard.SpeedSlider, EssenceCard.SpeedFill, EssenceCard.SpeedValue, Config.Toggles.Essence, "Speed", false)
SetupIntensitySlider(EssenceCard.IntensitySlider, EssenceCard.IntensityFill, EssenceCard.IntensityValue, Config.Toggles.Essence)

SetupSlider(FragmentsCard.SpeedSlider, FragmentsCard.SpeedFill, FragmentsCard.SpeedValue, Config.Toggles.Fragments, "Speed", false)
SetupIntensitySlider(FragmentsCard.IntensitySlider, FragmentsCard.IntensityFill, FragmentsCard.IntensityValue, Config.Toggles.Fragments)

SetupSlider(SmeltCard.SpeedSlider, SmeltCard.SpeedFill, SmeltCard.SpeedValue, Config.Toggles.SmeltScrap, "Delay", true)
SetupSlider(SmeltCollectCard.SpeedSlider, SmeltCollectCard.SpeedFill, SmeltCollectCard.SpeedValue, Config.Toggles.SmeltCollect, "Delay", true)
SetupSlider(DiamondsCard.SpeedSlider, DiamondsCard.SpeedFill, DiamondsCard.SpeedValue, Config.Toggles.Diamonds, "Delay", true)

local function SetupToggleButton(button, config)
    button.MouseButton1Click:Connect(function()
        config.Enabled = not config.Enabled
        
        if config.Enabled then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            }):Play()
            button.Text = "ON"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 42, 50)
            }):Play()
            button.Text = "OFF"
            button.TextColor3 = Color3.fromRGB(140, 140, 150)
        end
    end)
end

SetupToggleButton(StarsCard.ToggleButton, Config.Toggles.Stars)
SetupToggleButton(EssenceCard.ToggleButton, Config.Toggles.Essence)
SetupToggleButton(FragmentsCard.ToggleButton, Config.Toggles.Fragments)
SetupToggleButton(SmeltCard.ToggleButton, Config.Toggles.SmeltScrap)
SetupToggleButton(SmeltCollectCard.ToggleButton, Config.Toggles.SmeltCollect)
SetupToggleButton(DiamondsCard.ToggleButton, Config.Toggles.Diamonds)

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    local targetSize = minimized and UDim2.new(0, 380, 0, 42) or UDim2.new(0, 380, 0, 580)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = targetSize
    }):Play()
    
    MinimizeButton.Text = minimized and "+" or "−"
    ContentFrame.Visible = not minimized
    AccentLine.Visible = not minimized
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        Config.UIVisible = not Config.UIVisible
        ScreenGui.Enabled = Config.UIVisible
    end
end)

RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    
    if Config.Toggles.Stars.Enabled then
        if currentTime - Config.Toggles.Stars.LastRun >= Config.Toggles.Stars.Speed then
            Config.Toggles.Stars.LastRun = currentTime
            
            for i = 1, Config.Toggles.Stars.Intensity do
                task.spawn(function()
                    pcall(function()
                        local args = {
                            Vector3.new(-221.68064880371094, 5.273603916168213, -17.193782806396484)
                        }
                        ReplicatedStorage:WaitForChild("UpdateStarStat"):FireServer(unpack(args))
                    end)
                end)
            end
        end
    end
    
    if Config.Toggles.Essence.Enabled then
        if currentTime - Config.Toggles.Essence.LastRun >= Config.Toggles.Essence.Speed then
            Config.Toggles.Essence.LastRun = currentTime
            
            for i = 1, Config.Toggles.Essence.Intensity do
                task.spawn(function()
                    pcall(function()
                        local args = {
                            Vector3.new(-215, 6.036557674407959, -30),
                            false
                        }
                        ReplicatedStorage:WaitForChild("UpdateEssenceStat"):FireServer(unpack(args))
                    end)
                end)
            end
        end
    end
    
    if Config.Toggles.Fragments.Enabled then
        if currentTime - Config.Toggles.Fragments.LastRun >= Config.Toggles.Fragments.Speed then
            Config.Toggles.Fragments.LastRun = currentTime
            
            for i = 1, Config.Toggles.Fragments.Intensity do
                task.spawn(function()
                    pcall(function()
                        local args = {
                            workspace:WaitForChild("Cave"):WaitForChild("Ore_9217932433")
                        }
                        ReplicatedStorage:WaitForChild("MineRock"):FireServer(unpack(args))
                    end)
                end)
            end
        end
    end
    
    if Config.Toggles.SmeltScrap.Enabled then
        if currentTime - Config.Toggles.SmeltScrap.LastRun >= Config.Toggles.SmeltScrap.Delay then
            Config.Toggles.SmeltScrap.LastRun = currentTime
            
            task.spawn(function()
                pcall(function()
                    ReplicatedStorage:WaitForChild("SmeltDeposit"):FireServer()
                end)
            end)
        end
    end
    
    if Config.Toggles.SmeltCollect.Enabled then
        if currentTime - Config.Toggles.SmeltCollect.LastRun >= Config.Toggles.SmeltCollect.Delay then
            Config.Toggles.SmeltCollect.LastRun = currentTime
            
            task.spawn(function()
                pcall(function()
                    ReplicatedStorage:WaitForChild("SmeltCollect"):FireServer()
                end)
            end)
        end
    end
    
    if Config.Toggles.Diamonds.Enabled then
        if currentTime - Config.Toggles.Diamonds.LastRun >= Config.Toggles.Diamonds.Delay then
            Config.Toggles.Diamonds.LastRun = currentTime
            
            task.spawn(function()
                pcall(function()
                    ReplicatedStorage:WaitForChild("MineshaftCollect"):FireServer()
                end)
            end)
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Moon Incremental";
    Text = "Loaded successfully! Press K to toggle UI";
    Duration = 4;
})

print("[Moon Incremental] Script loaded successfully!")

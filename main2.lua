-- ==========================================
-- 01Scripts | Panel 2 (Pitido Agudo al 150% en Todos los Apartados + Anti-Spam)
-- ==========================================

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local GITHUB_KEYS_URL = "https://raw.githubusercontent.com/caracaswai-ai/auth-keys/main/keys2.json"
local CONFIG_FILE_NAME = "01Scripts_Config.json"

local function verifyKey(inputKey)
    local success, result = pcall(function()
        local response = game:HttpGet(GITHUB_KEYS_URL .. "?nocache=" .. tick())
        return HttpService:JSONDecode(response)
    end)
    
    if success and type(result) == "table" then
        if result[inputKey] then
            return true
        end
    end
    return false
end

-- ==========================================
-- VENTANA DE LOGIN
-- ==========================================
local LoginGui = Instance.new("ScreenGui")
LoginGui.Name = "01Scripts_Panel2_Login"
LoginGui.Parent = CoreGui
LoginGui.ResetOnSpawn = false

local LoginFrame = Instance.new("Frame")
LoginFrame.Size = UDim2.new(0, 380, 0, 220)
LoginFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
LoginFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
LoginFrame.BorderSizePixel = 0
LoginFrame.Parent = LoginGui

local LCorner = Instance.new("UICorner")
LCorner.CornerRadius = UDim.new(0, 8)
LCorner.Parent = LoginFrame

local LStroke = Instance.new("UIStroke")
LStroke.Color = Color3.fromRGB(72, 27, 117)
LStroke.Thickness = 1
LStroke.Parent = LoginFrame

local LTitle = Instance.new("TextLabel")
LTitle.Size = UDim2.new(1, -20, 0, 30)
LTitle.Position = UDim2.new(0, 15, 0, 15)
LTitle.BackgroundTransparency = 1
LTitle.Text = "Verificacion de 01Scripts"
LTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LTitle.TextSize = 15
LTitle.Font = Enum.Font.GothamBold
LTitle.TextXAlignment = Enum.TextXAlignment.Left
LTitle.Parent = LoginFrame

local LSub = Instance.new("TextLabel")
LSub.Size = UDim2.new(1, -20, 0, 20)
LSub.Position = UDim2.new(0, 15, 0, 45)
LSub.BackgroundTransparency = 1
LSub.Text = "Key System | 01Hub"
LSub.TextColor3 = Color3.fromRGB(120, 120, 135)
LSub.TextSize = 11
LSub.Font = Enum.Font.Gotham
LSub.TextXAlignment = Enum.TextXAlignment.Left
LSub.Parent = LoginFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -30, 0, 42)
KeyInput.Position = UDim2.new(0, 15, 0, 80)
KeyInput.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderText = "Ingresar Key"
KeyInput.Text = ""
KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 165)
KeyInput.TextSize = 12
KeyInput.Font = Enum.Font.Gotham
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = LoginFrame

local KICorner = Instance.new("UICorner")
KICorner.CornerRadius = UDim.new(0, 6)
KICorner.Parent = KeyInput

local VerifyButton = Instance.new("TextButton")
VerifyButton.Size = UDim2.new(1, -30, 0, 38)
VerifyButton.Position = UDim2.new(0, 15, 0, 135)
VerifyButton.BackgroundColor3 = Color3.fromRGB(162, 57, 239)
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.Text = "Verificar Key"
VerifyButton.TextSize = 13
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.Parent = LoginFrame

local VBCorner = Instance.new("UICorner")
VBCorner.CornerRadius = UDim.new(0, 6)
VBCorner.Parent = VerifyButton

local StatusMsg = Instance.new("TextLabel")
StatusMsg.Size = UDim2.new(1, -30, 0, 20)
StatusMsg.Position = UDim2.new(0, 15, 0, 182)
StatusMsg.BackgroundTransparency = 1
StatusMsg.Text = ""
StatusMsg.TextColor3 = Color3.fromRGB(255, 85, 85)
StatusMsg.TextSize = 11
StatusMsg.Font = Enum.Font.Gotham
StatusMsg.TextXAlignment = Enum.TextXAlignment.Center
StatusMsg.Parent = LoginFrame

local function OpenMainPanel()
    LoginGui:Destroy()

    -- Control de tiempo para evitar sonidos duplicados simultáneos (Anti-Spam)
    local lastBeepTick = 0
    local function PlayBeep()
        local currentTick = tick()
        if currentTick - lastBeepTick < 0.08 then return end -- Evita pitidos encimados en un rango de 80ms
        lastBeepTick = currentTick

        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://4590657391"
        sound.Volume = 1.5 -- 150% de volumen
        sound.Parent = CoreGui
        
        local pitch = Instance.new("PitchShiftSoundEffect")
        pitch.Octave = 2.8 -- Pitido más agudo
        pitch.Parent = sound
        
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "01Scripts_Panel2_Main"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local TopIndicatorFrame = Instance.new("Frame")
    TopIndicatorFrame.Name = "TopIndicatorFrame"
    TopIndicatorFrame.Size = UDim2.new(0, 90, 0, 26)
    TopIndicatorFrame.Position = UDim2.new(0.5, -45, 0, 10)
    TopIndicatorFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    TopIndicatorFrame.BorderSizePixel = 0
    TopIndicatorFrame.Visible = false
    TopIndicatorFrame.Parent = ScreenGui

    local TopIndCorner = Instance.new("UICorner")
    TopIndCorner.CornerRadius = UDim.new(0, 6)
    TopIndCorner.Parent = TopIndicatorFrame

    local TopIndStroke = Instance.new("UIStroke")
    TopIndStroke.Color = Color3.fromRGB(72, 27, 117)
    TopIndStroke.Thickness = 1
    TopIndStroke.Parent = TopIndicatorFrame

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 1, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = "👤"
    IconLabel.TextSize = 13
    IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    IconLabel.Parent = TopIndicatorFrame

    local CountLabel = Instance.new("TextLabel")
    CountLabel.Name = "CountLabel"
    CountLabel.Size = UDim2.new(1, -30, 1, 0)
    CountLabel.Position = UDim2.new(0, 30, 0, 0)
    CountLabel.BackgroundTransparency = 1
    CountLabel.Text = "0"
    CountLabel.Font = Enum.Font.GothamBold
    CountLabel.TextSize = 12
    CountLabel.TextColor3 = Color3.fromRGB(235, 130, 255)
    CountLabel.TextXAlignment = Enum.TextXAlignment.Left
    CountLabel.Parent = TopIndicatorFrame

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 720, 0, 460)
    MainFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MCorner = Instance.new("UICorner")
    MCorner.CornerRadius = UDim.new(0, 8)
    MCorner.Parent = MainFrame

    local MStroke = Instance.new("UIStroke")
    MStroke.Color = Color3.fromRGB(72, 27, 117)
    MStroke.Thickness = 1
    MStroke.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 55)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 300, 0, 20)
    TitleLabel.Position = UDim2.new(0, 18, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "01Scripts X 01Hub"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(0, 300, 0, 16)
    SubLabel.Position = UDim2.new(0, 18, 0, 32)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = "Key System | 01Hub"
    SubLabel.TextColor3 = Color3.fromRGB(110, 110, 125)
    SubLabel.TextSize = 11
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = TopBar

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, 0, 1, -55)
    ContentHolder.Position = UDim2.new(0, 0, 0, 55)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -75, 0.5, -15)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(180, 180, 195)
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TopBar

    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        ContentHolder.Visible = not isMinimized
        MainFrame.Size = isMinimized and UDim2.new(0, 720, 0, 55) or UDim2.new(0, 720, 0, 460)
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local SideBar = Instance.new("Frame")
    SideBar.Size = UDim2.new(0, 210, 1, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
    SideBar.BorderSizePixel = 0
    SideBar.Parent = ContentHolder

    -- CONTENEDORES DE PESTAÑAS
    local VisualContainer = Instance.new("ScrollingFrame")
    VisualContainer.Size = UDim2.new(1, -230, 1, -20)
    VisualContainer.Position = UDim2.new(0, 220, 0, 10)
    VisualContainer.BackgroundTransparency = 1
    VisualContainer.CanvasSize = UDim2.new(0, 0, 0, 350)
    VisualContainer.ScrollBarThickness = 3
    VisualContainer.Visible = true
    VisualContainer.Parent = ContentHolder

    local VisualList = Instance.new("UIListLayout")
    VisualList.Padding = UDim.new(0, 12)
    VisualList.Parent = VisualContainer

    local AimContainer = Instance.new("ScrollingFrame")
    AimContainer.Size = UDim2.new(1, -230, 1, -20)
    AimContainer.Position = UDim2.new(0, 220, 0, 10)
    AimContainer.BackgroundTransparency = 1
    AimContainer.CanvasSize = UDim2.new(0, 0, 0, 620)
    AimContainer.ScrollBarThickness = 3
    AimContainer.Visible = false
    AimContainer.Parent = ContentHolder

    local AimList = Instance.new("UIListLayout")
    AimList.Padding = UDim.new(0, 12)
    AimList.Parent = AimContainer

    local ExtraContainer = Instance.new("ScrollingFrame")
    ExtraContainer.Size = UDim2.new(1, -230, 1, -20)
    ExtraContainer.Position = UDim2.new(0, 220, 0, 10)
    ExtraContainer.BackgroundTransparency = 1
    ExtraContainer.CanvasSize = UDim2.new(0, 0, 0, 280)
    ExtraContainer.ScrollBarThickness = 3
    ExtraContainer.Visible = false
    ExtraContainer.Parent = ContentHolder

    local ExtraList = Instance.new("UIListLayout")
    ExtraList.Padding = UDim.new(0, 12)
    ExtraList.Parent = ExtraContainer

    local ConfigContainer = Instance.new("ScrollingFrame")
    ConfigContainer.Size = UDim2.new(1, -230, 1, -20)
    ConfigContainer.Position = UDim2.new(0, 220, 0, 10)
    ConfigContainer.BackgroundTransparency = 1
    ConfigContainer.CanvasSize = UDim2.new(0, 0, 0, 220)
    ConfigContainer.ScrollBarThickness = 3
    ConfigContainer.Visible = false
    ConfigContainer.Parent = ContentHolder

    local ConfigList = Instance.new("UIListLayout")
    ConfigList.Padding = UDim.new(0, 12)
    ConfigList.Parent = ConfigContainer

    local MainText = Instance.new("TextLabel")
    MainText.Size = UDim2.new(1, -20, 0, 20)
    MainText.Position = UDim2.new(0, 18, 0, 15)
    MainText.BackgroundTransparency = 1
    MainText.Text = "MENU"
    MainText.TextColor3 = Color3.fromRGB(100, 100, 115)
    MainText.TextSize = 11
    MainText.Font = Enum.Font.GothamBold
    MainText.TextXAlignment = Enum.TextXAlignment.Left
    MainText.Parent = SideBar

    local VisualTab = Instance.new("TextButton")
    VisualTab.Size = UDim2.new(1, -24, 0, 42)
    VisualTab.Position = UDim2.new(0, 12, 0, 42)
    VisualTab.BackgroundColor3 = Color3.fromRGB(38, 16, 56)
    VisualTab.TextColor3 = Color3.fromRGB(235, 130, 255)
    VisualTab.Text = "    Visual"
    VisualTab.TextSize = 13
    VisualTab.Font = Enum.Font.GothamBold
    VisualTab.TextXAlignment = Enum.TextXAlignment.Left
    VisualTab.Parent = SideBar

    local VTCorner = Instance.new("UICorner")
    VTCorner.CornerRadius = UDim.new(0, 8)
    VTCorner.Parent = VisualTab

    local AimTab = Instance.new("TextButton")
    AimTab.Size = UDim2.new(1, -24, 0, 42)
    AimTab.Position = UDim2.new(0, 12, 0, 92)
    AimTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    AimTab.TextColor3 = Color3.fromRGB(150, 150, 165)
    AimTab.Text = "    Aim"
    AimTab.TextSize = 13
    AimTab.Font = Enum.Font.GothamBold
    AimTab.TextXAlignment = Enum.TextXAlignment.Left
    AimTab.Parent = SideBar

    local ATCorner = Instance.new("UICorner")
    ATCorner.CornerRadius = UDim.new(0, 8)
    ATCorner.Parent = AimTab

    local ExtraTab = Instance.new("TextButton")
    ExtraTab.Size = UDim2.new(1, -24, 0, 42)
    ExtraTab.Position = UDim2.new(0, 12, 0, 142)
    ExtraTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    ExtraTab.TextColor3 = Color3.fromRGB(150, 150, 165)
    ExtraTab.Text = "    Extra"
    ExtraTab.TextSize = 13
    ExtraTab.Font = Enum.Font.GothamBold
    ExtraTab.TextXAlignment = Enum.TextXAlignment.Left
    ExtraTab.Parent = SideBar

    local ETCorner = Instance.new("UICorner")
    ETCorner.CornerRadius = UDim.new(0, 8)
    ETCorner.Parent = ExtraTab

    local ConfigTab = Instance.new("TextButton")
    ConfigTab.Size = UDim2.new(1, -24, 0, 42)
    ConfigTab.Position = UDim2.new(0, 12, 0, 192)
    ConfigTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    ConfigTab.TextColor3 = Color3.fromRGB(150, 150, 165)
    ConfigTab.Text = "    CONFIG"
    ConfigTab.TextSize = 13
    ConfigTab.Font = Enum.Font.GothamBold
    ConfigTab.TextXAlignment = Enum.TextXAlignment.Left
    ConfigTab.Parent = SideBar

    local CTCorner = Instance.new("UICorner")
    CTCorner.CornerRadius = UDim.new(0, 8)
    CTCorner.Parent = ConfigTab

    -- LOGICA DE CAMBIO DE PESTAÑAS
    VisualTab.MouseButton1Click:Connect(function()
        VisualContainer.Visible = true
        AimContainer.Visible = false
        ExtraContainer.Visible = false
        ConfigContainer.Visible = false
        VisualTab.BackgroundColor3 = Color3.fromRGB(38, 16, 56)
        VisualTab.TextColor3 = Color3.fromRGB(235, 130, 255)
        AimTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        AimTab.TextColor3 = Color3.fromRGB(150, 150, 165)
        ExtraTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        ExtraTab.TextColor3 = Color3.fromRGB(150, 150, 165)
        ConfigTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        ConfigTab.TextColor3 = Color3.fromRGB(150, 150, 165)
    end)

    AimTab.MouseButton1Click:Connect(function()
        VisualContainer.Visible = false
        AimContainer.Visible = true
        ExtraContainer.Visible = false
        ConfigContainer.Visible = false
        AimTab.BackgroundColor3 = Color3.fromRGB(38, 16, 56)
        AimTab.TextColor3 = Color3.fromRGB(235, 130, 255)
        VisualTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        VisualTab.TextColor3 = Color3.fromRGB(150, 150, 165)
        ExtraTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        ExtraTab.TextColor3 = Color3.fromRGB(150, 150, 165)
        ConfigTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        ConfigTab.TextColor3 = Color3.fromRGB(150, 150, 165)
    end)

    ExtraTab.MouseButton1Click:Connect(function()
        VisualContainer.Visible = false
        AimContainer.Visible = false
        ExtraContainer.Visible = true
        ConfigContainer.Visible = false
        ExtraTab.BackgroundColor3 = Color3.fromRGB(38, 16, 56)
        ExtraTab.TextColor3 = Color3.fromRGB(235, 130, 255)
        VisualTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        VisualTab.TextColor3 = Color3.fromRGB(150, 150, 165)
        AimTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        AimTab.TextColor3 = Color3.fromRGB(150, 150, 165)
        ConfigTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        ConfigTab.TextColor3 = Color3.fromRGB(150, 150, 165)
    end)

    ConfigTab.MouseButton1Click:Connect(function()
        VisualContainer.Visible = false
        AimContainer.Visible = false
        ExtraContainer.Visible = false
        ConfigContainer.Visible = true
        ConfigTab.BackgroundColor3 = Color3.fromRGB(38, 16, 56)
        ConfigTab.TextColor3 = Color3.fromRGB(235, 130, 255)
        VisualTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        VisualTab.TextColor3 = Color3.fromRGB(150, 150, 165)
        AimTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        AimTab.TextColor3 = Color3.fromRGB(150, 150, 165)
        ExtraTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        ExtraTab.TextColor3 = Color3.fromRGB(150, 150, 165)
    end)

    -- VARIABLES Y ESTADOS GLOBALES DE LAS FUNCIONES
    local ESP_Enabled = false
    local Lines_Enabled = false
    local Health_Enabled = false
    local Highlight_Enabled = false
    local espMaxDistance = 5000

    local Aimbot_Enabled = false
    local aimbotSmoothness = 100
    local FOV_Enabled = false
    local fovSize = 150
    local fovTransparency = 100
    local maxDistance = 500
    local wallCheck_Enabled = false

    local Fly_Enabled = false
    local flySpeed = 50
    local Noclip_Enabled = false
    local Speed_Enabled = false
    local moveSpeed = 50

    -- ESTRUCTURA CENTRALIZADA DE TOGGLES Y KEYBINDS (Pitido habilitado para todos)
    local togglesData = {
        ESP = {
            Enabled = false, 
            Key = Enum.KeyCode.E, 
            SetState = function(v) ESP_Enabled = v end
        },
        Lines = {
            Enabled = false, 
            Key = Enum.KeyCode.L, 
            SetState = function(v) 
                Lines_Enabled = v 
                if not v then TopIndicatorFrame.Visible = false end 
            end
        },
        Health = {
            Enabled = false, 
            Key = Enum.KeyCode.H, 
            SetState = function(v) Health_Enabled = v end
        },
        Highlight = {
            Enabled = false, 
            Key = Enum.KeyCode.J, 
            SetState = function(v) Highlight_Enabled = v end
        },
        
        Aimbot = {
            Enabled = false, 
            Key = Enum.KeyCode.Q, 
            SetState = function(v) Aimbot_Enabled = v end
        },
        FOV = {
            Enabled = false, 
            Key = Enum.KeyCode.F, 
            SetState = function(v) FOV_Enabled = v end
        },
        Paredes = {
            Enabled = false, 
            Key = Enum.KeyCode.X, 
            SetState = function(v) wallCheck_Enabled = v end
        },

        Fly = {
            Enabled = false, 
            Key = Enum.KeyCode.R, 
            SetState = function(v) Fly_Enabled = v end
        },
        Noclip = {
            Enabled = false, 
            Key = Enum.KeyCode.N, 
            SetState = function(v) Noclip_Enabled = v end
        },
        Speed = {
            Enabled = false, 
            Key = Enum.KeyCode.Z, 
            SetState = function(v) Speed_Enabled = v end
        },
    }

    local function UpdateToggleVisual(id, state)
        local data = togglesData[id]
        if not data then return end
        data.Enabled = state
        if data.SwitchBg and data.Knob then
            if state then
                data.SwitchBg.BackgroundColor3 = Color3.fromRGB(162, 57, 239)
                data.Knob:TweenPosition(UDim2.new(1, -21, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            else
                data.SwitchBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                data.Knob:TweenPosition(UDim2.new(0, 3, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            end
        end
        pcall(function() data.SetState(state) end)

        -- Reproduce un único pitido general para cualquier función activada
        PlayBeep()
    end

    local function CreateToggle(parentContainer, id, name)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parentContainer

        local TFCorner = Instance.new("UICorner")
        TFCorner.CornerRadius = UDim.new(0, 8)
        TFCorner.Parent = ToggleFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 160, 1, 0)
        Label.Position = UDim2.new(0, 18, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(220, 220, 230)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        -- Botón de Tecla (Keybind)
        local KeybindBtn = Instance.new("TextButton")
        KeybindBtn.Size = UDim2.new(0, 55, 0, 24)
        KeybindBtn.Position = UDim2.new(1, -125, 0.5, -12)
        KeybindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        KeybindBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
        KeybindBtn.TextSize = 11
        KeybindBtn.Font = Enum.Font.GothamBold
        KeybindBtn.Parent = ToggleFrame

        local KBCorner = Instance.new("UICorner")
        KBCorner.CornerRadius = UDim.new(0, 6)
        KBCorner.Parent = KeybindBtn

        local data = togglesData[id]
        if data then
            KeybindBtn.Text = data.Key.Name
            data.KeyButton = KeybindBtn
        end

        local listening = false
        KeybindBtn.MouseButton1Click:Connect(function()
            listening = true
            KeybindBtn.Text = "..."
            KeybindBtn.TextColor3 = Color3.fromRGB(235, 130, 255)
        end)

        UserInputService.InputBegan:Connect(function(input, gp)
            if listening then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    data.Key = input.KeyCode
                    KeybindBtn.Text = input.KeyCode.Name
                    KeybindBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
                    listening = false
                end
            elseif not gp and data and input.KeyCode == data.Key then
                UpdateToggleVisual(id, not data.Enabled)
            end
        end)

        -- Interruptor visual
        local SwitchBg = Instance.new("TextButton")
        SwitchBg.Size = UDim2.new(0, 46, 0, 24)
        SwitchBg.Position = UDim2.new(1, -62, 0.5, -12)
        SwitchBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        SwitchBg.Text = ""
        SwitchBg.Parent = ToggleFrame

        local SBCorner = Instance.new("UICorner")
        SBCorner.CornerRadius = UDim.new(1, 0)
        SBCorner.Parent = SwitchBg

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 18, 0, 18)
        Knob.Position = UDim2.new(0, 3, 0.5, -9)
        Knob.BackgroundColor3 = Color3.fromRGB(240, 240, 250)
        Knob.Parent = SwitchBg

        local KCorner = Instance.new("UICorner")
        KCorner.CornerRadius = UDim.new(1, 0)
        KCorner.Parent = Knob

        if data then
            data.SwitchBg = SwitchBg
            data.Knob = Knob
        end

        SwitchBg.MouseButton1Click:Connect(function()
            if data then
                UpdateToggleVisual(id, not data.Enabled)
            end
        end)
    end

    local function CreateSlider(parentContainer, name, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 65)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = parentContainer

        local SFCorn = Instance.new("UICorner")
        SFCorn.CornerRadius = UDim.new(0, 8)
        SFCorn.Parent = SliderFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -30, 0, 25)
        Label.Position = UDim2.new(0, 18, 0, 8)
        Label.BackgroundTransparency = 1
        local suffix = (name:find("Suavidad") or name:find("Transparencia")) and "%" or ""
        Label.Text = name .. ": " .. tostring(default) .. suffix
        Label.TextColor3 = Color3.fromRGB(220, 220, 230)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame

        local BarBg = Instance.new("Frame")
        BarBg.Size = UDim2.new(1, -36, 0, 6)
        BarBg.Position = UDim2.new(0, 18, 0, 42)
        BarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        BarBg.BorderSizePixel = 0
        BarBg.Parent = SliderFrame

        local BBCorn = Instance.new("UICorner")
        BBCorn.CornerRadius = UDim.new(1, 0)
        BBCorn.Parent = BarBg

        local FillBar = Instance.new("Frame")
        FillBar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        FillBar.BackgroundColor3 = Color3.fromRGB(162, 57, 239)
        FillBar.BorderSizePixel = 0
        FillBar.Parent = BarBg

        local FBCorn = Instance.new("UICorner")
        FBCorn.CornerRadius = UDim.new(1, 0)
        FBCorn.Parent = FillBar

        local DragButton = Instance.new("TextButton")
        DragButton.Size = UDim2.new(1, 0, 1, 10)
        DragButton.Position = UDim2.new(0, 0, 0, -5)
        DragButton.BackgroundTransparency = 1
        DragButton.Text = ""
        DragButton.Parent = BarBg

        local dragging = false

        DragButton.MouseButton1Down:Connect(function()
            dragging = true
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local mousePos = UserInputService:GetMouseLocation()
                local barPos = BarBg.AbsolutePosition
                local barSize = BarBg.AbsoluteSize
                local percent = math.clamp((mousePos.X - barPos.X) / barSize.X, 0, 1)
                
                FillBar.Size = UDim2.new(percent, 0, 1, 0)
                local val = math.floor(min + (max - min) * percent)
                Label.Text = name .. ": " .. tostring(val) .. suffix
                pcall(function() callback(val) end)
            end
        end)
    end

    local function CreateButton(parentContainer, name, callback)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 50)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Parent = parentContainer

        local BFCorn = Instance.new("UICorner")
        BFCorn.CornerRadius = UDim.new(0, 8)
        BFCorn.Parent = ButtonFrame

        local ActionButton = Instance.new("TextButton")
        ActionButton.Size = UDim2.new(1, -36, 0, 36)
        ActionButton.Position = UDim2.new(0, 18, 0.5, -18)
        ActionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        ActionButton.TextColor3 = Color3.fromRGB(220, 220, 230)
        ActionButton.Text = name
        ActionButton.TextSize = 13
        ActionButton.Font = Enum.Font.GothamBold
        ActionButton.Parent = ButtonFrame

        local ABCorn = Instance.new("UICorner")
        ABCorn.CornerRadius = UDim.new(0, 6)
        ABCorn.Parent = ActionButton

        ActionButton.MouseButton1Click:Connect(function()
            pcall(function() callback() end)
            ActionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
            task.wait(0.15)
            ActionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        end)
    end

    CreateToggle(VisualContainer, "ESP", "ESP")
    CreateToggle(VisualContainer, "Lines", "Lines")
    CreateToggle(VisualContainer, "Health", "Health")
    CreateToggle(VisualContainer, "Highlight", "Highlight")
    CreateSlider(VisualContainer, "Distancia Máxima ESP", 100, 10000, 5000, function(val) espMaxDistance = val end)

    CreateToggle(AimContainer, "Aimbot", "Aimbot")
    CreateSlider(AimContainer, "Suavidad", 10, 100, 100, function(val) aimbotSmoothness = val end)
    CreateToggle(AimContainer, "FOV", "FOV")
    CreateSlider(AimContainer, "Tamaño FOV", 50, 500, 150, function(val) fovSize = val end)
    CreateSlider(AimContainer, "Transparencia FOV", 0, 100, 100, function(val) fovTransparency = val end)
    CreateSlider(AimContainer, "Distancia Máxima", 50, 1000, 500, function(val) maxDistance = val end)
    CreateToggle(AimContainer, "Paredes", "Paredes")

    CreateToggle(ExtraContainer, "Fly", "Fly")
    CreateSlider(ExtraContainer, "Fly Speed", 10, 300, 50, function(val) flySpeed = val end)
    CreateToggle(ExtraContainer, "Noclip", "Noclip")
    CreateToggle(ExtraContainer, "Speed", "Speed")
    CreateSlider(ExtraContainer, "Walk Speed", 16, 200, 50, function(val) moveSpeed = val end)

    -- PERSISTENCIA DE CONFIGURACIÓN Y KEYBINDS CON ARCHIVOS
    CreateButton(ConfigContainer, "Save Config", function()
        local configData = {
            Toggles = {},
            EspMaxDist = espMaxDistance,
            Smoothness = aimbotSmoothness,
            FovSize = fovSize,
            FovTrans = fovTransparency,
            MaxDist = maxDistance,
            FlySpd = flySpeed,
            MoveSpd = moveSpeed
        }
        
        for id, data in pairs(togglesData) do
            configData.Toggles[id] = {
                Enabled = data.Enabled,
                Key = data.Key.Name
            }
        end
        
        if writefile then
            pcall(function()
                writefile(CONFIG_FILE_NAME, HttpService:JSONEncode(configData))
            end)
        end
    end)

    CreateButton(ConfigContainer, "Load Config", function()
        if readfile and pcall(function() readfile(CONFIG_FILE_NAME) end) then
            pcall(function()
                local content = readfile(CONFIG_FILE_NAME)
                local decoded = HttpService:JSONDecode(content)
                if decoded then
                    if decoded.Toggles then
                        for id, info in pairs(decoded.Toggles) do
                            if togglesData[id] then
                                UpdateToggleVisual(id, info.Enabled)
                                if info.Key and Enum.KeyCode[info.Key] then
                                    togglesData[id].Key = Enum.KeyCode[info.Key]
                                    if togglesData[id].KeyButton then
                                        togglesData[id].KeyButton.Text = info.Key
                                    end
                                end
                            end
                        end
                    end
                    espMaxDistance = decoded.EspMaxDist or 5000
                    aimbotSmoothness = decoded.Smoothness or 100
                    fovSize = decoded.FovSize or 150
                    fovTransparency = decoded.FovTrans or 100
                    maxDistance = decoded.MaxDist or 500
                    flySpeed = decoded.FlySpd or 50
                    moveSpeed = decoded.MoveSpd or 50
                end
            end)
        end
    end)

    CreateButton(ConfigContainer, "Reset All", function()
        for id, data in pairs(togglesData) do
            UpdateToggleVisual(id, false)
        end
        espMaxDistance = 5000
        aimbotSmoothness = 100
        fovSize = 150
        fovTransparency = 100
        maxDistance = 500
        flySpeed = 50
        moveSpeed = 50
        
        if delfile and pcall(function() readfile(CONFIG_FILE_NAME) end) then
            pcall(function() delfile(CONFIG_FILE_NAME) end)
        end
    end)

    local fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 60
    fovCircle.Filled = false
    fovCircle.Color = Color3.fromRGB(162, 57, 239)
    fovCircle.Visible = false

    -- CONTENEDOR DE OBJETOS VISUALES / ESP (DX Drawing / Highlights)
    local espDrawings = {}

    local function clearESP()
        for _, obj in pairs(espDrawings) do
            if obj.Box then obj.Box:Remove() end
            if obj.Line then obj.Line:Remove() end
            if obj.HealthBar then obj.HealthBar:Remove() end
            if obj.HealthBg then obj.HealthBg:Remove() end
            if obj.Highlight then obj.Highlight:Destroy() end
        end
        espDrawings = {}
    end

    local aimRayParams = RaycastParams.new()
    aimRayParams.FilterType = Enum.RaycastFilterType.Exclude
    aimRayParams.IgnoreWater = true

    local function isVisible(targetPart, originChar)
        if not originChar then return true end
        aimRayParams.FilterDescendantsInstances = {originChar, Camera}
        local originPos = Camera.CFrame.Position
        local direction = targetPart.Position - originPos
        local result = workspace:Raycast(originPos, direction, aimRayParams)
        
        if result then
            local hitInstance = result.Instance
            if hitInstance:IsDescendantOf(targetPart.Parent) then
                return true
            end
            return false
        end
        return true
    end

    local flyBodyGyro, flyBodyVelocity
    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        if Noclip_Enabled and char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if Speed_Enabled and humanoid then
            humanoid.WalkSpeed = moveSpeed
        end

        if Fly_Enabled and hrp then
            if not flyBodyGyro then
                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.P = 9e4
                flyBodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
                flyBodyGyro.Parent = hrp
            end
            if not flyBodyVelocity then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                flyBodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
                flyBodyVelocity.Parent = hrp
            end

            flyBodyGyro.CFrame = Camera.CFrame
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            
            flyBodyVelocity.Velocity = moveDir * flySpeed
            if humanoid then humanoid.PlatformStand = true end
        else
            if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
            if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
            if humanoid and humanoid.PlatformStand then humanoid.PlatformStand = false end
        end

        local mouseLocation = UserInputService:GetMouseLocation()
        if FOV_Enabled then
            fovCircle.Visible = true
            fovCircle.Radius = fovSize
            fovCircle.Position = mouseLocation
            fovCircle.Transparency = fovTransparency / 100
        else
            fovCircle.Visible = false
        end

        -- LOGICA DE RENDERIZADO ESP / LINES / HEALTH / HIGHLIGHT (CON CAMBIO DE COLOR DINÁMICO)
        if ESP_Enabled or Lines_Enabled or Health_Enabled or Highlight_Enabled then
            local activePlayers = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetChar = player.Character
                    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                    local targetHead = targetChar:FindFirstChild("Head") or targetHrp
                    local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")

                    if targetHrp and targetHumanoid and targetHumanoid.Health > 0 then
                        local dist = (targetHrp.Position - Camera.CFrame.Position).Magnitude
                        if dist <= espMaxDistance then
                            activePlayers[player] = true

                            if not espDrawings[player] then
                                espDrawings[player] = {}
                            end

                            local visible = isVisible(targetHead, char)
                            local dynamicColor = visible and Color3.fromRGB(162, 57, 239) or Color3.fromRGB(85, 255, 127)

                            -- 1. HIGHLIGHT
                            if Highlight_Enabled then
                                if not espDrawings[player].Highlight then
                                    local hl = Instance.new("Highlight")
                                    hl.Adornee = targetChar
                                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    hl.FillTransparency = 0.5
                                    hl.Parent = CoreGui
                                    espDrawings[player].Highlight = hl
                                end
                                espDrawings[player].Highlight.FillColor = dynamicColor
                            else
                                if espDrawings[player].Highlight then
                                    espDrawings[player].Highlight:Destroy()
                                    espDrawings[player].Highlight = nil
                                end
                            end

                            -- 2. ESP BOX (CUADRO)
                            if ESP_Enabled then
                                if not espDrawings[player].Box then
                                    local box = Drawing.new("Square")
                                    box.Thickness = 1.5
                                    box.Filled = false
                                    espDrawings[player].Box = box
                                end
                                
                                espDrawings[player].Box.Color = dynamicColor
                                local pos, onScreen = Camera:WorldToViewportPoint(targetHrp.Position)
                                if onScreen then
                                    local size = Vector2.new(2000 / dist, 4000 / dist)
                                    espDrawings[player].Box.Size = size
                                    espDrawings[player].Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                                    espDrawings[player].Box.Visible = true
                                else
                                    espDrawings[player].Box.Visible = false
                                end
                            else
                                if espDrawings[player].Box then
                                    espDrawings[player].Box:Remove()
                                    espDrawings[player].Box = nil
                                end
                            end

                            -- 3. LINES (LÍNEAS A JUGADORES)
                            if Lines_Enabled then
                                if not espDrawings[player].Line then
                                    local line = Drawing.new("Line")
                                    line.Thickness = 1
                                    espDrawings[player].Line = line
                                end

                                espDrawings[player].Line.Color = dynamicColor
                                local pos, onScreen = Camera:WorldToViewportPoint(targetHrp.Position)
                                if onScreen then
                                    espDrawings[player].Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                    espDrawings[player].Line.To = Vector2.new(pos.X, pos.Y)
                                    espDrawings[player].Line.Visible = true
                                    TopIndicatorFrame.Visible = true
                                else
                                    espDrawings[player].Line.Visible = false
                                end
                            else
                                if espDrawings[player].Line then
                                    espDrawings[player].Line:Remove()
                                    espDrawings[player].Line = nil
                                end
                            end

                            -- 4. HEALTH BAR
                            if Health_Enabled then
                                if not espDrawings[player].HealthBar then
                                    local hbBg = Drawing.new("Square")
                                    hbBg.Filled = true
                                    hbBg.Color = Color3.fromRGB(0, 0, 0)
                                    hbBg.Thickness = 1
                                    
                                    local hb = Drawing.new("Square")
                                    hb.Filled = true
                                    hb.Color = Color3.fromRGB(85, 255, 127)
                                    
                                    espDrawings[player].HealthBg = hbBg
                                    espDrawings[player].HealthBar = hb
                                end

                                local pos, onScreen = Camera:WorldToViewportPoint(targetHrp.Position)
                                if onScreen then
                                    local size = Vector2.new(2000 / dist, 4000 / dist)
                                    local healthPercent = math.clamp(targetHumanoid.Health / targetHumanoid.MaxHealth, 0, 1)
                                    
                                    espDrawings[player].HealthBg.Size = Vector2.new(3, size.Y)
                                    espDrawings[player].HealthBg.Position = Vector2.new(pos.X - size.X / 2 - 6, pos.Y - size.Y / 2)
                                    espDrawings[player].HealthBg.Visible = true

                                    espDrawings[player].HealthBar.Size = Vector2.new(1, size.Y * healthPercent)
                                    espDrawings[player].HealthBar.Position = Vector2.new(pos.X - size.X / 2 - 5, pos.Y - size.Y / 2 + (size.Y * (1 - healthPercent)))
                                    espDrawings[player].HealthBar.Visible = true
                                else
                                    espDrawings[player].HealthBg.Visible = false
                                    espDrawings[player].HealthBar.Visible = false
                                end
                            else
                                if espDrawings[player].HealthBar then
                                    espDrawings[player].HealthBar:Remove()
                                    espDrawings[player].HealthBar = nil
                                end
                                if espDrawings[player].HealthBg then
                                    espDrawings[player].HealthBg:Remove()
                                    espDrawings[player].HealthBg = nil
                                end
                            end

                        end
                    end
                end
            end

            for p, obj in pairs(espDrawings) do
                if not activePlayers[p] then
                    if obj.Box then obj.Box:Remove() end
                    if obj.Line then obj.Line:Remove() end
                    if obj.HealthBar then obj.HealthBar:Remove() end
                    if obj.HealthBg then obj.HealthBg:Remove() end
                    if obj.Highlight then obj.Highlight:Destroy() end
                    espDrawings[p] = nil
                end
            end
        else
            clearESP()
        end

        local rightMouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if Aimbot_Enabled and rightMouseDown then
            local closestTarget = nil
            local shortestDistance = fovSize

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetChar = player.Character
                    local targetHead = targetChar:FindFirstChild("Head")
                    local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")

                    if targetHead and targetHumanoid and targetHumanoid.Health > 0 then
                        local screenPoint, onScreen = Camera:WorldToViewportPoint(targetHead.Position)
                        if onScreen then
                            local magnitude = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLocation).Magnitude
                            if magnitude < shortestDistance then
                                local dist3D = (targetHead.Position - Camera.CFrame.Position).Magnitude
                                if dist3D <= maxDistance then
                                    if not wallCheck_Enabled or isVisible(targetHead, char) then
                                        shortestDistance = magnitude
                                        closestTarget = targetHead
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if closestTarget then
                local targetPos = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
                local smoothnessVal = math.clamp(aimbotSmoothness, 10, 100)
                Camera.CFrame = Camera.CFrame:Lerp(targetPos, smoothnessVal / 100)
            end
        end
    end)
end

-- ==========================================
-- CONEXIÓN DE BOTÓN DE VERIFICACIÓN
-- ==========================================
VerifyButton.MouseButton1Click:Connect(function()
    local enteredKey = KeyInput.Text
    if enteredKey == "" then
        StatusMsg.Text = "Por favor ingresa una Key."
        return
    end

    StatusMsg.TextColor3 = Color3.fromRGB(255, 200, 85)
    StatusMsg.Text = "Verificando..."

    task.spawn(function()
        local isValid = verifyKey(enteredKey)
        if isValid then
            StatusMsg.TextColor3 = Color3.fromRGB(85, 255, 127)
            StatusMsg.Text = "¡Key correcta! Abriendo panel..."
            task.wait(0.6)
            OpenMainPanel()
        else
            StatusMsg.TextColor3 = Color3.fromRGB(255, 85, 85)
            StatusMsg.Text = "Key inválida o expirada."
        end
    end)
end)

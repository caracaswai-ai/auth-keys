-- ==========================================
-- 01Scripts | Panel 2 (Validación Estricta y Funciones 100% Operativas)
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
        local keyData = result[inputKey]
        if keyData then
            if keyData.expiresAt and keyData.expiresAt > 0 and os.time() > keyData.expiresAt then
                return false, "La Key ha expirado."
            end

            if keyData.usedBy and keyData.usedBy ~= "" then
                local allowedUser = keyData.usedBy:lower()
                local currentName = LocalPlayer.Name:lower()
                local currentDisplayName = LocalPlayer.DisplayName:lower()
                
                if currentName ~= allowedUser and currentDisplayName ~= allowedUser then
                    return false, "Esta Key pertenece a otro usuario."
                end
            end

            return true, "¡Key Válida!"
        end
    end
    return false, "Key inválida o no encontrada."
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
LSub.Text = LocalPlayer.DisplayName .. " | 01Hub"
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

    local lastBeepTick = 0
    local function PlayBeep()
        local currentTick = tick()
        if currentTick - lastBeepTick < 0.08 then return end
        lastBeepTick = currentTick

        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://4590657391"
        sound.Volume = 2.1 -- Volumen aumentado en un 40% (1.5 * 1.4 = 2.1)
        sound.Parent = CoreGui
        
        local pitch = Instance.new("PitchShiftSoundEffect")
        pitch.Octave = 2.8
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
    TitleLabel.Size = UDim2.new(0, 400, 0, 20)
    TitleLabel.Position = UDim2.new(0, 18, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "01Scripts Hub"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(0, 400, 0, 16)
    SubLabel.Position = UDim2.new(0, 18, 0, 30)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = LocalPlayer.DisplayName .. " │ Hub"
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
    CloseButton.Text = "X"
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
    AimContainer.CanvasSize = UDim2.new(0, 0, 0, 650)
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

    -- Variables de Funcionalidad
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
    local aimbotActivationMode = "Clic Derecho"

    local Fly_Enabled = false
    local flySpeed = 50
    local Noclip_Enabled = false
    local Speed_Enabled = false
    local moveSpeed = 50

    local ESPGuiContainer = Instance.new("Folder")
    ESPGuiContainer.Name = "01Scripts_ESPGuiContainer"
    ESPGuiContainer.Parent = ScreenGui

    local FOVFrame = Instance.new("Frame")
    FOVFrame.Name = "FOVCircle"
    FOVFrame.Size = UDim2.new(0, fovSize * 2, 0, fovSize * 2)
    FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVFrame.BackgroundTransparency = 1
    FOVFrame.Visible = false
    FOVFrame.Parent = ScreenGui

    local FOVStroke = Instance.new("UIStroke")
    FOVStroke.Color = Color3.fromRGB(162, 57, 239)
    FOVStroke.Thickness = 1
    FOVStroke.Parent = FOVFrame

    local FOVCorner = Instance.new("UICorner")
    FOVCorner.CornerRadius = UDim.new(1, 0)
    FOVCorner.Parent = FOVFrame

    -- Lógica de Aimbot y FOV
    RunService.RenderStepped:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        
        if FOV_Enabled then
            FOVFrame.Visible = true
            FOVFrame.Size = UDim2.new(0, fovSize * 2, 0, fovSize * 2)
            FOVFrame.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
            FOVFrame.BackgroundTransparency = 1
        else
            FOVFrame.Visible = false
        end

        if Aimbot_Enabled then
            local isClickHeld = false
            if aimbotActivationMode == "Clic Derecho" then
                isClickHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            else
                isClickHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
            end

            if isClickHeld then
                local closestTarget = nil
                local shortestDist = fovSize

                local char = LocalPlayer.Character
                local rootPart = char and char:FindFirstChild("HumanoidRootPart")

                if rootPart then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local pChar = player.Character
                            local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                            local pHum = pChar:FindFirstChildOfClass("Humanoid")
                            local head = pChar:FindFirstChild("Head")

                            if pRoot and head and pHum and pHum.Health > 0 then
                                local dist = (pRoot.Position - rootPart.Position).Magnitude
                                if dist <= maxDistance then
                                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                                    if onScreen then
                                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                        if screenDist <= shortestDist then
                                            shortestDist = screenDist
                                            closestTarget = head
                                        end
                                    end
                                end
                            end
                        end
                    end

                    if closestTarget then
                        local targetPos = closestTarget.Position
                        local currentCamCFrame = Camera.CFrame
                        local smoothFactor = math.clamp(aimbotSmoothness / 10, 1, 50)
                        Camera.CFrame = currentCamCFrame:Lerp(CFrame.new(currentCamCFrame.Position, targetPos), 1 / smoothFactor)
                    end
                end
            end
        end
    end)

    -- Lógica de ESP, Highlights y Tracers
    local playerVisuals = {}

    local function ClearPlayerVisuals(player)
        if playerVisuals[player] then
            if playerVisuals[player].BoxFrame then playerVisuals[player].BoxFrame:Destroy() end
            if playerVisuals[player].HealthBarBack then playerVisuals[player].HealthBarBack:Destroy() end
            if playerVisuals[player].TracerLine then playerVisuals[player].TracerLine:Destroy() end
            playerVisuals[player] = nil
        end
        if player.Character and player.Character:FindFirstChild("01Scripts_Highlight") then
            player.Character["01Scripts_Highlight"]:Destroy()
        end
    end

    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local pChar = player.Character
                local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
                local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")

                if pChar and pRoot and pHum and pHum.Health > 0 and rootPart then
                    local dist = (pRoot.Position - rootPart.Position).Magnitude

                    if dist <= espMaxDistance then
                        if not playerVisuals[player] then
                            local box = Instance.new("Frame")
                            box.BackgroundTransparency = 1
                            box.Visible = false
                            box.Parent = ESPGuiContainer

                            local boxStroke = Instance.new("UIStroke")
                            boxStroke.Color = Color3.fromRGB(162, 57, 239)
                            boxStroke.Thickness = 1
                            boxStroke.Parent = box

                            local healthBack = Instance.new("Frame")
                            healthBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            healthBack.BorderSizePixel = 0
                            healthBack.Visible = false
                            healthBack.Parent = ESPGuiContainer

                            local healthFill = Instance.new("Frame")
                            healthFill.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
                            healthFill.BorderSizePixel = 0
                            healthFill.Size = UDim2.new(1, 0, 1, 0)
                            healthFill.Parent = healthBack

                            local tracer = Instance.new("Frame")
                            tracer.BackgroundColor3 = Color3.fromRGB(235, 130, 255)
                            tracer.BorderSizePixel = 0
                            tracer.Visible = false
                            tracer.Parent = ESPGuiContainer

                            playerVisuals[player] = {
                                BoxFrame = box,
                                HealthBarBack = healthBack,
                                HealthFill = healthFill,
                                TracerLine = tracer
                            }
                        end

                        local visuals = playerVisuals[player]
                        local screenPos, onScreen = Camera:WorldToViewportPoint(pRoot.Position)

                        if onScreen then
                            local highlight = pChar:FindFirstChild("01Scripts_Highlight")
                            if Highlight_Enabled then
                                if not highlight then
                                    highlight = Instance.new("Highlight")
                                    highlight.Name = "01Scripts_Highlight"
                                    highlight.Adornee = pChar
                                    highlight.FillColor = Color3.fromRGB(162, 57, 239)
                                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    highlight.Parent = pChar
                                end
                            else
                                if highlight then highlight:Destroy() end
                            end

                            if ESP_Enabled then
                                local sizeY = math.clamp(2500 / dist, 20, 800)
                                local sizeX = sizeY * 0.6
                                visuals.BoxFrame.Size = UDim2.new(0, sizeX, 0, sizeY)
                                visuals.BoxFrame.Position = UDim2.new(0, screenPos.X - sizeX / 2, 0, screenPos.Y - sizeY / 2)
                                visuals.BoxFrame.Visible = true
                            else
                                visuals.BoxFrame.Visible = false
                            end

                            if Health_Enabled then
                                local sizeY = math.clamp(2500 / dist, 20, 800)
                                local sizeX = (sizeY * 0.6)
                                visuals.HealthBarBack.Size = UDim2.new(0, 3, 0, sizeY)
                                visuals.HealthBarBack.Position = UDim2.new(0, screenPos.X - sizeX / 2 - 6, 0, screenPos.Y - sizeY / 2)
                                
                                local healthPercent = math.clamp(pHum.Health / pHum.MaxHealth, 0, 1)
                                visuals.HealthFill.Size = UDim2.new(1, 0, healthPercent, 0)
                                visuals.HealthFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
                                visuals.HealthBarBack.Visible = true
                            else
                                visuals.HealthBarBack.Visible = false
                            end

                            if Lines_Enabled then
                                TopIndicatorFrame.Visible = true
                                local viewportSize = Camera.ViewportSize
                                local origin = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                                local target = Vector2.new(screenPos.X, screenPos.Y)
                                local distance = (target - origin).Magnitude
                                
                                visuals.TracerLine.Size = UDim2.new(0, distance, 0, 1)
                                visuals.TracerLine.Position = UDim2.new(0, origin.X, 0, origin.Y)
                                visuals.TracerLine.Rotation = math.deg(math.atan2(target.Y - origin.Y, target.X - origin.X))
                                visuals.TracerLine.Visible = true
                            else
                                visuals.TracerLine.Visible = false
                            end
                        else
                            visuals.BoxFrame.Visible = false
                            visuals.HealthBarBack.Visible = false
                            visuals.TracerLine.Visible = false
                        end
                    else
                        ClearPlayerVisuals(player)
                    end
                else
                    ClearPlayerVisuals(player)
                end
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        ClearPlayerVisuals(player)
    end)

    -- Fly, Noclip y Speed
    local flyConnection
    local function ToggleFly(state)
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        if state and rootPart and humanoid then
            humanoid.PlatformStand = true
            local bg = Instance.new("BodyGyro")
            bg.Name = "01Scripts_FlyGyro"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.CFrame = rootPart.CFrame
            bg.Parent = rootPart

            local bv = Instance.new("BodyVelocity")
            bv.Name = "01Scripts_FlyVel"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = rootPart

            flyConnection = RunService.RenderStepped:Connect(function()
                if not Fly_Enabled or not rootPart.Parent then return end
                local camCF = Camera.CFrame
                local moveDir = Vector3.new(0, 0, 0)

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end

                bv.Velocity = moveDir * flySpeed
                bg.CFrame = camCF
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            if rootPart then
                if rootPart:FindFirstChild("01Scripts_FlyGyro") then rootPart.FlyGyro:Destroy() end
                if rootPart:FindFirstChild("01Scripts_FlyVel") then rootPart.FlyVel:Destroy() end
            end
            if humanoid then humanoid.PlatformStand = false end
        end
    end

    RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        if Noclip_Enabled then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if Speed_Enabled then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = moveSpeed
            end
        end
    end)

    local togglesData = {
        ESP = { Enabled = false, Key = Enum.KeyCode.E, SetState = function(v) ESP_Enabled = v end },
        Lines = { Enabled = false, Key = Enum.KeyCode.L, SetState = function(v) Lines_Enabled = v if not v then TopIndicatorFrame.Visible = false end end },
        Health = { Enabled = false, Key = Enum.KeyCode.H, SetState = function(v) Health_Enabled = v end },
        Highlight = { Enabled = false, Key = Enum.KeyCode.J, SetState = function(v) Highlight_Enabled = v end },
        Aimbot = { Enabled = false, Key = Enum.KeyCode.Q, SetState = function(v) Aimbot_Enabled = v end },
        FOV = { Enabled = false, Key = Enum.KeyCode.F, SetState = function(v) FOV_Enabled = v end },
        Paredes = { Enabled = false, Key = Enum.KeyCode.X, SetState = function(v) wallCheck_Enabled = v end },
        Fly = { Enabled = false, Key = Enum.KeyCode.R, SetState = function(v) Fly_Enabled = v ToggleFly(v) end },
        Noclip = { Enabled = false, Key = Enum.KeyCode.N, SetState = function(v) Noclip_Enabled = v end },
        Speed = { Enabled = false, Key = Enum.KeyCode.Z, SetState = function(v) Speed_Enabled = v end },
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

    local function CreateToggleWithDropdown(parentContainer, id, name, dropdownOptions, defaultOption, onDropdownChanged)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parentContainer

        local TFCorner = Instance.new("UICorner")
        TFCorner.CornerRadius = UDim.new(0, 8)
        TFCorner.Parent = ToggleFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 130, 1, 0)
        Label.Position = UDim2.new(0, 18, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(220, 220, 230)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        local currentDropdownIndex = 1
        for i, opt in ipairs(dropdownOptions) do
            if opt == defaultOption then
                currentDropdownIndex = i
                break
            end
        end

        local DropdownBtn = Instance.new("TextButton")
        DropdownBtn.Size = UDim2.new(0, 95, 0, 24)
        DropdownBtn.Position = UDim2.new(1, -225, 0.5, -12)
        DropdownBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        DropdownBtn.TextColor3 = Color3.fromRGB(235, 130, 255)
        DropdownBtn.Text = dropdownOptions[currentDropdownIndex]
        DropdownBtn.TextSize = 10
        DropdownBtn.Font = Enum.Font.GothamBold
        DropdownBtn.Parent = ToggleFrame

        local DBCorner = Instance.new("UICorner")
        DBCorner.CornerRadius = UDim.new(0, 6)
        DBCorner.Parent = DropdownBtn

        DropdownBtn.MouseButton1Click:Connect(function()
            currentDropdownIndex = currentDropdownIndex + 1
            if currentDropdownIndex > #dropdownOptions then
                currentDropdownIndex = 1
            end
            local selected = dropdownOptions[currentDropdownIndex]
            DropdownBtn.Text = selected
            if onDropdownChanged then
                pcall(function() onDropdownChanged(selected) end)
            end
            PlayBeep()
        end)

        local KeybindBtn = Instance.new("TextButton")
        KeybindBtn.Size = UDim2.new(0, 50, 0, 24)
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
        DragButton.MouseButton1Down:Connect(function() dragging = true end)
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

    CreateToggleWithDropdown(AimContainer, "Aimbot", "Aimbot", {"Clic Derecho", "Clic Izquierdo"}, "Clic Derecho", function(selectedOption)
        aimbotActivationMode = selectedOption
    end)
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
end

-- ==========================================
-- CONEXIÓN DEL BOTÓN DE LOGIN
-- ==========================================
VerifyButton.MouseButton1Click:Connect(function()
    local enteredKey = KeyInput.Text
    if enteredKey == "" then
        StatusMsg.Text = "Por favor, ingresa una Key."
        return
    end

    VerifyButton.Text = "Verificando..."
    local isValid, message = verifyKey(enteredKey)
    
    if isValid then
        StatusMsg.TextColor3 = Color3.fromRGB(85, 255, 127)
        StatusMsg.Text = message
        task.wait(0.5)
        OpenMainPanel()
    else
        VerifyButton.Text = "Verificar Key"
        StatusMsg.TextColor3 = Color3.fromRGB(255, 85, 85)
        StatusMsg.Text = message
    end
end)

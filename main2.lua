-- ==========================================
-- 01Scripts | Panel 2 (Apartado AIM, FOV Slider interactivo + Silent Aim)
-- ==========================================

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local GITHUB_KEYS_URL = "https://raw.githubusercontent.com/caracaswai-ai/auth-keys/main/keys2.json"

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

-- ==========================================
-- PANEL PRINCIPAL CON APARTADOS VISUAL Y AIM
-- ==========================================
local function OpenMainPanel()
    LoginGui:Destroy()

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "01Scripts_Panel2_Main"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    -- Círculo FOV visual en pantalla
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = true
    fovCircle.Thickness = 1.5
    fovCircle.Color = Color3.fromRGB(235, 130, 255)
    fovCircle.Filled = false
    fovCircle.Radius = 150 -- Tamaño inicial predeterminado

    -- Mini pantalla superior (Muñeco + Contador de jugadores con líneas)
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
        fovCircle:Remove()
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

    -- Contenedores de pestañas (Visual y Aim)
    local VisualContainer = Instance.new("ScrollingFrame")
    VisualContainer.Size = UDim2.new(1, -230, 1, -20)
    VisualContainer.Position = UDim2.new(0, 220, 0, 10)
    VisualContainer.BackgroundTransparency = 1
    VisualContainer.CanvasSize = UDim2.new(0, 0, 0, 160)
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
    AimContainer.CanvasSize = UDim2.new(0, 0, 0, 160)
    AimContainer.ScrollBarThickness = 3
    AimContainer.Visible = false
    AimContainer.Parent = ContentHolder

    local AimList = Instance.new("UIListLayout")
    AimList.Padding = UDim.new(0, 12)
    AimList.Parent = AimContainer

    -- Botones del Menú Lateral
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

    -- Cambio entre pestañas del menú lateral
    VisualTab.MouseButton1Click:Connect(function()
        VisualContainer.Visible = true
        AimContainer.Visible = false
        VisualTab.BackgroundColor3 = Color3.fromRGB(38, 16, 56)
        VisualTab.TextColor3 = Color3.fromRGB(235, 130, 255)
        AimTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        AimTab.TextColor3 = Color3.fromRGB(150, 150, 165)
    end)

    AimTab.MouseButton1Click:Connect(function()
        VisualContainer.Visible = false
        AimContainer.Visible = true
        AimTab.BackgroundColor3 = Color3.fromRGB(38, 16, 56)
        AimTab.TextColor3 = Color3.fromRGB(235, 130, 255)
        VisualTab.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        VisualTab.TextColor3 = Color3.fromRGB(150, 150, 165)
    end)

    local ESP_Enabled = false
    local Lines_Enabled = false
    local Health_Enabled = false
    local SilentAim_Enabled = false
    local fovSize = 150

    local function CreateToggle(parentContainer, name, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parentContainer

        local TFCorner = Instance.new("UICorner")
        TFCorner.CornerRadius = UDim.new(0, 8)
        TFCorner.Parent = ToggleFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 200, 1, 0)
        Label.Position = UDim2.new(0, 18, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(220, 220, 230)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

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

        local enabled = false
        SwitchBg.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                SwitchBg.BackgroundColor3 = Color3.fromRGB(162, 57, 239)
                Knob:TweenPosition(UDim2.new(1, -21, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            else
                SwitchBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                Knob:TweenPosition(UDim2.new(0, 3, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            end
            pcall(function() callback(enabled) end)
        end)
    end

    -- Creación del Slider Interactivo para el FOV
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
        Label.Text = name .. ": " .. tostring(default)
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
                Label.Text = name .. ": " .. tostring(val)
                pcall(function() callback(val) end)
            end
        end)
    end

    -- Toggles de Visual
    CreateToggle(VisualContainer, "ESP", function(state) ESP_Enabled = state end)
    CreateToggle(VisualContainer, "Lines", function(state) 
        Lines_Enabled = state 
        if not state then TopIndicatorFrame.Visible = false end
    end)
    CreateToggle(VisualContainer, "Health", function(state) Health_Enabled = state end)

    -- Toggles y Sliders de Aim
    CreateToggle(AimContainer, "Silent Aim", function(state) SilentAim_Enabled = state end)
    CreateSlider(AimContainer, "FOV Size", 50, 500, 150, function(val)
        fovSize = val
    end)

    -- ==========================================
    -- LÓGICA DEL SILENT AIM & FOV CIRCLE
    -- ==========================================
    local function GetClosestTargetHeadWithinFOV()
        local closestHead = nil
        local shortestDist = fovSize
        local localChar = LocalPlayer.Character
        local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")

        if not localHrp then return nil end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local head = char:FindFirstChild("Head")
                local hrp = char:FindFirstChild("HumanoidRootPart")

                if humanoid and humanoid.Health > 0 and head and hrp then
                    local dist3D = (hrp.Position - localHrp.Position).Magnitude
                    if dist3D <= 500 then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local mousePos = UserInputService:GetMouseLocation()
                            local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if dist2D <= shortestDist then
                                shortestDist = dist2D
                                closestHead = head
                            end
                        end
                    end
                end
            end
        end
        return closestHead
    end

    -- Hook al metamétodo __namecall para redireccionar disparos al objetivo dentro del FOV
    local rawmetatable = getrawmetatable or debug.getrawmetatable
    local setreadonly = setreadonly or make_writeable
    if rawmetatable and setreadonly then
        local gmt = rawmetatable(game)
        local oldNamecall = gmt.__namecall
        setreadonly(gmt, false)

        gmt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if SilentAim_Enabled and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast" or method == "ScreenPointToRay" or method == "ViewportPointToRay") then
                local targetHead = GetClosestTargetHeadWithinFOV()
                if targetHead then
                    if method == "ViewportPointToRay" or method == "ScreenPointToRay" then
                        return Ray.new(Camera.CFrame.Position, (targetHead.Position - Camera.CFrame.Position).Unit)
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(gmt, true)
    end

    -- ==========================================
    -- RENDERIZADO ESP Y ACTUALIZACIÓN DE CÍRCULO FOV
    -- ==========================================
    local espCache = {}
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local BOX_THICKNESS = 1.5   
    local LINE_THICKNESS = 1.6  
    local HEALTH_WIDTH = 2.5    

    local function removeEsp(player)
        if espCache[player] then
            if espCache[player].box then espCache[player].box:Remove() end
            if espCache[player].line then espCache[player].line:Remove() end
            if espCache[player].healthBar then espCache[player].healthBar:Remove() end
            if espCache[player].healthBg then espCache[player].healthBg:Remove() end
            espCache[player] = nil
        end
    end

    RunService.RenderStepped:Connect(function()
        -- Actualizar posición y tamaño del círculo FOV en pantalla
        if SilentAim_Enabled then
            fovCircle.Visible = true
            fovCircle.Radius = fovSize
            fovCircle.Position = UserInputService:GetMouseLocation()
        else
            fovCircle.Visible = false
        end

        local localChar = LocalPlayer.Character
        local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")

        if localChar then
            raycastParams.FilterDescendantsInstances = {localChar}
        end

        local playersWithLinesCount = 0

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local head = char:FindFirstChild("Head")

                if hrp and humanoid and head and localHrp then
                    local distance = (hrp.Position - localHrp.Position).Magnitude

                    if distance <= 500 then
                        if not espCache[player] then
                            espCache[player] = {}
                            
                            local box = Drawing.new("Square")
                            box.Visible = false
                            box.Thickness = BOX_THICKNESS
                            box.Filled = false
                            espCache[player].box = box

                            local line = Drawing.new("Line")
                            line.Visible = false
                            line.Thickness = LINE_THICKNESS
                            espCache[player].line = line

                            local healthBg = Drawing.new("Square")
                            healthBg.Visible = false
                            healthBg.Color = Color3.fromRGB(0, 0, 0)
                            healthBg.Filled = true
                            espCache[player].healthBg = healthBg

                            local healthBar = Drawing.new("Square")
                            healthBar.Visible = false
                            healthBar.Filled = true
                            espCache[player].healthBar = healthBar
                        end

                        local cache = espCache[player]
                        local isAlive = humanoid.Health > 0

                        -- Comprobación de pared (Raycast)
                        local isBehindWall = false
                        if head and Camera and isAlive then
                            local origin = Camera.CFrame.Position
                            local direction = (head.Position - origin)
                            local rayResult = workspace:Raycast(origin, direction, raycastParams)
                            
                            if rayResult then
                                local hitInstance = rayResult.Instance
                                if not hitInstance:IsDescendantOf(char) then
                                    isBehindWall = true
                                end
                            end
                        end

                        local dynamicColor = isBehindWall and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

                        local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local legPos, legOnScreen = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                        if headOnScreen or legOnScreen then
                            local baseHeight = math.abs(headPos.Y - legPos.Y)
                            local height = baseHeight * 0.773
                            local width = height / 2
                            local x = headPos.X - width / 2
                            local y = headPos.Y + (baseHeight * 0.325)

                            -- ESP Box
                            if ESP_Enabled and isAlive then
                                cache.box.Visible = true
                                cache.box.Size = Vector2.new(width, height)
                                cache.box.Position = Vector2.new(x, y)
                                cache.box.Color = dynamicColor
                                cache.box.Thickness = BOX_THICKNESS
                            else
                                cache.box.Visible = false
                            end

                            -- Lines / Tracers
                            if Lines_Enabled and isAlive then
                                cache.line.Visible = true
                                cache.line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                                cache.line.To = Vector2.new(headPos.X, y + height)
                                cache.line.Color = dynamicColor
                                cache.line.Thickness = LINE_THICKNESS
                                playersWithLinesCount = playersWithLinesCount + 1
                            else
                                cache.line.Visible = false
                            end

                            -- Health Bar
                            if Health_Enabled and isAlive then
                                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                                local hbHeight = height * healthPercent

                                cache.healthBg.Visible = true
                                cache.healthBg.Size = Vector2.new(HEALTH_WIDTH + 2, height + 2)
                                cache.healthBg.Position = Vector2.new(x - (HEALTH_WIDTH + 4.5), y - 1)

                                cache.healthBar.Visible = true
                                cache.healthBar.Size = Vector2.new(HEALTH_WIDTH, hbHeight)
                                cache.healthBar.Position = Vector2.new(x - (HEALTH_WIDTH + 3.5), y + (height - hbHeight))
                                cache.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                            else
                                cache.healthBg.Visible = false
                                cache.healthBar.Visible = false
                            end
                        else
                            cache.box.Visible = false
                            cache.line.Visible = false
                            cache.healthBg.Visible = false
                            cache.healthBar.Visible = false
                        end
                    else
                        removeEsp(player)
                    end
                else
                    removeEsp(player)
                end
            else
                removeEsp(player)
            end
        end

        if Lines_Enabled then
            TopIndicatorFrame.Visible = true
            CountLabel.Text = tostring(playersWithLinesCount)
        else
            TopIndicatorFrame.Visible = false
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        removeEsp(player)
    end)
end

VerifyButton.MouseButton1Click:Connect(function()
    local userKey = KeyInput.Text:gsub("%s+", "")
    if userKey == "" then
        StatusMsg.Text = "⚠️ Escribe una key válida."
        return
    end

    StatusMsg.TextColor3 = Color3.fromRGB(255, 200, 0)
    StatusMsg.Text = "Verificando clave..."

    task.spawn(function()
        local isValid = verifyKey(userKey)
        if isValid then
            StatusMsg.TextColor3 = Color3.fromRGB(0, 255, 150)
            StatusMsg.Text = "¡Acceso concedido!"
            task.wait(0.4)
            OpenMainPanel()
        else
            StatusMsg.TextColor3 = Color3.fromRGB(255, 85, 85)
            StatusMsg.Text = "❌ Key incorrecta o no pertenece al Panel 2."
        end
    end)
end)

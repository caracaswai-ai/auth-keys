-- ==========================================
-- 01Scripts | Panel 2 (UI Perfecta, Tecla K y Funciones)
-- ==========================================

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

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
-- PANEL PRINCIPAL CON BOTONES Y TECLA K
-- ==========================================
local function OpenMainPanel()
    LoginGui:Destroy()

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "01Scripts_Panel2_Main"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

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

    -- Barra superior
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

    -- Contenedor del contenido interno
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, 0, 1, -55)
    ContentHolder.Position = UDim2.new(0, 0, 0, 55)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame

    -- Botón Cerrar (X) - Bien ubicado a la derecha
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

    -- Botón Minimizar (-) al lado izquierdo de la X
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

    -- Tecla Rápida K para ocultar/mostrar todo el panel
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- Barra lateral izquierda
    local SideBar = Instance.new("Frame")
    SideBar.Size = UDim2.new(0, 210, 1, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
    SideBar.BorderSizePixel = 0
    SideBar.Parent = ContentHolder

    local MainText = Instance.new("TextLabel")
    MainText.Size = UDim2.new(1, -20, 0, 20)
    MainText.Position = UDim2.new(0, 18, 0, 15)
    MainText.BackgroundTransparency = 1
    MainText.Text = "MAIN"
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

    -- Contenedor de opciones (Derecha)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -230, 1, -20)
    Container.Position = UDim2.new(0, 220, 0, 10)
    Container.BackgroundTransparency = 1
    Container.Parent = ContentHolder

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 12)
    UIList.Parent = Container

    -- Variables de Estado
    local ESP_Enabled = false
    local Lines_Enabled = false
    local Health_Enabled = false

    -- Función creadora de Toggles
    local function CreateToggle(name, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = Container

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

    -- ==========================================
    -- SISTEMA DE ESP / LINES / HEALTH
    -- ==========================================
    local espCache = {}

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
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                local char = player.Character
                local hrp = char.HumanoidRootPart
                local humanoid = char.Humanoid

                if not espCache[player] then
                    espCache[player] = {}
                    
                    local box = Drawing.new("Square")
                    box.Visible = false
                    box.Color = Color3.fromRGB(162, 57, 239)
                    box.Thickness = 1.5
                    box.Filled = false
                    espCache[player].box = box

                    local line = Drawing.new("Line")
                    line.Visible = false
                    line.Color = Color3.fromRGB(235, 130, 255)
                    line.Thickness = 1
                    espCache[player].line = line

                    local healthBg = Drawing.new("Square")
                    healthBg.Visible = false
                    healthBg.Color = Color3.fromRGB(0, 0, 0)
                    healthBg.Filled = true
                    espCache[player].healthBg = healthBg

                    local healthBar = Drawing.new("Square")
                    healthBar.Visible = false
                    healthBar.Color = Color3.fromRGB(0, 255, 100)
                    healthBar.Filled = true
                    espCache[player].healthBar = healthBar
                end

                local cache = espCache[player]
                local camera = workspace.CurrentCamera
                local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

                if onScreen and humanoid.Health > 0 then
                    local scaleFactor = 1 / (vector.Z * math.tan(math.rad(camera.FieldOfView / 2)) * 2) * 1000
                    local w = math.clamp(25 * scaleFactor, 15, 300)
                    local h = math.clamp(35 * scaleFactor, 20, 500)
                    local x = vector.X - w / 2
                    local y = vector.Y - h / 2

                    if ESP_Enabled then
                        cache.box.Visible = true
                        cache.box.Size = Vector2.new(w, h)
                        cache.box.Position = Vector2.new(x, y)
                    else
                        cache.box.Visible = false
                    end

                    if Lines_Enabled then
                        cache.line.Visible = true
                        cache.line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        cache.line.To = Vector2.new(vector.X, vector.Y + h / 2)
                    else
                        cache.line.Visible = false
                    end

                    if Health_Enabled then
                        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        local hbHeight = h * healthPercent

                        cache.healthBg.Visible = true
                        cache.healthBg.Size = Vector2.new(4, h + 2)
                        cache.healthBg.Position = Vector2.new(x - 7, y - 1)

                        cache.healthBar.Visible = true
                        cache.healthBar.Size = Vector2.new(2, hbHeight)
                        cache.healthBar.Position = Vector2.new(x - 6, y + (h - hbHeight))
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
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        removeEsp(player)
    end)

    CreateToggle("ESP", function(state)
        ESP_Enabled = state
    end)

    CreateToggle("Lines", function(state)
        Lines_Enabled = state
    end)

    CreateToggle("Health", function(state)
        Health_Enabled = state
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

-- ==========================================
-- 0. CONFIGURACIÓN Y SERVICIOS
-- ==========================================
local GITHUB_URL = "https://raw.githubusercontent.com/caracaswai-ai/auth-keys/refs/heads/main/keys.json?nocache=" .. tick()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local AnalyticsService = game:GetService("RbxAnalyticsService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local success, clientId = pcall(function()
    return AnalyticsService:GetClientId()
end)
local deviceID = (success and clientId) or tostring(LocalPlayer.UserId)

-- ==========================================
-- 1. SCREEN GUI INDEPENDIENTE PARA EL CONTADOR (FIJO, NO SE QUITA CON LA TECLA K)
-- ==========================================
local counterGui = Instance.new("ScreenGui")
counterGui.Name = "01Counter_Independent"
counterGui.ResetOnSpawn = false
counterGui.DisplayOrder = 999998
counterGui.IgnoreGuiInset = true
counterGui.Enabled = true

local protectedCounter = pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(counterGui)
        counterGui.Parent = CoreGui
    elseif protectgui then
        protectgui(counterGui)
        counterGui.Parent = CoreGui
    else
        counterGui.Parent = PlayerGui
    end
end)
if not protectedCounter then
    counterGui.Parent = PlayerGui
end

-- Widget superior indicador (Se muestra únicamente cuando "Lines" está activo)
local topIndicatorFrame = Instance.new("Frame")
topIndicatorFrame.Name = "TopIndicatorFrame"
topIndicatorFrame.Size = UDim2.new(0, 90, 0, 26)
topIndicatorFrame.Position = UDim2.new(0.5, -45, 0, 10)
topIndicatorFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
topIndicatorFrame.BorderSizePixel = 0
topIndicatorFrame.Visible = false -- Oculto por defecto hasta activar Lines
topIndicatorFrame.Parent = counterGui

local topIndCorner = Instance.new("UICorner")
topIndCorner.CornerRadius = UDim.new(0, 6)
topIndCorner.Parent = topIndicatorFrame

local topIndStroke = Instance.new("UIStroke")
topIndStroke.Color = Color3.fromRGB(50, 50, 65)
topIndStroke.Thickness = 1
topIndStroke.Parent = topIndicatorFrame

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(0, 30, 1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "👤"
iconLabel.TextSize = 13
iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
iconLabel.Parent = topIndicatorFrame

local countLabel = Instance.new("TextLabel")
countLabel.Name = "CountLabel"
countLabel.Size = UDim2.new(1, -30, 1, 0)
countLabel.Position = UDim2.new(0, 30, 0, 0)
countLabel.BackgroundTransparency = 1
countLabel.Text = "0"
countLabel.Font = Enum.Font.GothamBold
countLabel.TextSize = 12
countLabel.TextColor3 = Color3.fromRGB(255, 100, 200)
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Parent = topIndicatorFrame

-- ==========================================
-- 2. SCREEN GUI PRINCIPAL (MENÚ Y KEY SYSTEM)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "01Panel_X_Jpanel"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.IgnoreGuiInset = true
screenGui.Enabled = true

local protected = pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = CoreGui
    elseif protectgui then
        protectgui(screenGui)
        screenGui.Parent = CoreGui
    else
        screenGui.Parent = PlayerGui
    end
end)
if not protected then
    screenGui.Parent = PlayerGui
end

-- Ventana de Autenticación (Key System)
local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyFrame"
keyFrame.Size = UDim2.new(0, 380, 0, 200)
keyFrame.Position = UDim2.new(0.5, -190, 0.5, -100)
keyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
keyFrame.BorderSizePixel = 0
keyFrame.Visible = true
keyFrame.Active = true
keyFrame.Draggable = true
keyFrame.Parent = screenGui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyFrame

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(45, 45, 55)
keyStroke.Thickness = 1
keyStroke.Parent = keyFrame

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, -20, 0, 40)
keyTitle.Position = UDim2.new(0, 20, 0, 10)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "01Panel X Jpanel"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 16
keyTitle.TextXAlignment = Enum.TextXAlignment.Left
keyTitle.Parent = keyFrame

local keySubtitle = Instance.new("TextLabel")
keySubtitle.Size = UDim2.new(1, -40, 0, 20)
keySubtitle.Position = UDim2.new(0, 20, 0, 35)
keySubtitle.BackgroundTransparency = 1
keySubtitle.Text = "Autenticación requerida para continuar"
keySubtitle.TextColor3 = Color3.fromRGB(140, 140, 160)
keySubtitle.Font = Enum.Font.Gotham
keySubtitle.TextSize = 12
keySubtitle.TextXAlignment = Enum.TextXAlignment.Left
keySubtitle.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Name = "KeyBox"
keyBox.Size = UDim2.new(1, -40, 0, 42)
keyBox.Position = UDim2.new(0, 20, 0, 75)
keyBox.PlaceholderText = "Ingresar key"
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
keyBox.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
keyBox.BorderSizePixel = 0
keyBox.ClearTextOnFocus = false
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.Parent = keyFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = keyBox

local boxStroke = Instance.new("UIStroke")
boxStroke.Color = Color3.fromRGB(50, 50, 65)
boxStroke.Thickness = 1
boxStroke.Parent = keyBox

local verifyButton = Instance.new("TextButton")
verifyButton.Name = "VerifyButton"
verifyButton.Size = UDim2.new(1, -40, 0, 42)
verifyButton.Position = UDim2.new(0, 20, 0, 135)
verifyButton.Text = "VERIFICAR"
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.BackgroundColor3 = Color3.fromRGB(190, 20, 120)
verifyButton.BorderSizePixel = 0
verifyButton.Font = Enum.Font.GothamBold
verifyButton.TextSize = 13
verifyButton.Parent = keyFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = verifyButton

-- ==========================================
-- 3. PANEL PRINCIPAL
-- ==========================================
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 580, 0, 380)
mainPanel.Position = UDim2.new(0.5, -290, 0.5, -190)
mainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainPanel

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 50)
mainStroke.Thickness = 1
mainStroke.Parent = mainPanel

-- Barra superior
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
topBar.BorderSizePixel = 0
topBar.Parent = mainPanel

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 8)
topBarCorner.Parent = topBar

local fixTopBar = Instance.new("Frame")
fixTopBar.Size = UDim2.new(1, 0, 0, 10)
fixTopBar.Position = UDim2.new(0, 0, 1, -10)
fixTopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
fixTopBar.BorderSizePixel = 0
fixTopBar.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "01Panel X Jpanel"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.Parent = topBar

local subTitleLabel = Instance.new("TextLabel")
subTitleLabel.Size = UDim2.new(0, 200, 0, 15)
subTitleLabel.Position = UDim2.new(0, 15, 0, 25)
subTitleLabel.BackgroundTransparency = 1
subTitleLabel.Text = "Key System | 01Hub"
subTitleLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subTitleLabel.Font = Enum.Font.Gotham
subTitleLabel.TextSize = 11
subTitleLabel.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 7.5)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 15
closeButton.Parent = topBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0, 7.5)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.Parent = topBar

-- Menú lateral
local sideMenu = Instance.new("Frame")
sideMenu.Size = UDim2.new(0, 180, 1, -45)
sideMenu.Position = UDim2.new(0, 0, 0, 45)
sideMenu.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
sideMenu.BorderSizePixel = 0
sideMenu.Parent = mainPanel

local mainCategoryLabel = Instance.new("TextLabel")
mainCategoryLabel.Size = UDim2.new(1, -20, 0, 25)
mainCategoryLabel.Position = UDim2.new(0, 15, 0, 10)
mainCategoryLabel.BackgroundTransparency = 1
mainCategoryLabel.Text = "MAIN"
mainCategoryLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
mainCategoryLabel.Font = Enum.Font.GothamBold
mainCategoryLabel.TextSize = 11
mainCategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
mainCategoryLabel.Parent = sideMenu

local visualCatBtn = Instance.new("TextButton")
visualCatBtn.Size = UDim2.new(1, -16, 0, 36)
visualCatBtn.Position = UDim2.new(0, 8, 0, 40)
visualCatBtn.BackgroundColor3 = Color3.fromRGB(26, 20, 32)
visualCatBtn.BorderSizePixel = 0
visualCatBtn.Text = "    Visual"
visualCatBtn.TextColor3 = Color3.fromRGB(255, 100, 200)
visualCatBtn.Font = Enum.Font.GothamMedium
visualCatBtn.TextSize = 13
visualCatBtn.TextXAlignment = Enum.TextXAlignment.Left
visualCatBtn.Parent = sideMenu

local catCorner = Instance.new("UICorner")
catCorner.CornerRadius = UDim.new(0, 6)
catCorner.Parent = visualCatBtn

-- Área de contenido y toggles
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -180, 1, -45)
contentArea.Position = UDim2.new(0, 180, 0, 45)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainPanel

local function createToggleRow(name, posY)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -40, 0, 45)
    frame.Position = UDim2.new(0, 20, 0, posY)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    frame.BorderSizePixel = 0
    frame.Parent = contentArea
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -70, 1, 0)
    textLabel.Position = UDim2.new(0, 15, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame
    
    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 44, 0, 22)
    switchBg.Position = UDim2.new(1, -54, 0.5, -11)
    switchBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    switchBg.Text = ""
    switchBg.AutoButtonColor = false
    switchBg.BorderSizePixel = 0
    switchBg.Parent = frame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = switchBg
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = switchBg
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    return switchBg, circle
end

local espToggle, espCircle = createToggleRow("ESP", 60)
local linesToggle, linesCircle = createToggleRow("Lines", 115)
local healthToggle, healthCircle = createToggleRow("Health", 170)

-- ==========================================
-- 3.1 SISTEMA DE ARRASTRE (DRAG & DROP)
-- ==========================================
local function makeDraggable(topbarObject, targetObject)
    local dragging = false
    local dragInput, dragStart, startPos
    
    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetObject.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetObject.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(keyFrame, keyFrame)
makeDraggable(topBar, mainPanel)

-- ==========================================
-- 4. LÓGICA ESP, LINES Y HEALTH (LÍMITE 500M)
-- ==========================================
local espActive = false
local linesActive = false
local healthActive = false
local drawings = {}
local connection
local MAX_DISTANCE = 500

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local function updateFeatures()
    local activePlayers = {}
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    
    if localCharacter then
        raycastParams.FilterDescendantsInstances = {localCharacter}
    end

    local playersWithLinesCount = 0

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            
            local inRange = false
            if localRoot and rootPart then
                if (localRoot.Position - rootPart.Position).Magnitude <= MAX_DISTANCE then
                    inRange = true
                end
            end
            
            local isAlive = humanoid and humanoid.Health > 0 and inRange
            activePlayers[player] = true
            
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
            
            -- 1. ESP
            local highlight = char:FindFirstChild("PermanentESP")
            if espActive and isAlive then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "PermanentESP"
                    highlight.Adornee = char
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0
                    highlight.Parent = char
                end
               
                if isBehindWall then
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.FillTransparency = 0.5
                else
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.FillTransparency = 0.4
                end
            else
                if highlight then highlight:Destroy() end
            end
            
            -- 2. Health (Fina y pequeña)
            local bbGui = char:FindFirstChild("CustomHealthESP")
            if healthActive and isAlive then
                if not bbGui and rootPart and humanoid then
                    bbGui = Instance.new("BillboardGui")
                    bbGui.Name = "CustomHealthESP"
                    bbGui.Size = UDim2.new(0, 10, 4.5, 0)
                    bbGui.StudsOffset = Vector3.new(2.2, 0, 0)
                    bbGui.AlwaysOnTop = true
                    bbGui.Adornee = rootPart
                    
                    local bgBar = Instance.new("Frame")
                    bgBar.Size = UDim2.new(0.5, 0, 1, 0)
                    bgBar.Position = UDim2.new(0.25, 0, 0, 0)
                    bgBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    bgBar.BorderSizePixel = 0
                    bgBar.Parent = bbGui
                    
                    local fillBar = Instance.new("Frame")
                    fillBar.Name = "Fill"
                    fillBar.Size = UDim2.new(1, 0, humanoid.Health / humanoid.MaxHealth, 0)
                    fillBar.Position = UDim2.new(0, 0, 0, 0)
                    fillBar.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
                    fillBar.BorderSizePixel = 0
                    fillBar.Parent = bgBar
                    
                    local function updateHealthState()
                        if fillBar and humanoid and humanoid.MaxHealth > 0 then
                            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            fillBar.Size = UDim2.new(1, 0, healthPercent, 0)
                            
                            fillBar.BackgroundColor3 = Color3.fromRGB(
                                math.clamp(255 * (1 - healthPercent) * 2, 0, 255),
                                math.clamp(255 * healthPercent * 2, 0, 255),
                                50
                            )
                        end
                    end
                    updateHealthState()
                    humanoid.HealthChanged:Connect(updateHealthState)
                    bbGui.Parent = char
                end
            else
                if bbGui then bbGui:Destroy() end
            end
            
            -- 3. Lines
            if linesActive and isAlive and head then
                local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if not drawings[player] then
                    local line = Drawing.new("Line")
                    line.Visible = false
                    line.Thickness = 1.5
                    drawings[player] = line
                end
                
                local line = drawings[player]
                if onScreen then
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    line.To = Vector2.new(headPos.X, headPos.Y)
                    
                    if isBehindWall then
                        line.Color = Color3.fromRGB(0, 255, 0)
                    else
                        line.Color = Color3.fromRGB(255, 0, 0)
                    end
                    
                    line.Visible = true
                    playersWithLinesCount = playersWithLinesCount + 1
                else
                    line.Visible = false
                end
            else
                if drawings[player] then
                    drawings[player].Visible = false
                end
            end
        end
    end
    
    if linesActive then
        topIndicatorFrame.Visible = true
        countLabel.Text = tostring(playersWithLinesCount)
    else
        topIndicatorFrame.Visible = false
    end

    for player, line in pairs(drawings) do
        if not activePlayers[player] or not (Players:FindFirstChild(player.Name)) then
            if line then line:Remove() end
            drawings[player] = nil
        end
    end
end

local function checkConnection()
    if espActive or linesActive or healthActive then
        if not connection then
            connection = RunService.RenderStepped:Connect(updateFeatures)
        end
    else
        if connection then
            connection:Disconnect()
            connection = nil
            topIndicatorFrame.Visible = false
            for _, line in pairs(drawings) do
                if line then line:Remove() end
            end
            drawings = {}
        end
    end
end

local function toggleState(btn, circle, stateType)
    if stateType == "esp" then
        espActive = not espActive
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = espActive and Color3.fromRGB(210, 30, 140) or Color3.fromRGB(45, 45, 55)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = espActive and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
    elseif stateType == "lines" then
        linesActive = not linesActive
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = linesActive and Color3.fromRGB(210, 30, 140) or Color3.fromRGB(45, 45, 55)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = linesActive and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
        if not linesActive then
            topIndicatorFrame.Visible = false
            for _, line in pairs(drawings) do
                if line then line.Visible = false end
            end
        end
    elseif stateType == "health" then
        healthActive = not healthActive
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = healthActive and Color3.fromRGB(210, 30, 140) or Color3.fromRGB(45, 45, 55)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = healthActive and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
    end
    checkConnection()
end

espToggle.MouseButton1Click:Connect(function() toggleState(espToggle, espCircle, "esp") end)
linesToggle.MouseButton1Click:Connect(function() toggleState(linesToggle, linesCircle, "lines") end)
healthToggle.MouseButton1Click:Connect(function() toggleState(healthToggle, healthCircle, "health") end)

-- ==========================================
-- 5. VALIDACIÓN DE KEYS CONECTADA A GITHUB
-- ==========================================
verifyButton.MouseButton1Click:Connect(function()
    local enteredKey = keyBox.Text
    
    if enteredKey == "" then
        keyBox.Text = ""
        keyBox.PlaceholderText = "Ingresa una key"
        return
    end
    
    verifyButton.Text = "VERIFICANDO..."
    
    local successGet, response = pcall(function()
        if request then
            local res = request({Url = GITHUB_URL, Method = "GET"})
            return res.Body
        elseif syn and syn.request then
            local res = syn.request({Url = GITHUB_URL, Method = "GET"})
            return res.Body
        else
            return game:HttpGet(GITHUB_URL)
        end
    end)
    
    if not successGet or not response then
        verifyButton.Text = "VERIFICAR"
        keyBox.Text = ""
        keyBox.PlaceholderText = "Error de red ❌"
        return
    end
    
    local successDecode, keysData = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not successDecode or type(keysData) ~= "table" then
        verifyButton.Text = "VERIFICAR"
        keyBox.Text = ""
        keyBox.PlaceholderText = "Base de datos corrupta"
        return
    end
    
    local keyData = keysData[enteredKey]
    
    if not keyData then
        verifyButton.Text = "VERIFICAR"
        keyBox.Text = ""
        keyBox.PlaceholderText = "Key inválida"
        return
    end
    
    local totalSeconds = (keyData.durationDays * 86400) + (keyData.durationHours * 3600) + (keyData.durationMinutes * 60)
    
    if totalSeconds > 0 then
        if not keyData.expirationTime then
            keyData.expirationTime = os.time() + totalSeconds
        end
        
        if os.time() > keyData.expirationTime then
            verifyButton.Text = "VERIFICAR"
            keyBox.Text = ""
            keyBox.PlaceholderText = "Key expirada ⏰"
            return
        end
    end
    
    local allowedHWIDs = keyData.allowedHWIDs or {}
    local deviceAlreadyRegistered = false
    
    for _, id in ipairs(allowedHWIDs) do
        if id == deviceID then
            deviceAlreadyRegistered = true
            break
        end
    end
    
    if not deviceAlreadyRegistered then
        if #allowedHWIDs < keyData.maxDevices then
            table.insert(allowedHWIDs, deviceID)
            keyData.allowedHWIDs = allowedHWIDs
        else
            verifyButton.Text = "VERIFICAR"
            keyBox.Text = ""
            keyBox.PlaceholderText = "Límite de dispositivos alcanzado 🚫"
            return
        end
    end
    
    verifyButton.Text = "¡VERIFICADO!"
    keyBox.PlaceholderText = "¡Verificado!"
    task.wait(0.4)
    
    keyFrame.Visible = false
    mainPanel.Visible = true
end)

-- ==========================================
-- 6. BOTONES DE MINIMIZAR, CERRAR Y ATAJO K
-- ==========================================
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    sideMenu.Visible = not isMinimized
    contentArea.Visible = not isMinimized
    
    if isMinimized then
        TweenService:Create(mainPanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 580, 0, 45)}):Play()
        minimizeButton.Text = "+"
    else
        TweenService:Create(mainPanel, TweenInfo.new(0.2), {Size = UDim2.new(0, 580, 0, 380)}):Play()
        minimizeButton.Text = "-"
    end
end)

closeButton.MouseButton1Click:Connect(function()
    if connection then connection:Disconnect() end
    counterGui:Destroy()
    for _, line in pairs(drawings) do if line then line:Remove() end end
    screenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

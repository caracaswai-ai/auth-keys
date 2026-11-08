-- ==========================================
-- 01Scripts | Panel 2 (Morado y Negro)
-- Autenticación exclusiva con keys2.json
-- ==========================================

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
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
-- INTERFAZ GRÁFICA (LOGIN)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "01Scripts_Panel2_Login"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 220)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(72, 27, 117)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 15)
Title.BackgroundTransparency = 1
Title.Text = "01Scripts | Panel 2 Login"
Title.TextColor3 = Color3.fromRGB(177, 77, 239)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -40, 0, 20)
SubTitle.Position = UDim2.new(0, 20, 0, 55)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Introduce tu clave de keys2.json:"
SubTitle.TextColor3 = Color3.fromRGB(136, 136, 144)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = MainFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -40, 0, 40)
TextBox.Position = UDim2.new(0, 20, 0, 85)
TextBox.BackgroundColor3 = Color3.fromRGB(23, 8, 38)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "VIP-KEY-XXXXXXXX o FREE-KEY-XXXXXXXX"
TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
TextBox.TextSize = 12
TextBox.Font = Enum.Font.Gotham
TextBox.ClearTextOnFocus = false
TextBox.Parent = MainFrame

local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0, 6)
TextBoxCorner.Parent = TextBox

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(1, -40, 0, 35)
VerifyBtn.Position = UDim2.new(0, 20, 0, 140)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(177, 77, 239)
VerifyBtn.TextColor3 = Color3.fromRGB(11, 11, 14)
VerifyBtn.Text = "Verificar Key"
VerifyBtn.TextSize = 14
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = VerifyBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 20)
StatusLabel.Position = UDim2.new(0, 20, 0, 185)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- ==========================================
-- PANEL PRINCIPAL 01Scripts (Panel 2)
-- ==========================================
local function OpenMainPanel()
    ScreenGui:Destroy()

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "01Scripts_Panel2_Main"
    MainGui.Parent = CoreGui
    MainGui.ResetOnSpawn = false

    local PanelFrame = Instance.new("Frame")
    PanelFrame.Size = UDim2.new(0, 500, 0, 350)
    PanelFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    PanelFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
    PanelFrame.BorderSizePixel = 0
    PanelFrame.Active = true
    PanelFrame.Draggable = true
    PanelFrame.Parent = MainGui

    local PCorner = Instance.new("UICorner")
    PCorner.CornerRadius = UDim.new(0, 10)
    PCorner.Parent = PanelFrame

    local PStroke = Instance.new("UIStroke")
    PStroke.Color = Color3.fromRGB(72, 27, 117)
    PStroke.Thickness = 2
    PStroke.Parent = PanelFrame

    local PTitle = Instance.new("TextLabel")
    PTitle.Size = UDim2.new(1, 0, 0, 45)
    PTitle.Position = UDim2.new(0, 0, 0, 0)
    PTitle.BackgroundColor3 = Color3.fromRGB(18, 6, 31)
    PTitle.Text = "  01Scripts | Panel 2 (Activo)"
    PTitle.TextColor3 = Color3.fromRGB(177, 77, 239)
    PTitle.TextSize = 14
    PTitle.Font = Enum.Font.GothamBold
    PTitle.TextXAlignment = Enum.TextXAlignment.Left
    PTitle.Parent = PanelFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = PTitle

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 7)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = PTitle

    CloseBtn.MouseButton1Click:Connect(function()
        MainGui:Destroy()
    end)

    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Size = UDim2.new(1, -20, 1, -60)
    ContentContainer.Position = UDim2.new(0, 10, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.CanvasSize = UDim2.new(0, 0, 2, 0)
    ContentContainer.ScrollBarThickness = 4
    ContentContainer.Parent = PanelFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ContentContainer

    -- Función para crear toggles funcionales
    local function CreateToggle(name, callback)
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(23, 8, 38)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleBtn.Text = "  " .. name .. ": [ OFF ]"
        ToggleBtn.TextSize = 13
        ToggleBtn.Font = Enum.Font.Gotham
        ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
        ToggleBtn.Parent = ContentContainer

        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 6)
        TCorner.Parent = ToggleBtn

        local state = false
        ToggleBtn.MouseButton1Click:Connect(function()
            state = not state
            if state then
                ToggleBtn.Text = "  " .. name .. ": [ ON ]"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(72, 27, 117)
            else
                ToggleBtn.Text = "  " .. name .. ": [ OFF ]"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(23, 8, 38)
            end
            pcall(function() callback(state) end)
        end)
    end

    -- Secciones y funciones activas del panel
    CreateToggle("ESP Box / Chams", function(state)
        -- Código o lógica de ESP aquí
    end)

    CreateToggle("Aimbot / Silent Aim", function(state)
        -- Código o lógica de Aimbot aquí
    end)

    CreateToggle("FOV Circle", function(state)
        -- Código o lógica de FOV aquí
    end)
end

VerifyBtn.MouseButton1Click:Connect(function()
    local enteredKey = TextBox.Text:gsub("%s+", "")
    if enteredKey == "" then
        StatusLabel.Text = "⚠️ Introduce una key."
        return
    end

    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    StatusLabel.Text = "Verificando..."

    task.spawn(function()
        local isValid = verifyKey(enteredKey)
        if isValid then
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
            StatusLabel.Text = "¡Acceso concedido!"
            task.wait(0.5)
            OpenMainPanel()
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
            StatusLabel.Text = "❌ Key inválida para el Panel 2."
        end
    end)
end)

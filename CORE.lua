-- =================================================================
-- 🌌 LuaField UI Library - Standalone Single File Edition
-- =================================================================

local LuaFieldLibrary = {
    Version = "v1.0",
    Flags = {},
    Themes = {
        Current = "Default",
        Palettes = {
            Default = {
                TextFont = Enum.Font.GothamMedium,
                TextColor = Color3.fromRGB(245, 245, 250),
                Background = Color3.fromRGB(15, 15, 20),
                Topbar = Color3.fromRGB(22, 22, 30),
                ElementBackground = Color3.fromRGB(24, 24, 32),
                ElementStroke = Color3.fromRGB(40, 40, 55),
                Accent = Color3.fromRGB(120, 90, 255)
            },
            Midnight = {
                TextFont = Enum.Font.GothamMedium,
                TextColor = Color3.fromRGB(240, 240, 240),
                Background = Color3.fromRGB(10, 12, 16),
                Topbar = Color3.fromRGB(16, 20, 26),
                ElementBackground = Color3.fromRGB(18, 22, 30),
                ElementStroke = Color3.fromRGB(32, 42, 56),
                Accent = Color3.fromRGB(0, 195, 255)
            }
        }
    }
}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Helper: Get Safe Target Parent
local function GetTargetParent()
    if gethui then
        return gethui()
    elseif syn and syn.protect_gui then
        return CoreGui
    elseif CoreGui:FindFirstChild("RobloxGui") then
        return CoreGui:FindFirstChild("RobloxGui")
    end
    return CoreGui
end

-- Helper: Dragging
local function MakeDraggable(guiObj, dragHandle)
    dragHandle = dragHandle or guiObj
    local dragging, dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObj.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(guiObj, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- Config Handler
LuaFieldLibrary.Config = {
    Folder = "LuaField/Configurations",
    Save = function(fileName, data)
        if writefile then
            if makefolder and not isfolder("LuaField") then
                makefolder("LuaField")
                makefolder("LuaField/Configurations")
            end
            pcall(function()
                writefile("LuaField/Configurations/"..fileName..".lfield", HttpService:JSONEncode(data))
            end)
            return true
        end
        return false
    end,
    Load = function(fileName)
        if readfile and isfile then
            local path = "LuaField/Configurations/"..fileName..".lfield"
            if isfile(path) then
                local s, r = pcall(function()
                    return HttpService:JSONDecode(readfile(path))
                end)
                if s then return r end
            end
        end
        return nil
    end
}

-- Init Window
function LuaFieldLibrary:Init(options)
    options = options or {}
    local theme = LuaFieldLibrary.Themes.Palettes[options.Theme] or LuaFieldLibrary.Themes.Palettes.Default
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightControl

    -- Clean old instances
    local parent = GetTargetParent()
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "LuaFieldUI" then
            child:Destroy()
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LuaFieldUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = parent

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = theme.Background
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    MakeDraggable(Main)

    local Topbar = Instance.new("Frame", Main)
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = theme.Topbar
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel", Topbar)
    Title.Text = options.Name or "LuaField Hub"
    Title.Size = UDim2.new(0.8, 0, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.TextColor3 = theme.TextColor
    Title.Font = theme.TextFont
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Container for Elements
    local Container = Instance.new("ScrollingFrame", Main)
    Container.Size = UDim2.new(1, -24, 1, -52)
    Container.Position = UDim2.new(0, 12, 0, 46)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 4
    Container.BorderSizePixel = 0

    local UIListLayout = Instance.new("UIListLayout", Container)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    -- Toggle UI Visibility Keybind
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == toggleKey then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Window Methods
    local WindowAPI = {}

    function WindowAPI:CreateButton(name, callback)
        local btnFrame = Instance.new("Frame", Container)
        btnFrame.Size = UDim2.new(1, -8, 0, 36)
        btnFrame.BackgroundColor3 = theme.ElementBackground
        Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 6)

        local stroke = Instance.new("UIStroke", btnFrame)
        stroke.Color = theme.ElementStroke
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local btn = Instance.new("TextButton", btnFrame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = name or "Button"
        btn.TextColor3 = theme.TextColor
        btn.Font = theme.TextFont
        btn.TextSize = 14

        btn.MouseButton1Click:Connect(function()
            TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundColor3 = theme.Accent}):Play()
            task.wait(0.1)
            TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = theme.ElementBackground}):Play()
            if callback then callback() end
        end)
    end

    function WindowAPI:CreateToggle(name, default, callback)
        local state = default or false
        local toggleFrame = Instance.new("Frame", Container)
        toggleFrame.Size = UDim2.new(1, -8, 0, 36)
        toggleFrame.BackgroundColor3 = theme.ElementBackground
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

        local stroke = Instance.new("UIStroke", toggleFrame)
        stroke.Color = theme.ElementStroke

        local label = Instance.new("TextLabel", toggleFrame)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.Text = name or "Toggle"
        label.TextColor3 = theme.TextColor
        label.Font = theme.TextFont
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        local indicator = Instance.new("Frame", toggleFrame)
        indicator.Size = UDim2.new(0, 18, 0, 18)
        indicator.Position = UDim2.new(1, -28, 0.5, -9)
        indicator.BackgroundColor3 = state and theme.Accent or theme.ElementStroke
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)

        local btn = Instance.new("TextButton", toggleFrame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""

        btn.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(indicator, TweenInfo.new(0.15), {
                BackgroundColor3 = state and theme.Accent or theme.ElementStroke
            }):Play()
            if callback then callback(state) end
        end)
    end

    return WindowAPI
end

return LuaFieldLibrary

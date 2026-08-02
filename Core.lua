local Core = {}
local UserInputService = game:GetService("UserInputService")
local Utilities = require(script.Parent.Utilities)
local Themes = require(script.Parent.Themes)

function Core.CreateWindow(devConfig)
    local library = {
        CurrentTab = nil,
        Keybind = devConfig.ToggleKey or Enum.KeyCode.RightControl
    }

    local targetParent = Utilities.GetTargetParent("LuaField")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LuaField"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = targetParent

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(0, 550, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    mainFrame.BackgroundColor3 = Themes.CurrentTheme.Background
    mainFrame.Parent = screenGui

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    Utilities.MakeDraggable(mainFrame)

    local topbar = Instance.new("Frame", mainFrame)
    topbar.Size = UDim2.new(1, 0, 0, 40)
    topbar.BackgroundColor3 = Themes.CurrentTheme.Topbar
    Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", topbar)
    title.Text = devConfig.Name or "LuaField Interface"
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.TextColor3 = Themes.CurrentTheme.TextColor
    title.Font = Themes.CurrentTheme.TextFont
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1

    -- Global Keybind Toggle UI
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == library.Keybind then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)

    function library:CreateTab(name)
        -- Logika pembuatan Tab Container & Sidebar button
        local tabWindow = {}
        -- (Dapat dihubungkan ke Components module)
        return tabWindow
    end

    return library
end

return Core

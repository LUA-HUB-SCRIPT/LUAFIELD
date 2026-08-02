local Components = {}
local Utilities = require(script.Parent.Utilities)
local Themes = require(script.Parent.Themes)

function Components.CreateButton(parentFrame, options, callback)
    local theme = Themes.CurrentTheme
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = options.Name or "Button"
    buttonFrame.Size = UDim2.new(1, 0, 0, 36)
    buttonFrame.BackgroundColor3 = theme.ElementBackground
    buttonFrame.Parent = parentFrame

    local corner = Instance.new("UICorner", buttonFrame)
    corner.CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", buttonFrame)
    stroke.Color = theme.ElementStroke
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = options.Name or "Button"
    btn.TextColor3 = theme.TextColor
    btn.Font = theme.TextFont
    btn.TextSize = 14
    btn.Parent = buttonFrame

    btn.MouseButton1Click:Connect(function()
        Utilities.Tween(buttonFrame, TweenInfo.new(0.1), {BackgroundColor3 = theme.Accent})
        task.wait(0.1)
        Utilities.Tween(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = theme.ElementBackground})
        if callback then callback() end
    end)

    return buttonFrame
end

function Components.CreateToggle(parentFrame, options, callback)
    local theme = Themes.CurrentTheme
    local state = options.Default or false

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 36)
    toggleFrame.BackgroundColor3 = theme.ElementBackground
    toggleFrame.Parent = parentFrame

    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = options.Name or "Toggle"
    label.TextColor3 = theme.TextColor
    label.Font = theme.TextFont
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local indicator = Instance.new("Frame", toggleFrame)
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(1, -30, 0.5, -10)
    indicator.BackgroundColor3 = state and theme.Accent or theme.ElementStroke
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)

    local btn = Instance.new("TextButton", toggleFrame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    btn.MouseButton1Click:Connect(function()
        state = not state
        Utilities.Tween(indicator, TweenInfo.new(0.2), {
            BackgroundColor3 = state and theme.Accent or theme.ElementStroke
        })
        if callback then callback(state) end
    end)

    return toggleFrame
end

return Components

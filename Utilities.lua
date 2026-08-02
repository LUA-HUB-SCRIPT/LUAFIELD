local Utilities = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Safe Parent Resolution for Roblox Executors
function Utilities.GetTargetParent(uiName)
    local target = CoreGui
    if gethui then
        target = gethui()
    elseif syn and syn.protect_gui then
        target = CoreGui
    elseif CoreGui:FindFirstChild("RobloxGui") then
        target = CoreGui:FindFirstChild("RobloxGui")
    end

    -- Remove old instances
    for _, child in ipairs(target:GetChildren()) do
        if child.Name == uiName then
            child:Destroy()
        end
    end

    return target
end

-- Make Frame Draggable
function Utilities.MakeDraggable(guiObj, dragHandle)
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

-- Tween Helper
function Utilities.Tween(instance, info, properties)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

return Utilities

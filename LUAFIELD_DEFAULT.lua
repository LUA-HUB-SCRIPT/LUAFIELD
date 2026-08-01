--[[

    LuaField Interface Suite
    Rebranded & Redesigned Modern UI
    
    Forked from Rayfield Suite
    Engine: LuaField Framework v1.0

]]

local Release = "LuaField v1.0"
local NotificationDuration = 6.5
local LuaFieldFolder = "LuaField"
local ConfigurationFolder = LuaFieldFolder.."/Configurations"
local ConfigurationExtension = ".lfield"

local LuaFieldLibrary = {
    Flags = {},
    Theme = {
        -- Tema Utama: Modern Dark / Modern Sleek UI
        Default = {
            TextFont = Enum.Font.GothamMedium,
            TextColor = Color3.fromRGB(245, 245, 250),
            SubTextColor = Color3.fromRGB(160, 160, 175),

            Background = Color3.fromRGB(15, 15, 20),           -- Dark Modern Background
            Topbar = Color3.fromRGB(22, 22, 30),               -- Sleek Topbar
            Shadow = Color3.fromRGB(5, 5, 10),

            NotificationBackground = Color3.fromRGB(20, 20, 28),
            NotificationActionsBackground = Color3.fromRGB(35, 35, 48),

            TabBackground = Color3.fromRGB(25, 25, 35),
            TabStroke = Color3.fromRGB(45, 45, 60),
            TabBackgroundSelected = Color3.fromRGB(120, 90, 255), -- Modern Accent Color (Purple/Violet)
            TabTextColor = Color3.fromRGB(200, 200, 215),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),

            ElementBackground = Color3.fromRGB(24, 24, 32),
            ElementBackgroundHover = Color3.fromRGB(32, 32, 44),
            SecondaryElementBackground = Color3.fromRGB(18, 18, 24),
            ElementStroke = Color3.fromRGB(40, 40, 55),
            SecondaryElementStroke = Color3.fromRGB(30, 30, 42),

            SliderBackground = Color3.fromRGB(30, 30, 42),
            SliderProgress = Color3.fromRGB(120, 90, 255),
            SliderStroke = Color3.fromRGB(140, 110, 255),

            ToggleBackground = Color3.fromRGB(25, 25, 35),
            ToggleEnabled = Color3.fromRGB(120, 90, 255),       -- Modern Neon Accent
            ToggleDisabled = Color3.fromRGB(45, 45, 55),
            ToggleEnabledStroke = Color3.fromRGB(150, 120, 255),
            ToggleDisabledStroke = Color3.fromRGB(60, 60, 75),
            ToggleEnabledOuterStroke = Color3.fromRGB(100, 70, 220),
            ToggleDisabledOuterStroke = Color3.fromRGB(35, 35, 45),

            InputBackground = Color3.fromRGB(22, 22, 30),
            InputStroke = Color3.fromRGB(45, 45, 60),
            PlaceholderColor = Color3.fromRGB(120, 120, 140)
        },
        -- Alternative Theme: Midnight Cyber
        Midnight = {
            TextFont = Enum.Font.GothamMedium,
            TextColor = Color3.fromRGB(240, 240, 240),

            Background = Color3.fromRGB(10, 12, 16),
            Topbar = Color3.fromRGB(16, 20, 26),
            Shadow = Color3.fromRGB(0, 0, 0),

            NotificationBackground = Color3.fromRGB(14, 18, 24),
            NotificationActionsBackground = Color3.fromRGB(30, 38, 50),

            TabBackground = Color3.fromRGB(20, 26, 34),
            TabStroke = Color3.fromRGB(35, 45, 60),
            TabBackgroundSelected = Color3.fromRGB(0, 195, 255), -- Cyber Cyan Accent
            TabTextColor = Color3.fromRGB(220, 220, 220),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),

            ElementBackground = Color3.fromRGB(18, 22, 30),
            ElementBackgroundHover = Color3.fromRGB(24, 30, 40),
            SecondaryElementBackground = Color3.fromRGB(12, 15, 20),
            ElementStroke = Color3.fromRGB(32, 42, 56),
            SecondaryElementStroke = Color3.fromRGB(25, 32, 42),

            SliderBackground = Color3.fromRGB(25, 32, 42),
            SliderProgress = Color3.fromRGB(0, 195, 255),
            SliderStroke = Color3.fromRGB(50, 210, 255),

            ToggleBackground = Color3.fromRGB(20, 26, 34),
            ToggleEnabled = Color3.fromRGB(0, 195, 255),
            ToggleDisabled = Color3.fromRGB(40, 50, 65),
            ToggleEnabledStroke = Color3.fromRGB(80, 220, 255),
            ToggleDisabledStroke = Color3.fromRGB(50, 60, 75),
            ToggleEnabledOuterStroke = Color3.fromRGB(0, 160, 210),
            ToggleDisabledOuterStroke = Color3.fromRGB(30, 38, 50),

            InputBackground = Color3.fromRGB(16, 20, 26),
            InputStroke = Color3.fromRGB(35, 45, 60),
            PlaceholderColor = Color3.fromRGB(100, 120, 140)
        }
    }
}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Interface Management
local LuaField = game:GetObjects("rbxassetid://10804731440")[1]
LuaField.Name = "LuaField"
LuaField.Enabled = false

-- Placement and Anti-Duplicate Check
local TargetParent = CoreGui
if gethui then
    TargetParent = gethui()
elseif syn and syn.protect_gui then 
    syn.protect_gui(LuaField)
    TargetParent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then
    TargetParent = CoreGui:FindFirstChild("RobloxGui")
end

LuaField.Parent = TargetParent

for _, Interface in ipairs(TargetParent:GetChildren()) do
    if Interface.Name == "LuaField" and Interface ~= LuaField then
        Interface.Enabled = false
        Interface.Name = "LuaField-Old"
    end
end

-- Object Variables
local Camera = workspace.CurrentCamera
local Main = LuaField.Main
local Topbar = Main.Topbar
local Elements = Main.Elements
local LoadingFrame = Main.LoadingFrame
local TabList = Main.TabList

LuaField.DisplayOrder = 100
if LoadingFrame:FindFirstChild("Version") then
    LoadingFrame.Version.Text = Release
end

-- State Variables
local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false
local Notifications = LuaField.Notifications

local SelectedTheme = LuaFieldLibrary.Theme.Default

function ChangeTheme(ThemeName)
    SelectedTheme = LuaFieldLibrary.Theme[ThemeName] or LuaFieldLibrary.Theme.Default
    
    for _, obj in ipairs(LuaField:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") then
            obj.TextColor3 = SelectedTheme.TextColor
            obj.Font = SelectedTheme.TextFont
        end
    end

    Main.BackgroundColor3 = SelectedTheme.Background
    Topbar.BackgroundColor3 = SelectedTheme.Topbar
    if Topbar:FindFirstChild("CornerRepair") then
        Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar
    end
    if Main:FindFirstChild("Shadow") then
        Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow
    end

    for _, TabPage in ipairs(Elements:GetChildren()) do
        for _, Element in ipairs(TabPage:GetChildren()) do
            if Element:IsA("Frame") and Element.Name ~= "Placeholder" and Element.Name ~= "SectionSpacing" and Element.Name ~= "SectionTitle" then
                Element.BackgroundColor3 = SelectedTheme.ElementBackground
                if Element:FindFirstChild("UIStroke") then
                    Element.UIStroke.Color = SelectedTheme.ElementStroke
                end
            end
        end
    end
end

function LuaFieldLibrary:Notify(NotificationSettings)
    task.spawn(function()
        local ActionCompleted = true
        local Notification = Notifications.Template:Clone()
        Notification.Parent = Notifications
        Notification.Name = NotificationSettings.Title or "LuaField Notification"
        Notification.Visible = true

        Notification.BackgroundColor3 = SelectedTheme.NotificationBackground
        Notification.Title.Text = NotificationSettings.Title or "LuaField"
        Notification.Title.TextColor3 = SelectedTheme.TextColor
        Notification.Description.Text = NotificationSettings.Content or ""
        Notification.Description.TextColor3 = SelectedTheme.TextColor
        
        Notification.Size = UDim2.new(0, 295, 0, 91)
        Notification.BackgroundTransparency = 0.15

        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.05
        }):Play()

        task.wait(NotificationSettings.Duration or NotificationDuration)
        
        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 260, 0, 0)
        }):Play()
        
        task.wait(0.5)
        Notification:Destroy()
    end)
end

return LuaFieldLibrary

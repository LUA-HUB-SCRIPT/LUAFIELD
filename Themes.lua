local Themes = {}

Themes.Palettes = {
    Default = {
        TextFont = Enum.Font.GothamMedium,
        TextColor = Color3.fromRGB(245, 245, 250),
        SubTextColor = Color3.fromRGB(160, 160, 175),
        Background = Color3.fromRGB(15, 15, 20),
        Topbar = Color3.fromRGB(22, 22, 30),
        Shadow = Color3.fromRGB(5, 5, 10),
        NotificationBackground = Color3.fromRGB(20, 20, 28),
        TabBackground = Color3.fromRGB(25, 25, 35),
        TabBackgroundSelected = Color3.fromRGB(120, 90, 255),
        ElementBackground = Color3.fromRGB(24, 24, 32),
        ElementStroke = Color3.fromRGB(40, 40, 55),
        Accent = Color3.fromRGB(120, 90, 255)
    },
    Midnight = {
        TextFont = Enum.Font.GothamMedium,
        TextColor = Color3.fromRGB(240, 240, 240),
        SubTextColor = Color3.fromRGB(140, 160, 180),
        Background = Color3.fromRGB(10, 12, 16),
        Topbar = Color3.fromRGB(16, 20, 26),
        Shadow = Color3.fromRGB(0, 0, 0),
        NotificationBackground = Color3.fromRGB(14, 18, 24),
        TabBackground = Color3.fromRGB(20, 26, 34),
        TabBackgroundSelected = Color3.fromRGB(0, 195, 255),
        ElementBackground = Color3.fromRGB(18, 22, 30),
        ElementStroke = Color3.fromRGB(32, 42, 56),
        Accent = Color3.fromRGB(0, 195, 255)
    }
}

Themes.CurrentTheme = Themes.Palettes.Default

function Themes.SetTheme(themeName)
    if Themes.Palettes[themeName] then
        Themes.CurrentTheme = Themes.Palettes[themeName]
        return Themes.CurrentTheme
    end
    return Themes.CurrentTheme
end

return Themes

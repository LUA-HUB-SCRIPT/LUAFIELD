local LuaField = {
    Version = "v1.0",
    Core = require(script.Core),
    Themes = require(script.Themes),
    Config = require(script.Config),
    Components = require(script.Components),
    Utilities = require(script.Utilities)
}

-- Developer Initializer API
function LuaField:Init(devOptions)
    devOptions = devOptions or {}
    
    local windowConfig = {
        Name = devOptions.Name or "LuaField Hub",
        ToggleKey = devOptions.ToggleKey or Enum.KeyCode.RightControl,
        Theme = devOptions.Theme or "Default"
    }

    LuaField.Themes.SetTheme(windowConfig.Theme)
    LuaField.Config.Init()

    local window = LuaField.Core.CreateWindow(windowConfig)
    return window
end

return LuaField

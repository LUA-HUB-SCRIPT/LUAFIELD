--[[
    LuaField Interface Suite
    Engine: LuaField Framework v1.0
    Modular Web Loader
]]

local BaseURL = "https://raw.githubusercontent.com/LUA-HUB-SCRIPT/LUAFIELD/main/"

-- Dynamic Module Fetcher function
local function FetchModule(moduleName)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BaseURL .. moduleName .. ".lua"))()
    end)

    -- Case-sensitivity fallback (misal: CORE.lua vs Core.lua)
    if not success then
        success, result = pcall(function()
            return loadstring(game:HttpGet(BaseURL .. string.upper(moduleName) .. ".lua"))()
        end)
    end

    if not success then
        error("[LuaField Loader]: Gagal memuat modul: " .. moduleName .. " | Error: " .. tostring(result))
    end
    return result
end

-- Load All Modular Dependencies
local Utilities  = FetchModule("Utilities")
local Themes     = FetchModule("Themes")
local Config     = FetchModule("Config")
local Components = FetchModule("Components")
local Core       = FetchModule("CORE")

-- Consolidate Framework API
local LuaField = {
    Version    = "v1.0",
    Core       = Core,
    Themes     = Themes,
    Config     = Config,
    Components = Components,
    Utilities  = Utilities
}

-- Developer Initializer Function
function LuaField:Init(devOptions)
    devOptions = devOptions or {}
    
    local windowConfig = {
        Name      = devOptions.Name or "LuaField Hub",
        ToggleKey = devOptions.ToggleKey or Enum.KeyCode.RightControl,
        Theme     = devOptions.Theme or "Default"
    }

    Themes.SetTheme(windowConfig.Theme)
    Config.Init()

    local window = Core.CreateWindow(windowConfig)
    return window
end

return LuaField

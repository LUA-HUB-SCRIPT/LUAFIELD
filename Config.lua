local Config = {}
local HttpService = game:GetService("HttpService")

local FolderName = "LuaField/Configurations"

function Config.Init()
    if makefolder and not isfolder("LuaField") then
        makefolder("LuaField")
        makefolder(FolderName)
    end
end

function Config.Save(fileName, dataTable)
    if writefile then
        Config.Init()
        local filePath = FolderName .. "/" .. fileName .. ".lfield"
        local success, err = pcall(function()
            writefile(filePath, HttpService:JSONEncode(dataTable))
        end)
        return success
    end
    return false
end

function Config.Load(fileName)
    if readfile and isfile then
        local filePath = FolderName .. "/" .. fileName .. ".lfield"
        if isfile(filePath) then
            local success, result = pcall(function()
                return HttpService:JSONDecode(readfile(filePath))
            end)
            if success then return result end
        end
    end
    return nil
end

return Config

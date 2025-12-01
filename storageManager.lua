local Nn, GWB, StorageMgr = ...

GWB.StorageMgr = {}

function GWB.StorageMgr:SaveStorageToDisk()
    GWB:Debug("Creating new Storage obj...")
    local str = Nn.Utils.JSON.encode(GWB.Storage)
    --WriteFile(GWB.Storage.jsonSavePath, str)
    local path = GWB.StorageMgr:GenerateStoragePath()
    WriteFile(path, str)
    GWB:Print("Config OK!")
end

function GWB.StorageMgr:GenerateStoragePath()
    local a = UnitName("player") or "unknown"
    -- TODO: file check "storage" exists!!
    if GWB.is_debug then
        return "/scripts/GWB_DEV/storage/storage_" .. a .. ".json"
    else
        return "/scripts/GWB/storage/storage_" .. a .. ".json"
    end
end

function GWB.StorageMgr:Initialize()
    -- save to disk?
    local json = Nn.Utils.JSON
    local path = GWB.StorageMgr:GenerateStoragePath() --Bot.Config.jsonSavePath
    GWB:Debug("Reading ", path)

    if json ~= nil then
        --ReadFile() -- TODO: deserialize?
        local loaded = false
        if FileExists(path) then
            GWB:Print("Loading existing storage...")
            -- read it
            local loadStr = ReadFile(path)
            local s, res = pcall(json.decode, loadStr)
            if s then
                GWB.Storage = res
                --GWB.Config.jsonSavePath = path
                loaded = true
                GWB:Debug("Storage OK!")
            end
        end
        
        -- not always loaded?
        if not loaded then
            -- else, create one
            GWB.StorageMgr:SaveStorageToDisk()
        end
    end
end

GWB.StorageMgr:Initialize()
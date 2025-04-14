local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.LibreAdminShared
local IntPackages = Shared.Packages
local Utils = script.Parent

local Types = require(Utils.Parent.Types)
local SHA256 = require(IntPackages.SHA256)


local ModuleObjContainer = {} :: Types.ModuleObjectContainer

function ModuleObjContainer:Add(module, props)
    do
        local list = self:List()
        for _, commandObj in list do
            if commandObj.Module == module then
                error("Duplicated entry not permitted")
            end
        end
    end

    local moduleData = require(module) :: Types.ModuleData
    local moduleObject: Types.ModuleObject = {
        Identifier = string.sub(SHA256(`{moduleData.Metadata.Name}{moduleData.Metadata.Version}{os.time()}`), 1, 6),
        Module = moduleData,
        Properties = props,
    }

    -- TODO: This should be wrapped in a Promise as OnInit may error and this results in the supposed ModuleObject may not work as intended, as such the ModuleObject should not be added to the list, an identifier should not be provided in this case (returning to Promise.Catch)
    task.spawn(function()
        moduleData.Events:OnInit()
        self._list[moduleObject.Identifier] = moduleObject
    end)

    return moduleObject.Identifier
end


function ModuleObjContainer:Remove(identifer)
    local moduleObject = self._list[identifer] :: Types.ModuleObject?

    if moduleObject then
        moduleObject.Module.Events:OnCleanup()
        self._list[identifer] = nil
    end
end

function ModuleObjContainer:List()
    -- TODO: In the future, this should be returning a compiled list of the commands excluding the event lifecycle functions, as this is unsafe for runtime.

    return table.clone(self._list)
end

function ModuleObjContainer:Eval(client, identifer, ...)

end

function ModuleObjContainer.new()

end

return ModuleObjContainer
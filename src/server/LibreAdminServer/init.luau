local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.LibreAdminShared
local Commands = script.Commands
local IntPackages = Shared.Packages
local Packages = ReplicatedStorage.Packages

local Types = require(script.Types)
local GetRemote = require(IntPackages.GetRemote)
local SHA256 = require(IntPackages.SHA256)

type Server = {
    _internal: {
        Commands: { [string]: Types.ModuleObject },
    },
    Commands: {
        Add: (self: Server, module: ModuleScript, props: {}) -> (string),
        Remove: (self: Server, identifier: string) -> (),
        List: (self: Server) -> ({ [string]: Types.ModuleObject }),
        Eval: (self: Server, client: Player, identifer: string, ...any) -> (...any),
    },

    Init: (self: Server, config: Types.ConfigFile) -> (),
}
type Contains<T> = { T } | T

local Server = {
    _internal = {
        Commands = {},
    },
    Commands = {},
}

function Server.Commands:Add(module, props)
    do
        local list = self.Commands:List()
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
        moduleData.Events:OnInit() -- TODO: See what's going on with the types, it's pissing me off.
        self._internal.Commands[moduleObject.Identifier] = moduleObject
    end)

    return moduleObject.Identifier
end

function Server.Commands:Remove(identifer)
    local moduleObject = self._internal.Commands[identifer] :: Types.ModuleObject?

    if moduleObject then
        moduleObject.Module.Events:OnCleanup()
        self._internal.Commands[identifer] = nil
    end
end

function Server.Commands:List()
    -- TODO: In the future, this should be returning a compiled list of the commands excluding the event lifecycle functions, as this is unsafe for runtime.

    return table.clone(self._internal.Commands)
end

function Server.Commands:Eval(client, identifer, ...)

end

function Server:Init(config)
    
end

return Server
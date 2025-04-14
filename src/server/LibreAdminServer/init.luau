local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.LibreAdminShared
local Commands = script.Commands
local IntPackages = Shared.Packages
local Packages = ReplicatedStorage.Packages
local Utils = script.Utils

local Types = require(script.Types)
local GetRemote = require(IntPackages.GetRemote)
local ModuleObjectContainer = require(Utils.ModuleObjContainer)

type Server = {
    Commands: Types.ModuleObjectContainer,
    Middlewares: Types.ModuleObjectContainer,

    Init: (self: Server, config: Types.ConfigFile) -> (),
}
type Contains<T> = { T } | T

local Server = {
    Commands = ModuleObjectContainer.new(),
    Middlewares = ModuleObjectContainer.new()
} :: Server


function Server:Init(config)
    GetRemote("Commands.Eval"):OnInvoke(self.Commands.Eval)
end

return Server
export type ConfigFile = {

}

export type ModuleData = {
    ModuleType: "Command" | "Hook",
    Metadata: {
        Name: string,
        Description: string?,
        Authors: { string }?,
        Version: string,
        License: string?
    },

    Events: {
        OnInit: (self: ModuleData) -> (),
        OnEval: (self: ModuleData) -> (),
        OnCleanup: (self: ModuleData) -> (),
    }
}

export type ModuleObject = {
    Identifier: string,
    Module: ModuleData,
    Properties: {}
}

export type ModuleObjectContainer = {
    _list: {
        [string]: ModuleObject,
    },

    Add: (self: ModuleObjectContainer, module: ModuleScript, props: {}) -> (string),
    Remove: (self: ModuleObjectContainer, identifier: string) -> (),
    List: (self: ModuleObjectContainer) -> ({ [string]: ModuleObject }),
    Eval: (self: ModuleObjectContainer, client: Player, identifer: string, ...any) -> (...any),
    new: () -> (ModuleObjectContainer)
}

return {}
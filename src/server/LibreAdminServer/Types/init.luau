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

return {}
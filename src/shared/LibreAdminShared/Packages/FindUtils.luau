local ParseFzy = require(script.Parent.ParseFzy)

local FindUtils = {}

type Contains<T> = { T } | T

function FindUtils.Find(location: Contains<Instance>, query: string, useCase: boolean)

end

function FindUtils.findOne(location: Contains<Instance>, query: string, useCase: boolean, matchExactly: boolean)
    
end

return FindUtils
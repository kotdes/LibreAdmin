local Fzy = require(script.Parent.Fzy)

return function(needle: string, haystacks: { string }, useCase: boolean)
    local results = Fzy.filter(needle, haystacks, useCase)
    local parsedResults = {}

    for _, result in results do
        table.insert(parsedResults, haystacks[result[1]])
    end

    return parsedResults
end
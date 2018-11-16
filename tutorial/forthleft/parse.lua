


function skipSpaces(inp)
    if inp:empty() then
        inp:refill()
    end
    while not inp:empty() do
        if isWhitespace(inp:next()) then
            inp:step()
        else
            break
        end
    end
end


    
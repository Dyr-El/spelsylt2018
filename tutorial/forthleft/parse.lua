-- A cell is 4 bytes wide
-- A character is 1 byte wide in memory, 1 cell wide on stack, range [0 .. 255]
-- A flag is 1 cell wide in memory and 1 cell wide on stack, TrueFlag = 2^32-1, FalseFlag = 0
-- An integer occupies 1 cell on stack and in memory and has the range [-2^31 .. 2^31-1]
-- An unsigned integer occupies 1 cell on stack and in memory and has the range [0 .. 2^32-1]
-- An address is 32 bits
-- A character aligend address is the same as an address
-- An aligned address is and address with the two least significant bits set to 0


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


    
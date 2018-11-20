-- A cell is 4 bytes wide
-- A character is 1 byte wide in memory, 1 cell wide on stack, range [0 .. 255]
-- A flag is 1 cell wide in memory and 1 cell wide on stack, TrueFlag = 2^32-1, FalseFlag = 0
-- An integer occupies 1 cell on stack and in memory and has the range [-2^31 .. 2^31-1]
-- An unsigned integer occupies 1 cell on stack and in memory and has the range [0 .. 2^32-1]
-- An address is 32 bits
-- A character aligend address is the same as an address
-- An aligned address is and address with the two least significant bits set to 0

InputStream = {buffer = "", idx = 1}
InputStream.new = function(self, object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

InputStream.empty = function(self)
    return #(self.buffer) < self.idx
end

InputStream.refill = function(self)
    -- TODO: Really inefficient!
    self.buffer = self.buffer .. io.read()
end

InputStream.next = function(self)
    if self:empty() then
        return ""
    else
        return string.sub(self.buffer, self.idx, self.idx)
    end
end

InputStream.consume = function(self, count)
    count = count or 1
    self.idx = self.idx + count
end

InputStream.print = function (self)
    io.write("[")
    io.write(self.buffer)
    io.write("]\n ")
    for i=1, self.idx-1 do
        io.write(" ")
    end
    io.write("^\n")
end

function isWhitespace(c)
    return c:find("%s") == 1
end

function skipSpaces(inp)
    if inp:empty() then
        inp:refill()
    end
    while not inp:empty() do
        if isWhitespace(inp:next()) then
            inp:consume(1)
        else
            break
        end
    end
end

myStream = InputStream:new()
skipSpaces(myStream)
while not myStream:empty() do
    io.write(myStream:next())
    myStream:consume()
end
print()
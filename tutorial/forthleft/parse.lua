-- A cell is 4 bytes wide
-- A character is 1 byte wide in memory, 1 cell wide on stack, range [0 .. 255]
-- A flag is 1 cell wide in memory and 1 cell wide on stack, TrueFlag = 2^32-1, FalseFlag = 0
-- An integer occupies 1 cell on stack and in memory and has the range [-2^31 .. 2^31-1]
-- An unsigned integer occupies 1 cell on stack and in memory and has the range [0 .. 2^32-1]
-- An address is 32 bits
-- A character aligend address is the same as an address
-- An aligned address is and address with the two least significant bits set to 0
-- http://beza1e1.tuxen.de/articles/forth.html

InputStream = {buffer = "", idx = 1, tokenIdx = 1}
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
    self.buffer = self.buffer .. " " .. io.read()
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

InputStream.endOfStream = function(self)
    return false
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

Dictionary = {words = {}}

Dictionary.new = function(self, object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

Dictionary.hasWord = function(self, word)
    return self.words[word] and true
end

Dictionary.addWord = function(self, word, func)
    self.words[word] = func
end

Dictionary.doWord = function(self, word, stack)
    self.words[word](stack)
end

Stack = {stack=nil}
Stack.new = function(self, object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

Stack.push = function(self, cell)
    self.stack = {data=cell, next=self.stack}
end

Stack.top = function(self)
    return self.stack.data
end

Stack.drop = function(self)
    self.stack = self.stack.next
end

Stack.pop = function(self)
    cell = self:top()
    self:drop()
    return cell
end

Stack.empty = function(self)
    return self.stack == nil
end

function cmdAdd(stack)
    t1 = stack:pop()
    t2 = stack:pop()
    stack:push(t1+t2)
end

function cmdPrint(stack)
    s = stack:pop()
    print(s)
end

function isWhitespace(c)
    -- Not according to forth specification
    return c:find("%s") == 1
end

function parseNumber(s)
    -- TODO: Add handling of differnet bases?
    return tonumber(s)
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

function getToken(inp)
    if inp:empty() then
        inp:refill()
    end
    s = ""
    while not inp:endOfStream() and not isWhitespace(inp:next()) do
        s = s..inp:next()
        inp:consume()
        if inp:empty() then
            inp:refill()
        end
    end
    return s
end

myStream = InputStream:new()
dict = Dictionary:new()
dict:addWord("+", cmdAdd)
dict:addWord("print", cmdPrint)
dataStack = Stack:new()
while true do
    skipSpaces(myStream)
    token = getToken(myStream)
    if dict:hasWord(token) then
        dict:doWord(token, dataStack)
    else
        num = parseNumber(token)
        if num then
            dataStack:push(num)
        else
            print("Error:", token)
        end
    end
end
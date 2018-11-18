local staticobj = {}

staticobj.x = 0
staticobj.y = 0
staticobj.image = nil
staticobj.ethereal = false

staticobj.new = function(self, object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

staticobj.addTo = function(self, theWorld)
    local width, height = self.image:getWidth(), self.image:getHeight()
    theWorld:add(self, self.x, self.y, width, height)
end

staticobj.draw = function(self, xOffset, yOffset)
    love.graphics.draw(self.image, self.x + xOffset, self.y + yOffset)
end

return staticobj
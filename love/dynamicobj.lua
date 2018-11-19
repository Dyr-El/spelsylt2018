local dynamicobj = {}

dynamicobj.x = 0
dynamicobj.y = 0
dynamicobj.vx = 0
dynamicobj.vy = 0
dynamicobj.image = nil
dynamicobj.ethereal = false

dynamicobj.new = function(self, object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

dynamicobj.addTo = function(self, theWorld)
    local width, height = self.image:getWidth(), self.image:getHeight()
    theWorld:add(self, self.x, self.y, width, height)
    self.world = theWorld
end

dynamicobj.draw = function(self, xOffset, yOffset)
    love.graphics.draw(self.image, self.x + xOffset, self.y + yOffset)
end

dynamicobj.checkOn = function(self)
    local actX, actY, cols, len = self.world:check(self, self.x, self.y+1, dynamicobj.filter)
    return actY < self.y+1
end

dynamicobj.filter = function(self, other)
    if self.ethereal or other.ethereal then
        return "cross"
    else
        return "slide"
    end
end

return dynamicobj
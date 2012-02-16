require 'class'

local M=class(function(self, world, x, y, w, h)
    self.type = 'platform'
    x = x or 0
    y = y or 0
    w = w or 100
    h = h or 50
    self.body = love.physics.newBody(world, x, y, 0, 0)
    self.shape = love.physics.newRectangleShape(self.body, 0, 0, w, h)
    self.shape:setData(self)
    self.sprite=nil
end)

function M:draw()
    love.graphics.setColor(72, 160, 14)
    love.graphics.polygon("fill", self.shape:getPoints())
end

return M


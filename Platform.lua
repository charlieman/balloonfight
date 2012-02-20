require 'class'

-- Platform
--
-- @world love.physics.world The World
-- @x int x center position
-- @y int y center position
-- @w int width
-- @h int height
-- @visible bool visibility
local M=class(function(self, world, x, y, w, h, visible)
    self.type = 'platform'
    x = x or 0
    y = y or 0
    w = w or 100
    h = h or 50
    self.body = love.physics.newBody(world, x, y, 0, 0)
    self.shape = love.physics.newRectangleShape(self.body, 0, 0, w, h)
    self.shape:setData(self)
    self.sprite=nil
    self.visible = visible ~= false --default is true
end)

function M:draw()
    if self.visible then
        love.graphics.setColor(72, 160, 14)
        love.graphics.polygon("fill", self.shape:getPoints())
    end
end

return M


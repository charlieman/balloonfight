require 'class'

local Bug=class(function(self, world)
    self.type = 'bug'
    self.balloons=1
    self.lifes=1
    self.body=love.physics.newBody(world, 640/2, 480/2, 15, 0)
    self.shape=love.physics.newRectangleShape(self.body, 0, 0, 16, 24)
    --self.shape=love.physics.newCircleShape(self.body, 0, 0, 20)
    self.shape:setData(self)
    self.points=0
    self.lastFlap=0
    self.groundVelocity = 30
    self.inGround = false
    self.sideForce = 120
    self.upForce = {}
    self.upForce[0.1] = -200
    self.upForce[0.4] = -500
    self.upForce[0.7] = -700
    self.shadow = 0
end)

-- setShadow
-- where should we draw the copy of the bug, set to 0 to disable
--
-- @position int distance in x from the Bug
function Bug:setShadow(position)
    self.shadow = position
end

function Bug:draw()
    love.graphics.setColor(193, 47, 14)
    love.graphics.polygon("fill", self.shape:getPoints())

    if self.shadow ~= 0 then
        local x1, y1, x2, y2, x3, y3, x4, y4 = self.shape:getPoints()
        x1 = x1 + self.shadow
        x2 = x2 + self.shadow
        x3 = x3 + self.shadow
        x4 = x4 + self.shadow
        love.graphics.polygon("fill",x1, y1, x2, y2, x3, y3, x4, y4)
    end
end

return Bug


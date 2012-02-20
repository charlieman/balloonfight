require 'class'

local M=class(function(self, world)
    self.type = 'bug'
    self.balloons=1
    self.lifes=1
    self.body=love.physics.newBody(world, 640/2, 480/2, 15, 0)
    self.shape=love.physics.newCircleShape(self.body, 0, 0, 20)
    self.shape:setData(self)
    self.sprite=nil
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
function M:setShadow(position)
    self.shadow = position
end

function M:draw()
    love.graphics.setColor(193, 47, 14)
    love.graphics.circle(
        "fill", 
        self.body:getX(),
        self.body:getY(),
        self.shape:getRadius(),
        20
    )

    if self.shadow ~= 0 then
        love.graphics.circle(
            "fill", 
            self.body:getX() + self.shadow,
            self.body:getY(),
            self.shape:getRadius(),
            20
        )
    end
end

return M


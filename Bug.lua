require 'class'

local Bug=class(function(self, world)
    self.type = 'bug'
    self.balloons=1
    self.lifes=1
    self.body=love.physics.newBody(world, 640/2, 480/2, 15, 0)
    self.shape=love.physics.newRectangleShape(self.body, 0, 0, 16, 24)
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
end)

function Bug:draw()
    love.graphics.setColor(193, 47, 14)
    love.graphics.circle(
        "fill", 
        self.body:getX(),
        self.body:getY(),
        self.shape:getRadius(),
        20
    )
end

return Bug


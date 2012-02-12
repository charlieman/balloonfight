require 'class'

local M=class(function(self, world)
  self.balloons=1
  self.lifes=1
  self.body=love.physics.newBody(world, 640/2, 480/2, 15, 0)
  self.shape=love.physics.newCircleShape(self.body, 0, 0, 20)
  self.sprite=sprite
  self.points=0
  self.lastFlap=0
  self.shape:setData('bug')
  self.groundVelocity = 30
  self.inGround = false
end)

function M:draw()
    love.graphics.setColor(193, 47, 14)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius(), 20)
end

return M


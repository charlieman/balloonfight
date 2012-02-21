require 'class'

local Bug=class(function(self, world)
    self.type = 'bug'
    self.balloons=1
    self.lifes=1
    self.body=love.physics.newBody(world, 640/2, 480/2, 15, 0)
    --self.shape=love.physics.newRectangleShape(self.body, 0, 0, 16, 24)
    self.shape=love.physics.newCircleShape(self.body, 0, 0, 20)
    self.shape:setData(self)
    self.points = 0
    self.lastFlap = 0
    self.autoflapTime = 0.5
    self.autoflapForce = -700
    self.groundVelocity = 30
    self.inGround = false
    self.sideForce = 120
    self.upForce = {}
    self.upForce[0.7] = -700 --order from large to small
    self.upForce[0.4] = -500
    self.upForce[0.1] = -200
    self.shadow = 0
end)

function Bug:autoflap()
    local time = love.timer.getTime()
    local elapsedTime = time - self.lastFlap

    if elapsedTime > self.autoflapTime then
        self:_flap(self.autoflapForce)
        self.lastFlap = time
    end
end

function Bug:flap()
    local time = love.timer.getTime()
    local elapsedTime = time - self.lastFlap

    for keyTime, force in pairs(self.upForce) do
        if elapsedTime > keyTime then
            self:_flap(force)
            self.lastFlap = time
            break
        end
    end
end

function Bug:_flap(upForce)
    local sideForce = 0
    --TODO: shouldn't use the global controls since it makes
    --the other bug move as well
    if love.keyboard.isDown(controls.right) then
        sideForce = self.sideForce
    elseif love.keyboard.isDown(controls.left) then
        sideForce = -self.sideForce
    end

    self.body:applyForce(sideForce, upForce)
end

-- setShadow
-- where should we draw the copy of the bug, set to 0 to disable
--
-- @position int distance in x from the Bug
function Bug:setShadow(position)
    self.shadow = position
end

-- returns top, right, bottom, left
function Bug:getShadowPoints()
    local x1, y1, x2, y2, x3, y3, x4, y4 = self.shape:getBoundingBox()
    x1 = x1 + self.shadow
    x2 = x2 + self.shadow
    x3 = x3 + self.shadow
    x4 = x4 + self.shadow
    return {x1, y1, x2, y2, x3, y3, x4, y4}
end

function Bug:draw()
    love.graphics.setColor(193, 47, 14)
    love.graphics.polygon("fill", self.shape:getBoundingBox())

    if self.shadow ~= 0 then
        love.graphics.polygon("fill", self:getShadowPoints())
    end
end

return Bug


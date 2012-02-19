require 'class'
Bug=require 'Bug'

local Player=class(Bug, function(self, world)
    Bug.init(self, world)
    self.image = love.graphics.newImage('player.png')
end)

function Player:draw()
    local tilew = 16
    local tileh = 24
    local tileQuads = {}
    tileQuads[0] = love.graphics.newQuad(0 * tilew, 0 * tileh, tilew, tileh, self.image:getWidth(), self.image:getHeight())
    tileQuads[1] = love.graphics.newQuad(1 * tilew, 0 * tileh, tilew, tileh, self.image:getWidth(), self.image:getHeight())
    tileQuads[2] = love.graphics.newQuad(2 * tilew, 0 * tileh, tilew, tileh, self.image:getWidth(), self.image:getHeight())
    tileQuads[3] = love.graphics.newQuad(3 * tilew, 0 * tileh, tilew, tileh, self.image:getWidth(), self.image:getHeight())
    
    local spriteBatch = love.graphics.newSpriteBatch(self.image, 4)
    
    spriteBatch:clear()
--    for x=0, 4 do
    spriteBatch:addq(tileQuads[0], self.body:getX()-8, self.body:getY()-12)
--    end
    love.graphics.draw(spriteBatch)
end

return Player


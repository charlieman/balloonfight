Debug = require 'Debug'
Player = require 'Player'
Platform = require 'Platform'

conf = {}
conf.gravity = 32
conf.meterScale = 200 -- 30 pixels = 1 meter

controls = {}
controls.flap = 'z'
controls.left = 'left'
controls.right = 'right'

function love.load()
    world = love.physics.newWorld(0, 0, 1024, 600)
    world:setGravity(0, conf.gravity)
    world:setMeter(conf.meterScale) -- default
    world:setCallbacks(add, persist, rem, result)

    objects = {}

    objects.ground = {
        Platform(world, 150, 560, 300, 60),
        Platform(world, 1024-150, 550, 300, 60),
        Platform(world, 512, 400, 300, 20),
    }

    objects.bug = Player(world)
    objects.bug2 = Player(world)
    objects.bug2.body:setX(640/3)
    
    love.graphics.setBackgroundColor(104, 136, 248)
    --love.graphics.setMode(1024, 768, false, true, 0)
    
    debug = Debug('info')
end

function love.update(dt)
    world:update(dt)
--    objects.bubble.body:applyForce(0,-15)
    if objects.bug.inGround then
        if love.keyboard.isDown(controls.right) then
            objects.bug.body:applyForce(objects.bug.groundVelocity, 0)
        elseif love.keyboard.isDown(controls.left) then
            objects.bug.body:applyForce(-objects.bug.groundVelocity, 0)
        end
    end
end

function love.draw()
    for i, g in pairs(objects.ground) do
        g:draw()
    end
    
    objects.bug:draw()
    objects.bug2:draw()
    
    love.graphics.print(string.format("fps: %s", love.timer.getFPS()), 0, 0)
    debug:draw()
end

function flap()
    local time = love.timer.getTime()
    elapsedTime = time - objects.bug.lastFlap

    local upForce = 0
    for keyTime, force in pairs(objects.bug.upForce) do
        if elapsedTime > keyTime then
            upForce = force
        else
            break
        end
    end

    if upForce ~= 0 then
        if love.keyboard.isDown(controls.right) then
            objects.bug.body:applyForce(objects.bug.sideForce, 0)
        elseif love.keyboard.isDown(controls.left) then
            objects.bug.body:applyForce(-objects.bug.sideForce, 0)
        end

        objects.bug.body:applyForce(0, upForce)
        objects.bug.lastFlap = time
    end
end

function love.keypressed(k)
    if k=='escape' or k=='q' then
        love.event.push('q')
    elseif k == controls.flap then
        flap()
    end
  --if k=='d' then DEBUG=not DEBUG end
end

function add(a, b, coll)
    if a:is_a(Platform) and b:is_a(Bug) then
        b.inGround = true
        debug:info('add collision ' .. a.type .. ' : ' .. b.type)
    end
end

function persist(a, b, coll)
    
end

function rem(a, b, coll)
    if a:is_a(Platform) and b:is_a(Bug) then
        b.inGround = false
        debug:info('rem collision ' .. a.type .. ' : ' .. b.type)
    end
end

function result(a, b, coll)
    
end

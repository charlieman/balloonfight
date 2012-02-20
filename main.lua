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
    world = love.physics.newWorld(-100, -100, 1124, 700)
    world:setGravity(0, conf.gravity)
    world:setMeter(conf.meterScale) -- default
    world:setCallbacks(add, persist, rem, result)

    objects = {}

    objects.ground = {
        Platform(world, 150, 560, 300, 40),
        Platform(world, 1024-150, 560, 300, 40),
        Platform(world, 512, 400, 300, 20),
    }
    objects.invisible_walls = {
        Platform(world, 612, -50, 1024, 100, false),
        Platform(world, 612, 650, 1024, 100, false),
    }

    objects.bug = Player(world)
    objects.bug2 = Player(world)
    objects.bug2.body:setX(640/3)
    objects.bugs = {objects.bug, objects.bug2}
    
    love.graphics.setBackgroundColor(104, 136, 248)
    --love.graphics.setMode(1024, 768, false, true, 0)
    
    debug = Debug('info')
end

function love.update(dt)

    for i, bug in pairs(objects.bugs) do
        if bug.body:getX() < 0 then
            bug.body:setX(1024)
        elseif bug.body:getX() > 1024 then
            bug.body:setX(0)
        end
    end

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
    
    --for i, g in pairs(objects.invisible_walls) do
    --    g:draw()
    --end
    
    for i, g in pairs(objects.bugs) do
        g:draw()
    end
    
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
    debug:info(a.type .. ' started touching ' .. b.type)
    if a:is_a(Platform) and b:is_a(Bug) then
        x, y = coll:getNormal()
        -- on top: x = 0, y = -200
        -- on right: x = 200, y = 0
        -- on left: x = -200, y = 0
        if x == 0 then
            --todo instead of cheking x==0,
            --check the cotang of x/y and see if 135 > angle > 45
            b.inGround = true
            debug:info('ball in ground')
        elseif y == 0 then
            b.body:applyForce(x * 3, 0)
        end
        debug:info(x .. ':' .. y)
    end
end

function persist(a, b, coll)
    
end

function rem(a, b, coll)
    if a:is_a(Platform) and b:is_a(Bug) then
        x, y = coll:getNormal()
        if x == 0 then
            b.inGround = false
            debug:info('ball left ground')
        end
    end
end

function result(a, b, coll)
    debug:info('result callback called')
end

Player=require 'Player'

conf = {}
conf.gravity = 320
conf.sideForce = 800
conf.upForce = {}
conf.upForce[0.1] = -2000
conf.upForce[0.4] = -5000
conf.upForce[0.7] = -7000

controls = {}
controls.flap = 'z'
controls.left = 'left'
controls.right = 'right'

function love.load()
    world = love.physics.newWorld(0,0,640,480)
    world:setGravity(0, conf.gravity)
    world:setMeter(64)

    objects = {}

    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, 640/2, 440, 0, 0)
    objects.ground.shape = love.physics.newRectangleShape(objects.ground.body, 0, 0, 480, 80)

    objects.bug1 = Player(world)
    objects.bug2 = Player(world)
    objects.bug2.body:setX(640/3)
    
    love.graphics.setBackgroundColor(104, 136, 248)
    love.graphics.setMode(640, 480, false, true, 0)
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    love.graphics.setColor(72, 160, 14)
    love.graphics.polygon("fill", objects.ground.shape:getPoints())
    
    objects.bug1:draw()
    objects.bug2:draw()
    
    love.graphics.print(string.format("fps: %s", love.timer.getFPS()), 0, 0)
end

function flap()
    local time = love.timer.getTime()
    elapsedTime = time - objects.bug1.lastFlap

    local upForce = 0
    for keyTime, force in pairs(conf.upForce) do
        if elapsedTime > keyTime then
            upForce = force
        else
            break
        end
    end

    if upForce ~= 0 then
        if love.keyboard.isDown(controls.right) then
            objects.bug1.body:applyForce(conf.sideForce, 0)
        elseif love.keyboard.isDown(controls.left) then
            objects.bug1.body:applyForce(-conf.sideForce, 0)
        end

        objects.bug1.body:applyForce(0, upForce)
        objects.bug1.lastFlap = time
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


Player=require 'Player'

conf = {}
conf.gravity = 32
conf.sideForce = 120
conf.upForce = {}
conf.upForce[0.1] = -200
conf.upForce[0.4] = -500
conf.upForce[0.7] = -700
conf.meterScale = 200 -- 30 pixels = 1 meter

controls = {}
controls.flap = 'z'
controls.left = 'left'
controls.right = 'right'

function love.load()
    world = love.physics.newWorld(0, 0, 1024, 768)
    world:setGravity(0, conf.gravity)
    world:setMeter(conf.meterScale) -- default
    world:setCallbacks(add, persist, rem, result)

    objects = {}

    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, 1024/2, 768, 0, 0)
    objects.ground.shape = love.physics.newRectangleShape(objects.ground.body, 0, 0, 768, 80)
    objects.ground.shape:setData("ground")

    objects.bug1 = Player(world)
    objects.bug2 = Player(world)
    objects.bug2.body:setX(640/3)
    
    love.graphics.setBackgroundColor(104, 136, 248)
    love.graphics.setMode(1024, 768, false, true, 0)
end

function love.update(dt)
    world:update(dt)
    objects.bubble.body:applyForce(0,-15)
    if objects.ball.inGround then
        if love.keyboard.isDown(controls.right) then
            objects.ball.body:applyForce(objects.ball.groundVelocity, 0)
        elseif love.keyboard.isDown(controls.left) then
            objects.ball.body:applyForce(-objects.ball.groundVelocity, 0)
        end
    end
end

function love.draw()
    love.graphics.setColor(72, 160, 14)
    love.graphics.polygon("fill", objects.ground.shape:getPoints())
    
    objects.bug1:draw()
    objects.bug2:draw()
    
    love.graphics.print(string.format("fps: %s", love.timer.getFPS()), 0, 0)
    love.graphics.print(text, 0, 15)
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

function add(a, b, coll)
    if a == "ground" and b == "ball" then
        objects.ball.inGround = true
        text = text.. "add " .. a .. " : " .. b .. "\n"
    end
end

function persist(a, b, coll)
    
end

function rem(a, b, coll)
    if a == "ground" and b == "ball" then
        objects.ball.inGround = false
        text = text.. "rem " .. a .. " : " .. b .. "\n"
    end
end

function result(a, b, coll)
    
end

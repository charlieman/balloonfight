
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

    objects.ball = {}
    objects.ball.body = love.physics.newBody(world, 1024/2, 768/2, 15, 0)
    objects.ball.shape = love.physics.newCircleShape(objects.ball.body, 0, 0, 20.5)
    objects.ball.lastFlap = 0
    objects.ball.shape:setData("ball")
    objects.ball.groundVelocity = 30
    objects.ball.inGround = false

    objects.bubble = {}
    objects.bubble.body = love.physics.newBody(world, 1024/2, 768/2, 0.1, 0)
    objects.bubble.shape = love.physics.newCircleShape(objects.ball.body, 0, 0, 20)
    objects.bubble.shape:setData("bubble")

    elapsedTime = 0
    text = ""


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
    
    love.graphics.setColor(193, 47, 14)
    love.graphics.circle(
        "fill", 
        objects.ball.body:getX(),
        objects.ball.body:getY(),
        objects.ball.shape:getRadius(), 20
    )

    love.graphics.setColor(47, 47, 140)
    love.graphics.circle(
        "line", 
        objects.bubble.body:getX(),
        objects.bubble.body:getY(),
        objects.bubble.shape:getRadius(), 20
    )

    love.graphics.print(string.format("elapsedTime: %s", elapsedTime), 0, 0)
    love.graphics.print(text, 0, 15)
end

function flap()
    local time = love.timer.getTime()
    elapsedTime = time - objects.ball.lastFlap

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
            objects.ball.body:applyForce(conf.sideForce, 0)
        elseif love.keyboard.isDown(controls.left) then
            objects.ball.body:applyForce(-conf.sideForce, 0)
        end

        objects.ball.body:applyForce(0, upForce)
        objects.ball.lastFlap = time
    end
end

function love.keypressed(k)
    if k=='escape' then
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

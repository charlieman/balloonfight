
function love.load()
    world = love.physics.newWorld(0,0,640,480)
    world:setGravity(0, 300)
    world:setMeter(64)

    objects = {}

    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, 640/2, 440, 0, 0)
    objects.ground.shape = love.physics.newRectangleShape(objects.ground.body, 0, 0, 480, 80)

    objects.ball = {}
    objects.ball.body = love.physics.newBody(world, 640/2, 480/2, 15, 0)
    objects.ball.shape = love.physics.newCircleShape(objects.ball.body, 0, 0, 20)
    objects.ball.lastFlap = 0
    elapsedTime = 0

    love.graphics.setBackgroundColor(104, 136, 248)
    love.graphics.setMode(640, 480, false, true, 0)
end

function love.update(dt)
    world:update(dt)
    if love.keyboard.isDown("right") then
        objects.ball.body:applyForce(400, 0)
    elseif love.keyboard.isDown("left") then
        objects.ball.body:applyForce(-400, 0)
    elseif love.keyboard.isDown("up") then
        --objects.ball.body:setY(480/2)
        objects.ball.body:applyForce(0, -400)
    elseif love.keyboard.isDown("l") then
        objects.ball.body:applyForce(200, 0)
    elseif love.keyboard.isDown("j") then
        objects.ball.body:applyForce(-200, 0)
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
    love.graphics.print(string.format("elapsedTime: %s", elapsedTime), 0, 0)
end

function flap()
    local time = love.timer.getTime()
    elapsedTime = time - objects.ball.lastFlap
    if elapsedTime > 0.1 then
        upForce = -2000
        if elapsedTime > 0.4 then
            upForce = -5000
        elseif elapsedTime > 0.7 then
            upForce = -8000
        end
        objects.ball.body:applyForce(0, upForce)
        objects.ball.lastFlap = time
    end
end

function love.keypressed(k)
    if k=='escape' then
        love.event.push('q')
    elseif k == 'k' then
        flap()
    end
  --if k=='d' then DEBUG=not DEBUG end
end


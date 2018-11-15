function love.load()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81*64, true)

    objects = {}

    local groundWidth = 650
    local groundHeight = 50
    local groundX = 0
    local groundY = 600

    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, groundX + groundWidth/2, groundY + groundHeight/2)
    objects.ground.shape = love.physics.newRectangleShape(groundWidth, groundHeight)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

    print()
    --initial graphics setup
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue
    love.window.setMode(650, 650) --set the window dimensions to 650 by 650
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    love.graphics.setColor(0.28, 0.63, 0.05) 
    love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf(objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())[1], 10, 10, 200)
end
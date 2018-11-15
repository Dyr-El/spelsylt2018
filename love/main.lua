local ll = require "level_loader"


function loadImages()
    imageLib = {}
    imageLib.hashImg = love.graphics.newImage("images/hash.png")
    imageLib.robotImg = love.graphics.newImage("images/robot.png")
    return imageLib
end

function setupLevel(theWorld, theLevel)
    for _, floor in pairs(theLevel.floors) do
        x1, y1, x2, y2 = floor[1], floor[2], floor[3], floor[4]
        print(x1, y1, x2, y2)
        floorBody = love.physics.newBody(theWorld, x1 + (x2-x1)/2, y1 + (y2-y1)/2, "static")
        floorShape = love.physics.newRectangleShape(x2-x1, y2-y1)
        fixture = love.physics.newFixture(floorBody, floorShape)
        print("Floor x,y = ", floorBody:getX(), floorBody:getY())
    end
    do
        local x = theLevel.robot.coords[1]
        local y = theLevel.robot.coords[2]
        local body = love.physics.newBody(theWorld, x+16, y+16, "dynamic")
        theLevel.robot.body = body
        local shape = love.physics.newRectangleShape(32, 32)
        theLevel.robot.fixture = love.physics.newFixture(body, shape)
        theLevel.robot.fixture:setRestitution(0.9)
        print("Robot x,y = ", body:getX(), body:getY())
        print("Mass data ",theLevel.robot.fixture:getMassData( ))
    end
end

function love.load()
    lvls = ll.loadLevels()
    imgs = loadImages()
    lvl = 1
    theWorld = love.physics.newWorld(0, 9.81)
    setupLevel(theWorld, lvls[lvl])
end
 
function love.update(dt)
    theWorld:update(dt)
    --print(lvls[lvl].robot.body:getX(), lvls[lvl].robot.body:getY())
    if love.keyboard.isDown("q") then
        love.event.quit(0)
    end
    if love.keyboard.isDown("d") then
        lvls[lvl].robot.body:applyForce(100, 0)
    end
    if love.keyboard.isDown("a") then
        lvls[lvl].robot.body:applyForce(-100, 0)
    end
end
 
function drawFloor(floor, xoffset, yoffset)
    x1, y1, x2, y2 = floor[1], floor[2], floor[3], floor[4]
    for x = x1, x2-1, 16 do
        love.graphics.draw(imgs.hashImg, x + xoffset, y2 + yoffset)
    end
end

function drawRobot(robot, xoffset, yoffset)
    local x = lvls[lvl].robot.body:getX()
    local y = lvls[lvl].robot.body:getY()
    love.graphics.draw(imgs.robotImg, x + xoffset, y + yoffset)
end

function love.draw()
    theLvl = lvls[lvl]
    xOffset = (love.graphics.getWidth() - theLvl.dimX*16) / 2
    yOffset = 32
    for _, floor in pairs(theLvl.floors) do
        drawFloor(floor, xOffset, yOffset)
    end
    drawRobot(theLvl.robot, xOffset, yOffset)
end
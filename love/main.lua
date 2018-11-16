local ll = require "level_loader"
local bump = require "lib.bump"

function loadImages()
    imageLib = {}
    imageLib.hashImg = love.graphics.newImage("images/hash.png")
    imageLib.robotImg = love.graphics.newImage("images/robot.png")
    return imageLib
end

function setupLevel(theWorld, theLevel)
    for _, floor in pairs(theLevel.floors) do
        x, y = floor.x, floor.y
        theWorld:add(floor, x, y, 16, 16)
    end
    do
        local x = theLevel.robot.x
        local y = theLevel.robot.y
        theWorld:add(theLevel.robot, x, y, 32, 32)
    end
end

function love.load()
    lvls = ll.loadLevels()
    imgs = loadImages()
    lvl = 1
    theWorld = bump.newWorld(64)
    setupLevel(theWorld, lvls[lvl])
    font = love.graphics.newFont(12)
    posText = love.graphics.newText(font)
    spdText = love.graphics.newText(font)
end

function updateRobotSpeed(robot, dt)
    if robot.vx > 0 then
        robot.vx = math.max(robot.vx - 300*dt, 0)
    elseif robot.vx < 0 then
        robot.vx = math.min(robot.vx + 300*dt, 0)
    end
    if not checkRobotOnSomething(robot) then
        robot.vy = robot.vy + 500*dt
    else
        robot.vy = 0
    end
end

function checkRobotOnSomething(robot)
    local actX, actY, cols, len = theWorld:check(robot, robot.x, robot.y+1)
    return len > 0
end

function updateRobotPos(robot, dt)
    local goalX = robot.x + robot.vx*dt
    local goalY = robot.y + robot.vy*dt
    local actX, actY, cols, len = theWorld:move(robot, goalX, goalY)
    robot.x, robot.y = actX, actY
end
 
function love.update(dt)
    local robot = lvls[lvl].robot
    if love.keyboard.isDown("q") then
        love.event.quit(0)
    end
    updateRobotSpeed(lvls[lvl].robot, dt)
    if love.keyboard.isDown("d") then
        robot.vx = math.min(robot.vx + 1000*dt, 100)
    end
    if love.keyboard.isDown("a") then
        robot.vx = math.max(robot.vx - 1000*dt, -100)
    end
    if love.keyboard.isDown("w") then
        if checkRobotOnSomething(robot) then
            robot.vy = -150
        end
    end
    updateRobotPos(robot, dt)
end
 
function drawFloor(floor, xoffset, yoffset)
    love.graphics.draw(imgs.hashImg, floor.x + xoffset, floor.y + yoffset)
end

function drawRobot(robot, xoffset, yoffset)
    local x = robot.x + xoffset
    local y = robot.y + yoffset
    love.graphics.draw(imgs.robotImg, x, y)
end

function drawRobotDebugData(robot)
    if checkRobotOnSomething(robot) then
        s = "_"
    else
        s = " "
    end
    posText:set(string.format( "(%6.3f, %6.3f)",robot.x, robot.y))
    spdText:set(string.format( "(%6.3f, %6.3f)%s",robot.vx, robot.vy, s))
    love.graphics.draw(posText, 10, 10)
    love.graphics.draw(spdText, 10, 30)
end

function love.draw()
    theLvl = lvls[lvl]
    xOffset = (love.graphics.getWidth() - theLvl.dimX*16) / 2
    yOffset = 32
    for _, floor in pairs(theLvl.floors) do
        drawFloor(floor, xOffset, yOffset)
    end
    drawRobot(theLvl.robot, xOffset, yOffset)
    drawRobotDebugData(theLvl.robot)
end
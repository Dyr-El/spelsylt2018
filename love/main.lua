local ll = require "level_loader"
local bump = require "lib.bump"
local staticobj = require "staticobj"
local dynamicobj = require "dynamicobj"

function loadImages()
    local imageLib = {}
    imageLib.hashImg = love.graphics.newImage("images/hash.png")
    imageLib.robotImg = love.graphics.newImage("images/robot.png")
    imageLib.gateImg = love.graphics.newImage("images/gate.png")
    return imageLib
end

staticObjects = {}
dynamicObjects = {}

function setupLevel(theWorld, theLevel, images)
    for _, floor in pairs(theLevel.floors) do
        local floorTile = staticobj:new({x=floor.x, y=floor.y,
                                         image=images.hashImg})
        floorTile:addTo(theWorld)
        staticObjects[#staticObjects + 1] = floorTile
    end
    do
        local robot = dynamicobj:new({x=theLevel.robot.x, y=theLevel.robot.y,
                                      image=images.robotImg})
        robot:addTo(theWorld)
        dynamicObjects.robot = robot
    end
    do
        local gate = staticobj:new({x=theLevel.gate.x, y=theLevel.gate.y,
                                    image=images.gateImg, ethereal=true,
                                    gate=true})
        gate:addTo(theWorld)
        staticObjects[#staticObjects + 1] = gate
    end
end

function love.load()
    lvls = ll.loadLevels()
    local images = loadImages()
    imgs = images
    lvl = 1
    theWorld = bump.newWorld(64)
    setupLevel(theWorld, lvls[lvl], images)
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
    if not robot:checkOn() then
        robot.vy = robot.vy + 500*dt
    else
        robot.vy = 0
    end
end

function updateRobotPos(robot, dt)
    local goalX = robot.x + robot.vx*dt
    local goalY = robot.y + robot.vy*dt
    local actX, actY, cols, len = theWorld:move(robot, goalX, goalY, dynamicobj.filter)
    for _, col in pairs(cols) do
        if col.other.gate then
            levelWon = true
            for k,v in pairs(col) do
                print(k, v)
            end
        end
    end
    robot.x, robot.y = actX, actY
end

commandQueue = {{5, "d"}, {1.5, "dw"}, {1, ""}, {5, "d"}, {1.5, "dw"}, pos=1}
function updateCommands(robot, dt)
    cmd = commandQueue[commandQueue.pos]
    if cmd then
        cmd[1] = cmd[1] - dt
        if cmd[1] <= 0 then
            cmd[1] = 0
            commandQueue.pos = commandQueue.pos + 1
        end
        return cmd[2]
    else
        return ""
    end
end

function love.update(dt)
    local robot = dynamicObjects.robot
    if love.keyboard.isDown("q") or levelWon then
        love.event.quit(0)
    end
    updateRobotSpeed(robot, dt)
    key = updateCommands(robot, dt)
    if key:find("d") then
        robot.vx = math.min(robot.vx + 1000*dt, 100)
    end
    if key:find("a") then
        robot.vx = math.max(robot.vx - 1000*dt, -100)
    end
    if key:find("w") then
        if robot:checkOn() then
            robot.vy = -200
        end
    end
    updateRobotPos(robot, dt)
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
    local theLvl = lvls[lvl]
    local xOffset = (love.graphics.getWidth() - theLvl.dimX*16) / 2
    local yOffset = 32
    for _, obj in pairs(staticObjects) do
        obj:draw(xOffset, yOffset)
    end
    for _, obj in pairs(dynamicObjects) do
        obj:draw(xOffset, yOffset)
    end
end
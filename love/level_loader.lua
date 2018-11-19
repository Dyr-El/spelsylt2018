level_loader = {}

function loadIndex()
    levels = {}
    if love.filesystem.getInfo("levels/index.txt") then
        f = love.filesystem.newFile("levels/index.txt", "r")
        for line in f:lines() do
            levels[#levels + 1] = line
        end
        f:close()
    else
        print("Error: levels/index.txt not found!")
    end
    return levels
end

function loadChars(fileName, level)
    f = love.filesystem.newFile(fileName, "r")
    local y = 0
    local maxX = 0
    local maxY = 0
    for line in f:lines() do
        local x = 0
        for c in line:gmatch(".") do
            if c ~= " " then
                if not level[y] then
                    level[y] = {}
                end
                level[y][x] = c
            end
            x = x + 1
            maxX = math.max(x, maxX)
        end
        y = y + 1
        maxY = math.max(y, maxY)
    end
    level.dimY = maxY
    level.dimX = maxX
end

function loadLevel(fileName)
    local level = {}
    fileName = "levels/"..fileName
    if love.filesystem.getInfo(fileName) then
        loadChars(fileName, level)
        return level
    end
    return nil
end

function parseHash(lvl, x, y)
    lvl[y][x] = " "
    floor = {}
    floor.x = x*16
    floor.y = (y-1)*16
    floor.objType = "floor"
    lvl.floors[#(lvl.floors)+1] = floor
end

function parseRobot(lvl, x, y)
    lvl.robot.x = x*16
    lvl.robot.y = (y-2)*16
    lvl.robot.id = tonumber(lvl[y][x+1])
    lvl.robot.vx = 0
    lvl.robot.vy = 0
    lvl.robot.jump = false
    lvl.robot.objType = "robot"
    lvl[y  ][x  ] = " "
    lvl[y  ][x+1] = " "
    lvl[y-1][x  ] = " "
    lvl[y-1][x+1] = " "
end

function parseGate(lvl, x, y)
    lvl.gate.x = x*16
    lvl.gate.y = (y-2)*16
    lvl.gate.id = tonumber(lvl[y][x+1])
    lvl.gate.vx = 0
    lvl.gate.vy = 0
    lvl.gate.jump = false
    lvl.gate.objType = "gate"
    lvl[y  ][x  ] = " "
    lvl[y  ][x+1] = " "
    lvl[y-1][x  ] = " "
    lvl[y-1][x+1] = " "
end

levelParsers = {
    ["#"]=parseHash,
    ["R"]=parseRobot,
    ["@"]=parseGate
}

function parseLevel(lvl)
    lvl.floors = {}
    lvl.robot = {}
    lvl.gate = {}
    for y = lvl.dimY, 0, -1 do
        for x = 0, lvl.dimX, 1 do
            ch = lvl[y] and lvl[y][x]
            if ch and (ch ~= " ") then
                for k, f in pairs(levelParsers) do
                    if ch == k then
                        f(lvl, x, y)
                    end
                end
            end
        end
    end
end

function level_loader.loadLevels()
    index = loadIndex()
    levels = {}
    for key,val in pairs(index) do
        levels[key] = loadLevel(val)
        if levels[key] ~= nil then
            parseLevel(levels[key])
        else
            print("Failed to load level: "..key.." ["..val.."]")
        end
    end
    return levels
end

return level_loader
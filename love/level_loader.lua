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

function loadLevel(fileName)
    local level = {}
    local maxX = 0
    local maxY = 0
    fileName = "levels/"..fileName
    if love.filesystem.getInfo(fileName) then
        f = love.filesystem.newFile(fileName, "r")
        local y = 0
        for line in f:lines() do
            local x = 0
            for c in line:gmatch(".") do
                if c ~= " " then
                    -- print("{"..x..","..y.."}<-'"..c.."'")
                    level[{x, y}] = c
                end
                x = x + 1
                maxX = math.max(x, maxX)
            end
            y = y + 1
            maxY = math.max(y, maxY)
        end
        level.dimY = maxY
        level.dimX = maxX
        return level
    end
    return nil
end

function level_loader.loadLevels()
    index = loadIndex()
    levels = {}
    for key,val in pairs(index) do
        levels[key] = loadLevel(val)
        if levels[key] ~= nil then
            print(""..key..":"..levels[key].dimX.."x"..levels[key].dimY)
        else
            print("Failed to load level: "..key.." ["..val.."]")
        end
    end
    return levels
end

return level_loader
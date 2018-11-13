local ll = require "level_loader"

function loadImages()
    imageLib = {}
    imageLib.hashImg = love.graphics.newImage("images/hash.png")
    imageLib.robotImg = love.graphics.newImage("images/robot.png")
    return imageLib
end

function love.load()
    lvls = ll.loadLevels()
    imgs = loadImages()
    lvl = 1
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
    if love.keyboard.isDown("q") then
        love.event.quit(0)
    end
end
 
function love.draw()
    theLvl = lvls[lvl]
    xOffset = (love.graphics.getWidth() - theLvl.dimX*16) / 2
    yOffset = 32
    for coord, c in pairs(theLvl) do
        if type(coord) == "table" then
            if c == "#" then
                local x = xOffset + coord[1]*16
                local y = yOffset + coord[2]*16
                love.graphics.draw(imgs.hashImg, x, y)
            end
            if c == "R" then
                local x = xOffset + coord[1]*16 - 16
                local y = yOffset + coord[2]*16 - 16
                love.graphics.draw(imgs.robotImg, x, y)
            end
        end
    end
end
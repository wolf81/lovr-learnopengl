package.path = './../../../../?.lua;' .. package.path

io.stdout:setvbuf('no')

local Timer = require 'lib.hump.timer'

local Tutorial = require 'tutorial'

local success = lovr.filesystem.mount('../../../../obj', '/obj')

local tutorial = Tutorial() 

function lovr.update(dt)
    tutorial:update(dt)

    Timer.update(dt)
end

function lovr.draw(pass)
    tutorial:draw(pass)
end

function lovr.keypressed(key)
    if key == 'escape' then
        lovr.event.quit()
    end
end

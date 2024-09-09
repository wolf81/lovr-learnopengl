-- import camera module
local Camera = require 'Camera'

-- create new instance
local camera = Camera(0, 1.7, 0)

function lovr.update(dt)
    -- update camera transform based on speed, time
    camera:update(dt)
end

function lovr.draw(pass)
    -- draw using the camera
    camera:draw(pass, function() 
        pass:setColor(0xff0000)
        pass:cube(0, 1.7, -3, .5, lovr.timer.getTime())
        pass:setColor(0xffffff)
        pass:plane(0, 0, 0, 10, 10, math.pi / 2, 1, 0, 0)
    end)
end

function lovr.keypressed(key)
    if key == 'escape' then
        lovr.event.quit()
    end
end

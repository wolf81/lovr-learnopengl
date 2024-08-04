local Camera = require 'lib.lovr-camera.camera'

local gammaToLinear = lovr.math.gammaToLinear

local lightingShader = lovr.graphics.newShader('shader/1.colors.vs', 'shader/1.colors.fs')
local lightCubeShader = lovr.graphics.newShader('shader/1.light_cube.vs', 'shader/1.light_cube.fs')

local camera = Camera()

function lovr.load()
    camera:init()
end

function lovr.update(dt)
    camera:update(dt)
end

function lovr.draw(pass) 
    camera:draw(pass, function() 
        pass:setClear(gammaToLinear(0.1, 0.1, 0.1, 1.0))

        -- draw the cube
        pass:setShader(lightingShader)
        pass:send('objectColor', gammaToLinear(1.0, 0.5, 0.31))
        pass:send('lightColor', gammaToLinear(1.0, 1.0, 1.0))
        pass:cube(1.0, 1.0, 1.0)

        -- draw the lamp object
        pass:setShader(lightCubeShader)
        pass:cube(1.2, 1.0, 2.0, 0.2)
    end)
end

function lovr.keypressed(key)
    if key == 'escape' then
        lovr.event.quit()
    end
end

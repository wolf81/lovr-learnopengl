local Camera = require 'lib.lovr-camera.camera'

local gammaToLinear = lovr.math.gammaToLinear

local lightingShader = lovr.graphics.newShader('shader/basic_lighting.vs', 'shader/basic_lighting.fs')
local lightCubeShader = lovr.graphics.newShader('shader/light_cube.vs', 'shader/light_cube.fs')

-- TODO: fix positioning to be in line with C++ code
local lightPos = lovr.math.newVec3(1.2, 1.0, 2.0)

local camera = Camera()

function lovr.load()
    camera:init()
end

function lovr.update(dt)
    camera:update(dt)
end

function lovr.draw(pass) 
    pass:setColor(gammaToLinear(0.1, 0.1, 0.1, 1.0))
    
    camera:draw(pass, function() 
        -- draw the cube
        pass:setShader(lightingShader)
        pass:send('objectColor', gammaToLinear(1.0, 0.5, 0.31))
        pass:send('lightColor', gammaToLinear(1.0, 1.0, 1.0))
        pass:send('lightPos', lightPos)
        pass:cube()

        -- draw the lamp object
        pass:setShader(lightCubeShader)
        pass:cube(lightPos, 0.2)
    end)
end

function lovr.keypressed(key)
    if key == 'escape' then
        lovr.event.quit()
    end
end

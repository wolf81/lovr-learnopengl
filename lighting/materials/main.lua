local Camera = require 'lib.lovr-camera.camera'

local gammaToLinear = lovr.math.gammaToLinear

local lightingShader = lovr.graphics.newShader('shader/materials.vs', 'shader/materials.fs')
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
    local time = lovr.timer.getTime()
    local r, g, b = math.sin(time * 2.0), math.sin(time * 0.7), math.sin(time * 1.3)

    camera:draw(pass, function() 
        pass:setClear(gammaToLinear(0.1, 0.1, 0.1, 1.0))

        -- draw the cube
        pass:setShader(lightingShader)
        pass:send('lightAmbient', gammaToLinear(r * 0.2, g * 0.2, b * 0.2))
        pass:send('lightDiffuse', gammaToLinear(r * 0.5, g * 0.5, b * 0.5))
        pass:send('lightSpecular', gammaToLinear(1.0, 1.0, 1.0))
        pass:send('lightPosition', lightPos)

        pass:send('matAmbient', gammaToLinear(1.0, 0.5, 0.31))
        pass:send('matDiffuse', gammaToLinear(1.0, 0.5, 0.31))
        pass:send('matSpecular', gammaToLinear(0.5, 0.5, 0.5))
        pass:send('matShininess', 32.0)

        pass:cube(1.0, 1.0, 1.0)

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

local Camera = require 'lib.lovr-camera.camera'

local gammaToLinear = lovr.math.gammaToLinear

local lightingShader = lovr.graphics.newShader('shader/1.colors.vs', 'shader/1.colors.fs')
local lightCubeShader = lovr.graphics.newShader('shader/1.light_cube.vs', 'shader/1.light_cube.fs')

local lightPos = lovr.math.newVec3(1.2, 1.0, 2.0)

local vertices = { 
    { -0.5, -0.5, -0.5,  },
    {  0.5, -0.5, -0.5,  },
    {  0.5,  0.5, -0.5,  },
    {  0.5,  0.5, -0.5,  },
    { -0.5,  0.5, -0.5,  },
    { -0.5, -0.5, -0.5,  },

    { -0.5, -0.5,  0.5,  },
    {  0.5, -0.5,  0.5,  },
    {  0.5,  0.5,  0.5,  },
    {  0.5,  0.5,  0.5,  },
    { -0.5,  0.5,  0.5,  },
    { -0.5, -0.5,  0.5,  },

    { -0.5,  0.5,  0.5,  },
    { -0.5,  0.5, -0.5,  },
    { -0.5, -0.5, -0.5,  },
    { -0.5, -0.5, -0.5,  },
    { -0.5, -0.5,  0.5,  },
    { -0.5,  0.5,  0.5,  },

    {  0.5,  0.5,  0.5,  },
    {  0.5,  0.5, -0.5,  },
    {  0.5, -0.5, -0.5,  },
    {  0.5, -0.5, -0.5,  },
    {  0.5, -0.5,  0.5,  },
    {  0.5,  0.5,  0.5,  },

    { -0.5, -0.5, -0.5,  },
    {  0.5, -0.5, -0.5,  },
    {  0.5, -0.5,  0.5,  },
    {  0.5, -0.5,  0.5,  },
    { -0.5, -0.5,  0.5,  },
    { -0.5, -0.5, -0.5,  },

    { -0.5,  0.5, -0.5,  },
    {  0.5,  0.5, -0.5,  },
    {  0.5,  0.5,  0.5,  },
    {  0.5,  0.5,  0.5,  },
    { -0.5,  0.5,  0.5,  },
    { -0.5,  0.5, -0.5,  },
}
local mesh = lovr.graphics.newMesh(vertices)

local camera = Camera()

function lovr.load()
    camera:init()
end

function lovr.update(dt)
    camera:update(dt)
end

function lovr.draw(pass) 
    pass:setClear(0.1, 0.1, 0.1, 1.0)

    camera:draw(pass, function() 
        -- draw the cube
        pass:setShader(lightingShader)
        pass:send('objectColor', gammaToLinear(1.0, 0.5, 0.31))
        pass:send('lightColor', gammaToLinear(1.0, 1.0, 1.0))
        pass:draw(mesh)

        -- transform
        local model = lovr.math.mat4(1.0)
        model:translate(lightPos)
        model:scale(0.2)
        pass:transform(model)

        -- draw the lamp object
        pass:setShader(lightCubeShader)
        pass:draw(mesh)
    end)
end

function lovr.keypressed(key)
    if key == 'escape' then
        lovr.event.quit()
    end
end

local Camera = require 'lib.lovr-camera.camera'

local gammaToLinear = lovr.math.gammaToLinear

local Tutorial = {}

Tutorial.new = function()
    local light_pos = Vec3(1.2, 1.0, 2.0)

    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local lighting_shader = lovr.graphics.newShader(
        shd_dir .. 'colors.vs', 
        shd_dir .. 'colors.fs')
    local lightcube_shader = lovr.graphics.newShader(
        shd_dir .. 'light_cube.vs', 
        shd_dir .. 'light_cube.fs')

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

    local camera = Camera(0, 0, 3)
    camera:init()

    local draw = function(self, pass)
        pass:setClear(0.1, 0.1, 0.1, 1.0)

        camera:draw(pass, function() 
            -- draw the cube
            pass:setShader(lighting_shader)
            pass:send('objectColor', gammaToLinear(1.0, 0.5, 0.31))
            pass:send('lightColor', gammaToLinear(1.0, 1.0, 1.0))
            pass:draw(mesh)

            -- transform
            local model = mat4(1.0)
            model:translate(light_pos)
            model:scale(0.2)
            pass:transform(model)

            -- draw the lamp object
            pass:setShader(lightcube_shader)
            pass:draw(mesh)
        end)
    end

    local update = function(self, dt)
        camera:update(dt)
    end
    
    return setmetatable({
        -- methods
        draw    = draw,
        update  = update,
    }, Tutorial)
end

return setmetatable(Tutorial, {
    __call = function(_, ...) return Tutorial.new(...) end,
})

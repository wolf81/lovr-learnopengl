local Camera = require 'lib.lovr-camera.camera'

local Tutorial = {}

Tutorial.new = function()        
    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local shader_red = lovr.graphics.newShader(
        shd_dir .. 'advanced_glsl.vs', 
        shd_dir .. 'red.fs')

    local shader_green = lovr.graphics.newShader(
        shd_dir .. 'advanced_glsl.vs', 
        shd_dir .. 'green.fs')

    local shader_blue = lovr.graphics.newShader(
        shd_dir .. 'advanced_glsl.vs', 
        shd_dir .. 'blue.fs')

    local shader_yellow = lovr.graphics.newShader(
        shd_dir .. 'advanced_glsl.vs', 
        shd_dir .. 'yellow.fs')

    local cube_vertices = { 
        { -0.5, -0.5, -0.5  },
        {  0.5, -0.5, -0.5  },
        {  0.5,  0.5, -0.5  },
        {  0.5,  0.5, -0.5  },
        { -0.5,  0.5, -0.5  },
        { -0.5, -0.5, -0.5  },

        { -0.5, -0.5,  0.5  },
        {  0.5, -0.5,  0.5  },
        {  0.5,  0.5,  0.5  },
        {  0.5,  0.5,  0.5  },
        { -0.5,  0.5,  0.5  },
        { -0.5, -0.5,  0.5  },

        { -0.5,  0.5,  0.5  },
        { -0.5,  0.5, -0.5  },
        { -0.5, -0.5, -0.5  },
        { -0.5, -0.5, -0.5  },
        { -0.5, -0.5,  0.5  },
        { -0.5,  0.5,  0.5  },

        {  0.5,  0.5,  0.5  },
        {  0.5,  0.5, -0.5  },
        {  0.5, -0.5, -0.5  },
        {  0.5, -0.5, -0.5  },
        {  0.5, -0.5,  0.5  },
        {  0.5,  0.5,  0.5  },

        { -0.5, -0.5, -0.5  },
        {  0.5, -0.5, -0.5  },
        {  0.5, -0.5,  0.5  },
        {  0.5, -0.5,  0.5  },
        { -0.5, -0.5,  0.5  },
        { -0.5, -0.5, -0.5  },

        { -0.5,  0.5, -0.5  },
        {  0.5,  0.5, -0.5  },
        {  0.5,  0.5,  0.5  },
        {  0.5,  0.5,  0.5  },
        { -0.5,  0.5,  0.5  },
        { -0.5,  0.5, -0.5  },
    }
    local cube = lovr.graphics.newMesh(cube_vertices)

    -- TODO: this example doesn't really do anything interesting in LOVR
    -- to improve the tutorial, we should make a shared buffer that e.g.
    -- adds a color to mix for every shader

    local camera = Camera(0, 0, 3)

    local draw = function(self, pass)
        pass:setClear(0.1, 0.1, 0.1, 1.0)        

        camera:draw(pass, function() 
            pass:setShader(shader_red)
            local model = mat4()
            model:translate(-0.75, 0.75, 0.0)
            pass:draw(cube, model)

            pass:setShader(shader_green)
            model = mat4()
            model:translate(0.75, 0.75, 0.0)
            pass:draw(cube, model)

            pass:setShader(shader_blue)
            model = mat4()
            model:translate(-0.75, -0.75, 0.0)
            pass:draw(cube, model)

            pass:setShader(shader_yellow)
            model = mat4()
            model:translate(0.75, -0.75, 0.0)
            pass:draw(cube, model)

        end)
    end

    local update = function(self, dt)
        camera:update(dt)
    end

    local leave = function(self, to)
        camera:deinit()
    end

    return setmetatable({
        -- methods
        draw    = draw,
        leave   = leave,
        update  = update,
    }, Tutorial)
end

return setmetatable(Tutorial, {
    __call = function(_, ...) return Tutorial.new(...) end,
})

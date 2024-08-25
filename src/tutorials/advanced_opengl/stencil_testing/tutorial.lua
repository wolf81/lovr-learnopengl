local Camera = require 'lib.lovr-camera.camera'

local Tutorial = {}

Tutorial.new = function()
    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local shader = lovr.graphics.newShader(
        shd_dir .. 'stencil_testing.vs', 
        shd_dir .. 'stencil_testing.fs')

    local shader_single_color = lovr.graphics.newShader(
        shd_dir .. 'stencil_testing.vs',
        shd_dir .. 'stencil_single_color.fs')

    --    positions            tex coords
    local cube_vertices = {
        -- face 1
        { -0.5, -0.5, -0.5  ;  0.0,  0.0  },
        {  0.5, -0.5, -0.5  ;  1.0,  0.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  1.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  1.0  },
        { -0.5,  0.5, -0.5  ;  0.0,  1.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  0.0  },
        -- face 2
        { -0.5, -0.5,  0.5  ;  0.0,  0.0  },
        {  0.5, -0.5,  0.5  ;  1.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  1.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  1.0  },
        { -0.5,  0.5,  0.5  ;  0.0,  1.0  },
        { -0.5, -0.5,  0.5  ;  0.0,  0.0  },
        -- face 3
        { -0.5,  0.5,  0.5  ;  1.0,  0.0  },
        { -0.5,  0.5, -0.5  ;  1.0,  1.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  1.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  1.0  },
        { -0.5, -0.5,  0.5  ;  0.0,  0.0  },
        { -0.5,  0.5,  0.5  ;  1.0,  0.0  },
        -- face 4
        {  0.5,  0.5,  0.5  ;  1.0,  0.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  1.0  },
        {  0.5, -0.5, -0.5  ;  0.0,  1.0  },
        {  0.5, -0.5, -0.5  ;  0.0,  1.0  },
        {  0.5, -0.5,  0.5  ;  0.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  0.0  },
        -- face 5
        { -0.5, -0.5, -0.5  ;  0.0,  1.0  },
        {  0.5, -0.5, -0.5  ;  1.0,  1.0  },
        {  0.5, -0.5,  0.5  ;  1.0,  0.0  },
        {  0.5, -0.5,  0.5  ;  1.0,  0.0  },
        { -0.5, -0.5,  0.5  ;  0.0,  0.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  1.0  },
        -- face 6
        { -0.5,  0.5, -0.5  ;  0.0,  1.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  1.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  0.0  },
        { -0.5,  0.5,  0.5  ;  0.0,  0.0  },
        { -0.5,  0.5, -0.5  ;  0.0,  1.0  },
    }

    local plane_vertices = {
    --     positions           tex coords
        {  5.0, -0.5,  5.0  ;  2.0, 0.0  },
        { -5.0, -0.5,  5.0  ;  0.0, 0.0  },
        { -5.0, -0.5, -5.0  ;  0.0, 2.0  },

        {  5.0, -0.5,  5.0  ;  2.0, 0.0  },
        { -5.0, -0.5, -5.0  ;  0.0, 2.0  },
        {  5.0, -0.5, -5.0  ;  2.0, 2.0  },
    }

    local cube = lovr.graphics.newMesh({ 
        { 'VertexPosition', 'vec3' }, 
        { 'VertexUV',       'vec2' },
    }, cube_vertices)

    local plane = lovr.graphics.newMesh({
        { 'VertexPosition', 'vec3' }, 
        { 'VertexUV',       'vec2' }, 
    }, plane_vertices)

    local cube_texture = lovr.graphics.newTexture('gfx/marble.jpg')
    local floor_texture = lovr.graphics.newTexture('gfx/metal.png')    

    local camera = Camera(0, 0, 3)
    camera:init()

    local draw = function(self, pass)
        pass:setClear(0.1, 0.1, 0.1, 1.0)

        pass:setDepthTest('gequal')

        camera:draw(pass, function() 
            pass:setShader(shader_single_color)

            pass:setStencilWrite('zero')

            pass:setShader(shader)
            pass:send('texture1', floor_texture)

            model = mat4(1.0)
            pass:draw(plane, model)

            pass:setStencilWrite('replace', 1, 0xFF)
            pass:setStencilTest('none', 1, 0xFF)

            pass:send('texture1', cube_texture)
            local model = mat4(1.0)
            model:translate(-1.0, 0.0, -1.0)
            pass:draw(cube, model)

            model = mat4(1.0)
            model:translate(2.0, 0.0, 0.0)
            pass:draw(cube, model)

            pass:setStencilWrite('zero')
            pass:setStencilTest('notequal', 1, 0xFF)
            pass:setDepthTest()

            pass:setShader(shader_single_color)

            local scale = 1.1

            model = model:identity()
            model:translate(-1.0, 0.0, -1.0)
            model:scale(scale, scale)
            pass:draw(cube, model)

            model = mat4(1.0)
            model:translate(2.0, 0.0, 0.0)
            model:scale(scale, scale)
            pass:draw(cube, model)

            pass:setStencilWrite()

            pass:setShader(shader)
        end)

        pass:setDepthTest('gequal')        
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

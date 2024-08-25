local Camera = require 'lib.lovr-camera.camera'

local Tutorial = {}

Tutorial.new = function()        
    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local shader = lovr.graphics.newShader(
        shd_dir .. 'blending.vs', 
        shd_dir .. 'blending.fs')

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

    --     positions           tex coords
    local transparent_vertices = {
        {  0.0,  0.5,  0.0  ;  0.0,  0.0  },
        {  0.0, -0.5,  0.0  ;  0.0,  1.0  },
        {  1.0, -0.5,  0.0  ;  1.0,  1.0  },

        {  0.0,  0.5,  0.0  ;  0.0,  0.0  },
        {  1.0, -0.5,  0.0  ;  1.0,  1.0  },
        {  1.0,  0.5,  0.0  ;  1.0,  0.0  },
    }

    local cube = lovr.graphics.newMesh({ 
        { 'VertexPosition', 'vec3' }, 
        { 'VertexUV',       'vec2' },
    }, cube_vertices)

    local plane = lovr.graphics.newMesh({
        { 'VertexPosition', 'vec3' }, 
        { 'VertexUV',       'vec2' }, 
    }, plane_vertices)

    local transparent = lovr.graphics.newMesh({
        { 'VertexPosition', 'vec3' }, 
        { 'VertexUV',       'vec2' },         
    }, transparent_vertices)

    local cube_texture = lovr.graphics.newTexture('gfx/marble.jpg')
    local floor_texture = lovr.graphics.newTexture('gfx/metal.png')    
    local transparent_texture = lovr.graphics.newTexture('gfx/window.png')

    local windows = {
        Vec3(-1.5,  0.0,  0.48),
        Vec3( 1.5,  0.0,  0.51),
        Vec3( 0.0,  0.0,  0.7),
        Vec3(-0.3,  0.0, -2.3),
        Vec3( 0.5,  0.0, -0.6),
    }

    local camera = Camera(0, 0, 3)
    camera:init()

    local draw = function(self, pass)
        pass:setClear(0.1, 0.1, 0.1, 1.0)

        table.sort(windows, function(a, b) 
            local d1 = a:distance(camera:getPosition())
            local d2 = b:distance(camera:getPosition())
            return d2 < d1
        end)

        camera:draw(pass, function() 
            pass:setShader(shader)

            pass:send('texture1', cube_texture)
            local model = mat4(1.0)
            model:translate(-1.0, 0.0, -1.0)
            pass:draw(cube, model)

            pass:send('texture1', floor_texture)
            model = mat4(1.0)
            pass:draw(plane, model)

            pass:send('texture1', transparent_texture)
            for _, coord in ipairs(windows) do
                model = mat4(1.0)
                model:translate(coord)
                pass:draw(transparent, model)
            end
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

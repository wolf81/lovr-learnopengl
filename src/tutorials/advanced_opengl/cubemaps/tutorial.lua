local Camera = require 'lib.lovr-camera.camera'

local Tutorial = {}

Tutorial.new = function()        
    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local shader = lovr.graphics.newShader(
        shd_dir .. 'cubemaps.vs', 
        shd_dir .. 'cubemaps.fs')

    --     positions           normals          
    local vertices = {
        -- face 1
        { -0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  },
        {  0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  },
        {  0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  },
        {  0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  },
        { -0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  },
        -- face 2
        { -0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  },
        {  0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  },
        {  0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  },
        {  0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  },
        { -0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  },
        { -0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  },
        -- face 3
        { -0.5,  0.5,  0.5  ; -1.0,  0.0,  0.0  },
        { -0.5,  0.5, -0.5  ; -1.0,  0.0,  0.0  },
        { -0.5, -0.5, -0.5  ; -1.0,  0.0,  0.0  },
        { -0.5, -0.5, -0.5  ; -1.0,  0.0,  0.0  },
        { -0.5, -0.5,  0.5  ; -1.0,  0.0,  0.0  },
        { -0.5,  0.5,  0.5  ; -1.0,  0.0,  0.0  },
        -- face 4
        {  0.5,  0.5,  0.5  ;  1.0,  0.0,  0.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  0.0,  0.0  },
        {  0.5, -0.5, -0.5  ;  1.0,  0.0,  0.0  },
        {  0.5, -0.5, -0.5  ;  1.0,  0.0,  0.0  },
        {  0.5, -0.5,  0.5  ;  1.0,  0.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  0.0,  0.0  },
        -- face 5
        { -0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  },
        {  0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  },
        {  0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  },
        {  0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  },
        { -0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  },
        { -0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  },
        -- face 6
        { -0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  },
        {  0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  },
        { -0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  },
        { -0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  },
    }

    local mesh = lovr.graphics.newMesh({
        { name = 'VertexPosition', type = 'vec3' },
        { name = 'VertexNormal', type = 'vec2' },
    }, vertices, 'gpu')

    local skybox = lovr.graphics.newTexture({
        right = 'gfx/skybox/left.jpg',
        left = 'gfx/skybox/right.jpg',
        top = 'gfx/skybox/top.jpg',
        bottom = 'gfx/skybox/bottom.jpg',
        front = 'gfx/skybox/front.jpg',
        back = 'gfx/skybox/back.jpg',
    })

    local camera = Camera(0, 0, 3)
    camera:init()

    local draw = function(self, pass)
        pass:setClear(0.1, 0.1, 0.1, 1.0)

        camera:draw(pass, function() 
            pass:skybox(skybox)

            pass:setShader(shader)

            pass:send('skybox', skybox)

            local transform = lovr.math.mat4(1.0)
            transform:translate(0.5, -0.5, 0.0)
            pass:transform(transform)

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

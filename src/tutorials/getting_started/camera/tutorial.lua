local Camera = require 'lib.lovr-camera.camera'

local Tutorial = {}

Tutorial.new = function()
    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local shader = lovr.graphics.newShader(
        shd_dir .. 'camera.vs', 
        shd_dir .. 'camera.fs')

    --     positions           tex coords
    local vertices = {
        -- face 1
        { -0.5, -0.5, -0.5  ;  0.0, 0.0  },
        {  0.5, -0.5, -0.5  ;  1.0, 0.0  },
        {  0.5,  0.5, -0.5  ;  1.0, 1.0  },
        {  0.5,  0.5, -0.5  ;  1.0, 1.0  },
        { -0.5,  0.5, -0.5  ;  0.0, 1.0  },
        { -0.5, -0.5, -0.5  ;  0.0, 0.0  },
        -- face 2
        { -0.5, -0.5,  0.5  ;  0.0, 0.0  },
        {  0.5, -0.5,  0.5  ;  1.0, 0.0  },
        {  0.5,  0.5,  0.5  ;  1.0, 1.0  },
        {  0.5,  0.5,  0.5  ;  1.0, 1.0  },
        { -0.5,  0.5,  0.5  ;  0.0, 1.0  },
        { -0.5, -0.5,  0.5  ;  0.0, 0.0  },
        -- face 3
        { -0.5,  0.5,  0.5  ;  1.0, 0.0  },
        { -0.5,  0.5, -0.5  ;  1.0, 1.0  },
        { -0.5, -0.5, -0.5  ;  0.0, 1.0  },
        { -0.5, -0.5, -0.5  ;  0.0, 1.0  },
        { -0.5, -0.5,  0.5  ;  0.0, 0.0  },
        { -0.5,  0.5,  0.5  ;  1.0, 0.0  },
        -- face 4
        {  0.5,  0.5,  0.5  ;  1.0, 0.0  },
        {  0.5,  0.5, -0.5  ;  1.0, 1.0  },
        {  0.5, -0.5, -0.5  ;  0.0, 1.0  },
        {  0.5, -0.5, -0.5  ;  0.0, 1.0  },
        {  0.5, -0.5,  0.5  ;  0.0, 0.0  },
        {  0.5,  0.5,  0.5  ;  1.0, 0.0  },
        -- face 5
        { -0.5, -0.5, -0.5  ;  0.0, 1.0  },
        {  0.5, -0.5, -0.5  ;  1.0, 1.0  },
        {  0.5, -0.5,  0.5  ;  1.0, 0.0  },
        {  0.5, -0.5,  0.5  ;  1.0, 0.0  },
        { -0.5, -0.5,  0.5  ;  0.0, 0.0  },
        { -0.5, -0.5, -0.5  ;  0.0, 1.0  },
        -- face 6
        { -0.5,  0.5, -0.5  ;  0.0, 1.0  },
        {  0.5,  0.5, -0.5  ;  1.0, 1.0  },
        {  0.5,  0.5,  0.5  ;  1.0, 0.0  },
        {  0.5,  0.5,  0.5  ;  1.0, 0.0  },
        { -0.5,  0.5,  0.5  ;  0.0, 0.0  },
        { -0.5,  0.5, -0.5  ;  0.0, 1.0  },
    }

    local mesh = lovr.graphics.newMesh({
        { 'VertexPosition', 'vec3' },
        { 'VertexUV', 'vec2' },
    }, vertices)

    local cube_positions = {
        Vec3( 0.0,  0.0,   0.0),
        Vec3( 2.0,  5.0, -15.0),
        Vec3(-1.5, -2.2,  -2.5),
        Vec3(-3.8, -2.0, -12.3),
        Vec3( 2.4, -0.4,  -3.5),
        Vec3(-1.7,  3.0,  -7.5),
        Vec3( 1.3, -2.0,  -2.5),
        Vec3( 1.5,  2.0,  -2.5),
        Vec3( 1.5,  0.2,  -1.5),
        Vec3(-1.3,  1.0,  -1.5),
    }

    local texture1 = lovr.graphics.newTexture('gfx/container.jpg')
    local texture2 = lovr.graphics.newTexture('gfx/awesomeface.png')    

    local camera = Camera(0, 0, 3)
    camera:init()

    local draw = function(self, pass)
        pass:setClear(0.2, 0.3, 0.3, 1.0)

        camera:draw(pass, function() 
            pass:setShader(shader)

            pass:send('texture1', texture1)
            pass:send('texture2', texture2)

            -- render boxes
            for idx, position in ipairs(cube_positions) do
                local model = mat4(1.0)
                model:translate(position)
                local angle = (idx - 1) * 20
                model:rotate(math.rad(angle), 1.0, 0.3, 0.5)

                pass:draw(mesh, model)
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

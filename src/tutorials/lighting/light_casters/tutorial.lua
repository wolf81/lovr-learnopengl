local Camera = require 'lib.lovr-camera.camera'

-- PLEASE NOTE: this function is used to make colors appear same as in LearnOpenGL tutorial apps
local gammaToLinear = lovr.math.gammaToLinear

local Tutorial = {}

Tutorial.new = function()
    local light_pos = Vec3(1.2, 1.0, 2.0)

    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local lighting_shader = lovr.graphics.newShader(
        shd_dir .. 'light_casters.vs', 
        shd_dir .. 'light_casters.fs')
    local format, length = lighting_shader:getBufferFormat('LightCaster')

    --     positions           normals            tex coords
    local vertices = {
        -- face 1
        { -0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  ;  0.0, 0.0,  },
        {  0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  ;  1.0, 0.0,  },
        {  0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  ;  1.0, 1.0,  },
        {  0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  ;  1.0, 1.0,  },
        { -0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  ;  0.0, 1.0,  },
        { -0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  ;  0.0, 0.0,  },
        -- face 2
        { -0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  ;  0.0, 0.0,  },
        {  0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  ;  1.0, 0.0,  },
        {  0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  ;  1.0, 1.0,  },
        {  0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  ;  1.0, 1.0,  },
        { -0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  ;  0.0, 1.0,  },
        { -0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  ;  0.0, 0.0,  },
        -- face 3
        { -0.5,  0.5,  0.5  ; -1.0,  0.0,  0.0  ;  1.0, 0.0,  },
        { -0.5,  0.5, -0.5  ; -1.0,  0.0,  0.0  ;  1.0, 1.0,  },
        { -0.5, -0.5, -0.5  ; -1.0,  0.0,  0.0  ;  0.0, 1.0,  },
        { -0.5, -0.5, -0.5  ; -1.0,  0.0,  0.0  ;  0.0, 1.0,  },
        { -0.5, -0.5,  0.5  ; -1.0,  0.0,  0.0  ;  0.0, 0.0,  },
        { -0.5,  0.5,  0.5  ; -1.0,  0.0,  0.0  ;  1.0, 0.0,  },
        -- face 4
        {  0.5,  0.5,  0.5  ;  1.0,  0.0,  0.0  ;  1.0, 0.0,  },
        {  0.5,  0.5, -0.5  ;  1.0,  0.0,  0.0  ;  1.0, 1.0,  },
        {  0.5, -0.5, -0.5  ;  1.0,  0.0,  0.0  ;  0.0, 1.0,  },
        {  0.5, -0.5, -0.5  ;  1.0,  0.0,  0.0  ;  0.0, 1.0,  },
        {  0.5, -0.5,  0.5  ;  1.0,  0.0,  0.0  ;  0.0, 0.0,  },
        {  0.5,  0.5,  0.5  ;  1.0,  0.0,  0.0  ;  1.0, 0.0,  },
        -- face 5
        { -0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  ;  0.0, 1.0,  },
        {  0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  ;  1.0, 1.0,  },
        {  0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  ;  1.0, 0.0,  },
        {  0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  ;  1.0, 0.0,  },
        { -0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  ;  0.0, 0.0,  },
        { -0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  ;  0.0, 1.0,  },
        -- face 6
        { -0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  ;  0.0, 1.0,  },
        {  0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  ;  1.0, 1.0,  },
        {  0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  ;  1.0, 0.0,  },
        {  0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  ;  1.0, 0.0,  },
        { -0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  ;  0.0, 0.0,  },
        { -0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  ;  0.0, 1.0,  },
    }

    local mesh = lovr.graphics.newMesh(vertices, 'gpu')

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

    local diffuse_map = lovr.graphics.newTexture('gfx/container2.png')
    local specular_map = lovr.graphics.newTexture('gfx/container2_specular.png')    

    local camera = Camera(0, 0, 3)

    local draw = function(self, pass)
        pass:setClear(0.1, 0.1, 0.1, 1.0)

        camera:draw(pass, function()
            -- activate shader for drawing cube
            pass:setShader(lighting_shader)

            -- material properties 
            -- PLEASE NOTE: can likely use Material object instead with some shader modifications
            pass:send('matShininess', 32.0)
            pass:send('matDiffuse', diffuse_map)
            pass:send('matSpecular', specular_map)

            local light = lovr.graphics.newBuffer(format, {
                position    = camera:getPosition(),
                direction   = camera:getDirection(),
                ambient     = { 0.1, 0.1, 0.1 },
                diffuse     = { 0.8, 0.8, 0.8 },
                specular    = { 1.0, 1.0, 1.0 },
                constant    = 1.0,
                linear      = 0.09,
                quadratic   = 0.032,
                cutOff      = math.cos(math.rad(12.5)),
                outerCutOff = math.cos(math.rad(15.0)),        
            })

            pass:send('LightCaster', light)

            -- render
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

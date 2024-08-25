local Camera = require 'lib.lovr-camera.camera'

-- PLEASE NOTE: this function is used to make colors appear same as in LearnOpenGL tutorial apps
local gammaToLinear = lovr.math.gammaToLinear

local Tutorial = {}

Tutorial.new = function()
    local lightPos = Vec3(1.2, 1.0, 2.0)

    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local lighting_shader = lovr.graphics.newShader(
        shd_dir .. 'multiple_lights.vs', 
        shd_dir .. 'multiple_lights.fs')
    local lightcube_shader = lovr.graphics.newShader(
        shd_dir .. 'light_cube.vs', 
        shd_dir .. 'light_cube.fs')

    local lighting_shader_format = lighting_shader:getBufferFormat('Lights')
    -- we need to set layout to ensure data is properly padded
    lighting_shader_format.layout = 'std140'

    --    positions            normals             tex coords
    local vertices = {
        -- face 1
        { -0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  ;  0.0,  0.0  },
        {  0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  ;  1.0,  0.0  },
        {  0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  ;  1.0,  1.0  },
        {  0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  ;  1.0,  1.0  },
        { -0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  ;  0.0,  1.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  ;  0.0,  0.0  },
        -- face 2
        { -0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  ;  0.0,  0.0  },
        {  0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  ;  1.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  ;  1.0,  1.0  },
        {  0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  ;  1.0,  1.0  },
        { -0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  ;  0.0,  1.0  },
        { -0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  ;  0.0,  0.0  },
        -- face 3
        { -0.5,  0.5,  0.5  ; -1.0,  0.0,  0.0  ;  1.0,  0.0  },
        { -0.5,  0.5, -0.5  ; -1.0,  0.0,  0.0  ;  1.0,  1.0  },
        { -0.5, -0.5, -0.5  ; -1.0,  0.0,  0.0  ;  0.0,  1.0  },
        { -0.5, -0.5, -0.5  ; -1.0,  0.0,  0.0  ;  0.0,  1.0  },
        { -0.5, -0.5,  0.5  ; -1.0,  0.0,  0.0  ;  0.0,  0.0  },
        { -0.5,  0.5,  0.5  ; -1.0,  0.0,  0.0  ;  1.0,  0.0  },
        -- face 4
        {  0.5,  0.5,  0.5  ;  1.0,  0.0,  0.0  ;  1.0,  0.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  0.0,  0.0  ;  1.0,  1.0  },
        {  0.5, -0.5, -0.5  ;  1.0,  0.0,  0.0  ;  0.0,  1.0  },
        {  0.5, -0.5, -0.5  ;  1.0,  0.0,  0.0  ;  0.0,  1.0  },
        {  0.5, -0.5,  0.5  ;  1.0,  0.0,  0.0  ;  0.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  0.0,  0.0  ;  1.0,  0.0  },
        -- face 5
        { -0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  ;  0.0,  1.0  },
        {  0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  ;  1.0,  1.0  },
        {  0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  ;  1.0,  0.0  },
        {  0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  ;  1.0,  0.0  },
        { -0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  ;  0.0,  0.0  },
        { -0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  ;  0.0,  1.0  },
        -- face 6
        { -0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  ;  0.0,  1.0  },
        {  0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  ;  1.0,  1.0  },
        {  0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  ;  1.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  ;  1.0,  0.0  },
        { -0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  ;  0.0,  0.0  },
        { -0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  ;  0.0,  1.0  },
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

    local point_light_positions = {
        Vec3( 0.7,  0.2,   2.0),
        Vec3( 2.3, -3.3,  -4.0),
        Vec3(-4.0,  2.0, -12.0),
        Vec3( 0.0,  0.0,  -3.0),
    }

    local diffuse_map = lovr.graphics.newTexture('gfx/container2.png')
    local specular_map = lovr.graphics.newTexture('gfx/container2_specular.png')

    local dir_light = {
        ambient     = {  0.05, 0.05, 0.05 },
        diffuse     = {  0.4,  0.4,  0.4  },
        specular    = {  0.5,  0.5,  0.5  },
        direction   = { -0.2, -1.0, -0.3  },
    }

    local point_lights = {
        {
            ambient     = {  0.05, 0.05,  0.05 },
            diffuse     = {  0.8,  0.8,   0.8  },
            specular    = {  1.0,  1.0,   1.0  },
            position    = {  0.7,  0.2,   2.0  },
            constant    = 1.0,
            linear      = 0.09,
            quadratic   = 0.032,            
        },
        {
            ambient     = {  0.05, 0.05,  0.05 },
            diffuse     = {  0.8,  0.8,   0.8  },
            specular    = {  1.0,  1.0,   1.0  },
            position    = { -4.0,  2.0, -12.0  },
            constant    = 1.0,
            linear      = 0.09,
            quadratic   = 0.032,            
        },
        {
            ambient     = {  0.05, 0.05,  0.05 },
            diffuse     = {  0.8,  0.8,   0.8  },
            specular    = {  1.0,  1.0,   1.0  },
            position    = {  0.0,  0.0,  -3.0  },
            constant    = 1.0,
            linear      = 0.09,
            quadratic   = 0.032,            
        },
        {
            ambient     = {  0.05, 0.05,  0.05 },
            diffuse     = {  0.8,  0.8,   0.8  },
            specular    = {  1.0,  1.0,   1.0  },
            position    = {  0.7,  0.2,   2.0  },
            constant    = 1.0,
            linear      = 0.09,
            quadratic   = 0.032,            
        },
    }

    local camera = Camera(0, 0, 3)
    camera:init()

    local draw = function(self, pass)
        pass:setClear(0.1, 0.1, 0.1, 1.0)

        camera:draw(pass, function()
            pass:setShader(lighting_shader)

            local lights = lovr.graphics.newBuffer(lighting_shader_format, {
                pointLights = point_lights,
                dirLight    = dir_light,
                spotLight   = {
                    ambient     = { 0.0, 0.0, 0.0 },
                    diffuse     = { 1.0, 1.0, 1.0 },
                    specular    = { 1.0, 1.0, 1.0 },
                    position    = camera:getPosition(),
                    direction   = camera:getDirection(),
                    constant    = 1.0,
                    linear      = 0.09,
                    quadratic   = 0.032,
                    cutOff      = math.cos(math.rad(12.5)),
                    outerCutOff = math.cos(math.rad(15.0)),        
                },
            })

            pass:send('Lights', lights)

            -- material properties 
            -- PLEASE NOTE: can likely use Material object instead with some shader modifications
            pass:send('matShininess', 32.0)
            pass:send('matDiffuse', diffuse_map)
            pass:send('matSpecular', specular_map)

            -- render boxes
            for idx, position in ipairs(cube_positions) do
                local model = mat4(1.0)
                model:translate(position)
                local angle = (idx - 1) * 20
                model:rotate(math.rad(angle), 1.0, 0.3, 0.5)

                pass:draw(mesh, model)
            end

            -- activate shader for drawing lamp
            pass:setShader(lightcube_shader)

            -- render light cubes
            for idx, position in ipairs(point_light_positions) do
                local model = mat4(1.0)
                model:translate(position)
                model:scale(0.2)
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

local Camera = require 'lib.lovr-camera.camera'

-- PLEASE NOTE: this function is used to make colors appear same as in LearnOpenGL tutorial apps
local gammaToLinear = lovr.math.gammaToLinear

local Tutorial = {}

Tutorial.new = function()
    local light_pos = Vec3(1.2, 1.0, 2.0)

    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local lighting_shader = lovr.graphics.newShader(
        shd_dir .. 'lighting_maps.vs', 
        shd_dir .. 'lighting_maps.fs')
    local lightcube_shader = lovr.graphics.newShader(
        shd_dir .. 'light_cube.vs', 
        shd_dir .. 'light_cube.fs')

    --    positions          normals           tex coords
    local vertices = {
        -- face 1
        { -0.5, -0.5, -0.5,  0.0,  0.0, -1.0,  0.0, 0.0, },
        {  0.5, -0.5, -0.5,  0.0,  0.0, -1.0,  1.0, 0.0, },
        {  0.5,  0.5, -0.5,  0.0,  0.0, -1.0,  1.0, 1.0, },
        {  0.5,  0.5, -0.5,  0.0,  0.0, -1.0,  1.0, 1.0, },
        { -0.5,  0.5, -0.5,  0.0,  0.0, -1.0,  0.0, 1.0, },
        { -0.5, -0.5, -0.5,  0.0,  0.0, -1.0,  0.0, 0.0, },
        -- face 2
        { -0.5, -0.5,  0.5,  0.0,  0.0, 1.0,   0.0, 0.0, },
        {  0.5, -0.5,  0.5,  0.0,  0.0, 1.0,   1.0, 0.0, },
        {  0.5,  0.5,  0.5,  0.0,  0.0, 1.0,   1.0, 1.0, },
        {  0.5,  0.5,  0.5,  0.0,  0.0, 1.0,   1.0, 1.0, },
        { -0.5,  0.5,  0.5,  0.0,  0.0, 1.0,   0.0, 1.0, },
        { -0.5, -0.5,  0.5,  0.0,  0.0, 1.0,   0.0, 0.0, },
        -- face 3
        { -0.5,  0.5,  0.5, -1.0,  0.0,  0.0,  1.0, 0.0, },
        { -0.5,  0.5, -0.5, -1.0,  0.0,  0.0,  1.0, 1.0, },
        { -0.5, -0.5, -0.5, -1.0,  0.0,  0.0,  0.0, 1.0, },
        { -0.5, -0.5, -0.5, -1.0,  0.0,  0.0,  0.0, 1.0, },
        { -0.5, -0.5,  0.5, -1.0,  0.0,  0.0,  0.0, 0.0, },
        { -0.5,  0.5,  0.5, -1.0,  0.0,  0.0,  1.0, 0.0, },
        -- face 4
        {  0.5,  0.5,  0.5,  1.0,  0.0,  0.0,  1.0, 0.0, },
        {  0.5,  0.5, -0.5,  1.0,  0.0,  0.0,  1.0, 1.0, },
        {  0.5, -0.5, -0.5,  1.0,  0.0,  0.0,  0.0, 1.0, },
        {  0.5, -0.5, -0.5,  1.0,  0.0,  0.0,  0.0, 1.0, },
        {  0.5, -0.5,  0.5,  1.0,  0.0,  0.0,  0.0, 0.0, },
        {  0.5,  0.5,  0.5,  1.0,  0.0,  0.0,  1.0, 0.0, },
        -- face 5
        { -0.5, -0.5, -0.5,  0.0, -1.0,  0.0,  0.0, 1.0, },
        {  0.5, -0.5, -0.5,  0.0, -1.0,  0.0,  1.0, 1.0, },
        {  0.5, -0.5,  0.5,  0.0, -1.0,  0.0,  1.0, 0.0, },
        {  0.5, -0.5,  0.5,  0.0, -1.0,  0.0,  1.0, 0.0, },
        { -0.5, -0.5,  0.5,  0.0, -1.0,  0.0,  0.0, 0.0, },
        { -0.5, -0.5, -0.5,  0.0, -1.0,  0.0,  0.0, 1.0, },
        -- face 6
        { -0.5,  0.5, -0.5,  0.0,  1.0,  0.0,  0.0, 1.0, },
        {  0.5,  0.5, -0.5,  0.0,  1.0,  0.0,  1.0, 1.0, },
        {  0.5,  0.5,  0.5,  0.0,  1.0,  0.0,  1.0, 0.0, },
        {  0.5,  0.5,  0.5,  0.0,  1.0,  0.0,  1.0, 0.0, },
        { -0.5,  0.5,  0.5,  0.0,  1.0,  0.0,  0.0, 0.0, },
        { -0.5,  0.5, -0.5,  0.0,  1.0,  0.0,  0.0, 1.0, },
    }

    local mesh = lovr.graphics.newMesh(vertices)

    local diffuse_map = lovr.graphics.newTexture('gfx/container2.png')
    local specular_map = lovr.graphics.newTexture('gfx/container2_specular.png')

    local camera = Camera(0, 0, 3)

    local draw = function(self, pass)
        pass:setClear(0.1, 0.1, 0.1, 1.0)

        camera:draw(pass, function()
            -- activate shader for drawing cube
            pass:setShader(lighting_shader)

            -- light properties
            pass:send('lightPosition', light_pos)
            pass:send('lightAmbient', gammaToLinear(0.2, 0.2, 0.2))
            pass:send('lightDiffuse', gammaToLinear(0.5, 0.5, 0.5))
            pass:send('lightSpecular', gammaToLinear(1.0, 1.0, 1.0))

            -- material properties 
            -- PLEASE NOTE: can likely use Material object instead with some shader modifications
            pass:send('matShininess', 64)
            pass:send('matDiffuse', diffuse_map)
            pass:send('matSpecular', specular_map)

            -- render
            pass:draw(mesh)

            -- activate shader for drawing lamp
            pass:setShader(lightCubeShader)
            pass:cube(1.2, 1.0, 2.0, 0.2)
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

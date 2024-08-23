local Camera = require 'lib.lovr-camera.camera'

local gammaToLinear = lovr.math.gammaToLinear

local Tutorial = {}

Tutorial.new = function()
    local light_pos = lovr.math.newVec3(1.2, 1.0, 2.0)

    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local lighting_shader = lovr.graphics.newShader(
        shd_dir .. 'basic_lighting.vs', 
        shd_dir .. 'basic_lighting.fs')
    local lightcube_shader = lovr.graphics.newShader(
        shd_dir .. 'light_cube.vs', 
        shd_dir .. 'light_cube.fs')

    -- PLEASE NOTE: unlike original code, we need to add normals for lighting to work correctly 
    --    positions          normals   
    local vertices = {
        -- face 1
        { -0.5, -0.5, -0.5,  0.0,  0.0, -1.0, },
        {  0.5, -0.5, -0.5,  0.0,  0.0, -1.0, },
        {  0.5,  0.5, -0.5,  0.0,  0.0, -1.0, },
        {  0.5,  0.5, -0.5,  0.0,  0.0, -1.0, },
        { -0.5,  0.5, -0.5,  0.0,  0.0, -1.0, },
        { -0.5, -0.5, -0.5,  0.0,  0.0, -1.0, },
        -- face 2
        { -0.5, -0.5,  0.5,  0.0,  0.0, 1.0,  },
        {  0.5, -0.5,  0.5,  0.0,  0.0, 1.0,  },
        {  0.5,  0.5,  0.5,  0.0,  0.0, 1.0,  },
        {  0.5,  0.5,  0.5,  0.0,  0.0, 1.0,  },
        { -0.5,  0.5,  0.5,  0.0,  0.0, 1.0,  },
        { -0.5, -0.5,  0.5,  0.0,  0.0, 1.0,  },
        -- face 3
        { -0.5,  0.5,  0.5, -1.0,  0.0,  0.0, },
        { -0.5,  0.5, -0.5, -1.0,  0.0,  0.0, },
        { -0.5, -0.5, -0.5, -1.0,  0.0,  0.0, },
        { -0.5, -0.5, -0.5, -1.0,  0.0,  0.0, },
        { -0.5, -0.5,  0.5, -1.0,  0.0,  0.0, },
        { -0.5,  0.5,  0.5, -1.0,  0.0,  0.0, },
        -- face 4
        {  0.5,  0.5,  0.5,  1.0,  0.0,  0.0, },
        {  0.5,  0.5, -0.5,  1.0,  0.0,  0.0, },
        {  0.5, -0.5, -0.5,  1.0,  0.0,  0.0, },
        {  0.5, -0.5, -0.5,  1.0,  0.0,  0.0, },
        {  0.5, -0.5,  0.5,  1.0,  0.0,  0.0, },
        {  0.5,  0.5,  0.5,  1.0,  0.0,  0.0, },
        -- face 5
        { -0.5, -0.5, -0.5,  0.0, -1.0,  0.0, },
        {  0.5, -0.5, -0.5,  0.0, -1.0,  0.0, },
        {  0.5, -0.5,  0.5,  0.0, -1.0,  0.0, },
        {  0.5, -0.5,  0.5,  0.0, -1.0,  0.0, },
        { -0.5, -0.5,  0.5,  0.0, -1.0,  0.0, },
        { -0.5, -0.5, -0.5,  0.0, -1.0,  0.0, },
        -- face 6
        { -0.5,  0.5, -0.5,  0.0,  1.0,  0.0, },
        {  0.5,  0.5, -0.5,  0.0,  1.0,  0.0, },
        {  0.5,  0.5,  0.5,  0.0,  1.0,  0.0, },
        {  0.5,  0.5,  0.5,  0.0,  1.0,  0.0, },
        { -0.5,  0.5,  0.5,  0.0,  1.0,  0.0, },
        { -0.5,  0.5, -0.5,  0.0,  1.0,  0.0, },
    }
    local mesh = lovr.graphics.newMesh({
        { 'VertexPosition', 'vec3' },
        { 'VertexNormal',   'vec3' },
    }, vertices)

    local camera = Camera()
    camera:init()

    local draw = function(self, pass)
        pass:setColor(gammaToLinear(0.1, 0.1, 0.1, 1.0))
        
        camera:draw(pass, function() 
            -- draw the cube
            pass:setShader(lighting_shader)
            pass:send('objectColor', gammaToLinear(1.0, 0.5, 0.31))
            pass:send('lightColor', gammaToLinear(1.0, 1.0, 1.0))
            pass:send('lightPos', light_pos)
            pass:draw(mesh)

            -- transform
            local model = lovr.math.mat4(1.0)
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

    local leave = function(self, to)
        camera:deinit()
        camera = nil
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
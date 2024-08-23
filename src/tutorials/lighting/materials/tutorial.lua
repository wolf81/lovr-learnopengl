local Camera = require 'lib.lovr-camera.camera'

-- PLEASE NOTE: this function is used to make colors appear same as in LearnOpenGL tutorial apps
local gammaToLinear = lovr.math.gammaToLinear

local Tutorial = {}

Tutorial.new = function()
    local camera = Camera()
    camera:init()

    local light_pos = lovr.math.newVec3(1.2, 1.0, 2.0)

    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local lighting_shader = lovr.graphics.newShader(
        shd_dir .. 'materials.vs', 
        shd_dir .. 'materials.fs')
    local lightcube_shader = lovr.graphics.newShader(
        shd_dir .. 'light_cube.vs', 
        shd_dir .. 'light_cube.fs')

    local draw = function(self, pass)
        local time = lovr.timer.getTime()
        local r, g, b = math.sin(time * 2.0), math.sin(time * 0.7), math.sin(time * 1.3)

        camera:draw(pass, function() 
            pass:setClear(gammaToLinear(0.1, 0.1, 0.1, 1.0))

            -- draw the cube
            pass:setShader(lighting_shader)
            pass:send('lightAmbient', gammaToLinear(r * 0.2, g * 0.2, b * 0.2))
            pass:send('lightDiffuse', gammaToLinear(r * 0.5, g * 0.5, b * 0.5))
            pass:send('lightSpecular', gammaToLinear(1.0, 1.0, 1.0))
            pass:send('lightPosition', light_pos)

            pass:send('matAmbient', gammaToLinear(1.0, 0.5, 0.31))
            pass:send('matDiffuse', gammaToLinear(1.0, 0.5, 0.31))
            pass:send('matSpecular', gammaToLinear(0.5, 0.5, 0.5))
            pass:send('matShininess', 32.0)

            pass:cube(1.0, 1.0, 1.0)

            -- draw the lamp object
            pass:setShader(lightcube_shader)
            pass:cube(light_pos, 0.2)
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

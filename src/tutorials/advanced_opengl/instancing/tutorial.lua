local Camera = require 'lib.lovr-camera.camera'

local random = lovr.math.random

local Tutorial = {}

Tutorial.new = function()
    -- TODO: doesn't properly work on macOS for current stable releases of LOVR, should work with dev builds
    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local asteroid_shader = lovr.graphics.newShader(
        shd_dir .. 'asteroids.vs', 
        shd_dir .. 'asteroids.fs')

    local planet_shader = lovr.graphics.newShader(
        shd_dir .. 'planet.vs', 
        shd_dir .. 'planet.fs')

    local rock = lovr.graphics.newModel('obj/rock/rock.obj')
    local planet = lovr.graphics.newModel('obj/planet/planet.obj')

    -- seems 100.000 is not possible to render correctly, perhaps some kind of buffer limit reached?
    local amount = 10000

    local model_matrices = {}

    lovr.math.setRandomSeed(os.time())

    local radius, offset = 150.0, 25.0

    for i = 1, amount do
        local model = mat4(1.0)

        -- translation: displace along circle with 'radius' in range [-offset, offset]
        local angle = (i - 1) / amount * 360
        local x = math.sin(angle) * radius + random(2 * offset * 100) / 100.0 - offset
        local y = random(2 * offset * 100) / 100.0 - offset * 0.4
        local z = math.cos(angle) * radius + random(2 * offset * 100) / 100.0 - offset
        model:translate(x, y, z)

        -- scale: scale between 0.05 and 0.25f        
        local scale = vec3((random(20)) / 100 + 0.05)
        model:scale(scale)

        -- rotation: add random rotation around a (semi)randomly picked rotation axis vector
        local orientation = quat(random(360), 0.4, 0.6, 0.8)
        model:rotate(orientation)

        -- add to list of matrices
        model_matrices[i] = model
    end

    local buffer = lovr.graphics.newBuffer('mat4', model_matrices)

    -- seems this texture is not automatically applied, so we'll add it manually
    local rock_texture = lovr.graphics.newTexture('obj/rock/rock.png')

    local camera = Camera(0, 0, 155)

    local draw = function(self, pass)
        pass:setClear(0.1, 0.1, 0.1, 1.0)

        camera:draw(pass, function()
            pass:setShader(asteroid_shader)
            pass:send('myTexture', rock_texture)
            pass:send('Transforms', buffer)
            pass:draw(rock, mat4(), amount)

            pass:setShader(planet_shader)
            local model = mat4(1.0)
            model:translate(0.0, -3.0, 0.0)
            model:scale(4.0, 4.0, 4.0)
            pass:draw(planet, model)
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

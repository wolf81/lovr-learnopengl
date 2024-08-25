local Camera = require 'lib.lovr-camera.camera'

local Tutorial = {}

Tutorial.new = function()        
    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local shader = lovr.graphics.newShader(
        shd_dir .. 'model_loading.vs', 
        shd_dir .. 'model_loading.fs')

    local our_model = lovr.graphics.newModel('obj/backpack/backpack.obj', { 
        materials = false, -- seems these materials aren't properly added, so adding manually ...
    })

    local material = lovr.graphics.newMaterial({
        texture = lovr.graphics.newTexture('obj/backpack/diffuse.jpg'),
        normalTexture = lovr.graphics.newTexture('obj/backpack/normal.png'),
        roughnessTexture = lovr.graphics.newTexture('obj/backpack/roughness.jpg'),
        -- glowTexture = lovr.graphics.newTexture('obj/backpack/specular.jpg'),
    })

    local camera = Camera(0, 0, 3)
    camera:init()

    local draw = function(self, pass)
        pass:setClear(0.05, 0.05, 0.05, 1.0)

        camera:draw(pass, function() 
            pass:setMaterial(material)

            pass:setShader(shader)

            local model = mat4()
            model:translate(0.0, 0.0, 0.0)
            model:scale(1.0, 1.0, 1.0)

            pass:draw(our_model, model)
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

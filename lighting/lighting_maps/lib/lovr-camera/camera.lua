local PATH = (...):match('(.-)[^%.]+$') 

local Camera = {}

Camera.new = function()
    local transform = lovr.math.newMat4()
    local position = lovr.math.newVec3()
    local movespeed = 10
    local pitch = 0
    local yaw = 0

    local update = function(self, dt)
        local velocity = vec4()

        if lovr.system.isKeyDown('w', 'up') then
            velocity.z = -1
        elseif lovr.system.isKeyDown('s', 'down') then
            velocity.z = 1
        end

        if lovr.system.isKeyDown('a', 'left') then
            velocity.x = -1
        elseif lovr.system.isKeyDown('d', 'right') then
            velocity.x = 1
        end

        if #velocity > 0 then
            velocity:normalize()
            velocity:mul(movespeed * dt)
            position:add(transform:mul(velocity).xyz)
        end

        transform:identity()
        transform:translate(0, 1.7, 0)
        transform:translate(position)
        transform:rotate(yaw, 0, 1, 0)
        transform:rotate(pitch, 1, 0, 0)        
    end

    local draw = function(self, pass, fn)
        pass:push()

        pass:setViewPose(1, transform)

        fn()

        pass:pop()
    end

    local init = function(self)
        if not lovr.mouse then
            lovr.mouse = require(PATH .. 'lib.lovr-mouse.lovr-mouse')
        end

        lovr.mouse.setRelativeMode(true)

        local lovr_mousemoved = lovr.mousemoved
        lovr.mousemoved = function(x, y, dx, dy)
            pitch = pitch - dy * .002
            yaw = yaw - dx * .004            
        end
    end

    return setmetatable({
        -- properties
        position    = position,
        -- methods
        init        = init,
        draw        = draw,        
        update      = update,
    }, Camera)
end

return setmetatable(Camera, {
    __call = function(_, ...) return Camera.new(...) end,
})

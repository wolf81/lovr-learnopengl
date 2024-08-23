local PATH = (...):match('(.-)[^%.]+$') 

local Camera = {}

Camera.new = function(x, y, z)
    local transform = lovr.math.newMat4()
    local position = lovr.math.newVec3(x or 0, y or 0, z or 0)
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
        transform:translate(0, 0, 0)
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
        lovr.mouse.setRelativeMode(true)

        local lovr_mousemoved = lovr.mousemoved
        lovr.mousemoved = function(x, y, dx, dy)
            pitch = pitch - dy * .002
            yaw = yaw - dx * .004            
        end
    end

    local setPosition = function(self, x, y, z)
        position = lovr.math.newVec3(x, y, z)
    end

    local getPosition = function(self)
        return position
    end

    local getDirection = function(self)
        return lovr.math.newQuat(transform):direction()
    end

    return setmetatable({
        -- methods
        init            = init,
        draw            = draw,        
        update          = update,
        setPosition     = setPosition,
        getPosition     = getPosition,
        getDirection    = getDirection,
    }, Camera)
end

return setmetatable(Camera, {
    __call = function(_, ...) return Camera.new(...) end,
})

local Tutorial = {}

Tutorial.new = function()
    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local shader = lovr.graphics.newShader(
        shd_dir .. 'camera.vs', 
        shd_dir .. 'camera.fs')

    local camera_pos = Vec3(0.0, 0.0, 3.0)
    local camera_front = Vec3(0.0, 0.0, -1.0)
    local camera_up = Vec3(0.0, 1.0, 0.0)

    lovr.mouse.setRelativeMode(true)

    local first_mouse = false
    local yaw = -90.0
    local pitch = 0.0
    local last_x = 800 / 2.0 -- based on screen width (?)
    local last_y = 600 / 2.0 -- based on screen height (?)
    local fov = 45.0

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

    local draw = function(self, pass)
        pass:setClear(0.2, 0.3, 0.3, 1.0)

        local projection = Mat4():perspective(math.rad(fov), 800 / 600, 0.1, 100.0)
        projection:lookAt(camera_pos, camera_front, camera_up)
        pass:setViewPose(1, camera_pos, projection:getOrientation())

        -- camera:draw(pass, function() 
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
        -- end)
    end

    local update = function(self, dt)
        local camera_speed = 2.5 * dt

        if lovr.system.isKeyDown('w') then 
            print(camera_speed * camera_front)
            camera_pos = Vec3(camera_pos + camera_speed * camera_front) 
        end 

        if lovr.system.isKeyDown('s') then
            camera_pos = Vec3(camera_pos - camera_speed * camera_front)
        end

        if lovr.system.isKeyDown('a') then
            local dir = camera_front:cross(camera_up):normalize() * camera_speed
            camera_pos = Vec3(camera_pos - dir)
        end

        if lovr.system.isKeyDown('d') then
            local dir = camera_front:cross(camera_up):normalize() * camera_speed
            camera_pos = Vec3(camera_pos + dir)
        end

        local x, y = lovr.mouse.getPosition()

        if first_mouse then
            last_x = x
            last_y = y
            first_mouse = false
        end

        local x_offset = x - last_x
        local y_offset = y - last_y

        last_x = x
        last_y = y

        local sensitivity = 0.1
        x_offset = x_offset * sensitivity
        y_offset = y_offset * sensitivity

        yaw = yaw + x_offset
        pitch = pitch + y_offset

        print(pitch, yaw)

        if pitch > 89.0 then
            pitch = 89.0
        end

        if pitch < -89.0 then
            pitch = -89.0
        end

        local x = math.cos(math.rad(yaw) * math.cos(math.rad(pitch)))
        local y = math.sin(math.rad(pitch))
        local z = math.sin(math.rad(yaw) * math.cos(math.rad(pitch)))
        local front = Vec3(x, y, z)

        camera_front = front:normalize()
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

local Tutorial = {}

Tutorial.new = function()
    --    positions            tex coords
    local vertices = {
        -- face 1
        { -0.5, -0.5, -0.5  ;  0.0,  0.0  },
        {  0.5, -0.5, -0.5  ;  1.0,  0.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  1.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  1.0  },
        { -0.5,  0.5, -0.5  ;  0.0,  1.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  0.0  },
        -- face 2
        { -0.5, -0.5,  0.5  ;  0.0,  0.0  },
        {  0.5, -0.5,  0.5  ;  1.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  1.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  1.0  },
        { -0.5,  0.5,  0.5  ;  0.0,  1.0  },
        { -0.5, -0.5,  0.5  ;  0.0,  0.0  },
        -- face 3
        { -0.5,  0.5,  0.5  ;  1.0,  0.0  },
        { -0.5,  0.5, -0.5  ;  1.0,  1.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  1.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  1.0  },
        { -0.5, -0.5,  0.5  ;  0.0,  0.0  },
        { -0.5,  0.5,  0.5  ;  1.0,  0.0  },
        -- face 4
        {  0.5,  0.5,  0.5  ;  1.0,  0.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  1.0  },
        {  0.5, -0.5, -0.5  ;  0.0,  1.0  },
        {  0.5, -0.5, -0.5  ;  0.0,  1.0  },
        {  0.5, -0.5,  0.5  ;  0.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  0.0  },
        -- face 5
        { -0.5, -0.5, -0.5  ;  0.0,  1.0  },
        {  0.5, -0.5, -0.5  ;  1.0,  1.0  },
        {  0.5, -0.5,  0.5  ;  1.0,  0.0  },
        {  0.5, -0.5,  0.5  ;  1.0,  0.0  },
        { -0.5, -0.5,  0.5  ;  0.0,  0.0  },
        { -0.5, -0.5, -0.5  ;  0.0,  1.0  },
        -- face 6
        { -0.5,  0.5, -0.5  ;  0.0,  1.0  },
        {  0.5,  0.5, -0.5  ;  1.0,  1.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  0.0  },
        {  0.5,  0.5,  0.5  ;  1.0,  0.0  },
        { -0.5,  0.5,  0.5  ;  0.0,  0.0  },
        { -0.5,  0.5, -0.5  ;  0.0,  1.0  },
    }

    local mesh = lovr.graphics.newMesh({
        { 'VertexPosition', 'vec3' },
        { 'VertexUV', 'vec2' }
    }, vertices, 'gpu')

    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local shader = lovr.graphics.newShader(
        shd_dir .. 'coordinate_systems.vs', 
        shd_dir .. 'coordinate_systems.fs')

    local texture1 = lovr.graphics.newTexture('gfx/container.jpg')
    local texture2 = lovr.graphics.newTexture('gfx/awesomeface.png')

    local window_width, window_height = lovr.system.getWindowDimensions()

    local cubePositions = {
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

    local draw = function(self, pass)
        pass:setClear(0.2, 0.3, 0.3, 1.0)

        pass:setShader(shader)

        local view = mat4(1.0)
        local projection = mat4(1.0)
        --[[
        PLEASE NOTE:
        A far clipping plane of 0.0 can be used for an infinite far plane with reversed Z range. 
        This is the default because it improves depth precision and reduces Z fighting. Using a 
        non-infinite far plane requires the depth buffer to be cleared to 1.0 instead of 0.0 and 
        the default depth test to be changed to lequal instead of gequal.
        --]]
        projection:perspective(math.rad(45.0), window_width / window_height, 0.1, 0.0)
        view:translate(0.0, 0.0, -3.0)
        pass:setProjection(1, projection)
        pass:setViewPose(1, view, true)

        pass:send('texture1', texture1)
        pass:send('texture2', texture2)

        -- render boxes
        for idx, position in ipairs(cubePositions) do
            local model = mat4(1.0)
            model:translate(position)
            local angle = (idx - 1) * 20
            model:rotate(math.rad(angle), 1.0, 0.3, 0.5)

            pass:draw(mesh, model)
        end
    end

    local update = function(self, dt)
        -- body
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

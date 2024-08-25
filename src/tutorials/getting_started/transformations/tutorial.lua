local Tutorial = {}

Tutorial.new = function() 
    local shd_dir = (debug.getinfo(1).source:match("@?(.*/)") or '') .. 'shd/'
    local shader = lovr.graphics.newShader(
        shd_dir .. 'transform.vs', 
        shd_dir .. 'transform.fs')

    -- PLEASE NOTE: some UV coords are swapped here, so we don't need to rotate the image
    local vertices = lovr.graphics.newBuffer({
        { name = 'VertexPosition', type = 'vec3' },
        { name = 'VertexUV', type = 'vec2' },
    }, {
        {  0.5,  0.5,  0.0  ;  0.0, 0.0  },
        {  0.5, -0.5,  0.0  ;  0.0, 1.0  },
        { -0.5, -0.5,  0.0  ;  1.0, 1.0  },
        { -0.5,  0.5,  0.0  ;  1.0, 0.0  },
    })

    local indices = lovr.graphics.newBuffer('index16', { 1, 2, 4, 2, 3, 4 })

    local texture1 = lovr.graphics.newTexture('gfx/container.jpg')
    local texture2 = lovr.graphics.newTexture('gfx/awesomeface.png')    

    local draw = function(self, pass)
        pass:setClear(0.2, 0.3, 0.3, 1.0)

        pass:setShader(shader)

        pass:send('texture1', texture1)
        pass:send('texture2', texture2)

        local transform = mat4(1.0)
        transform:translate(0.5, -0.5, 0.0)
        transform:rotate(lovr.timer.getTime(), 0.0, 0.0, 1.0)
        pass:transform(transform)

        pass:mesh(vertices, indices, 0, 0, -1)
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

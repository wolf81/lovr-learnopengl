local Tutorial = {}

Tutorial.new = function()
    local shader = lovr.graphics.newShader([[
        vec4 lovrmain() 
        {
            return DefaultPosition;
        }
    ]], [[
        Constants {
            vec4 ourColor;
        };

        vec4 lovrmain() 
        {
            return ourColor;
        }
    ]])

    local vertices = lovr.graphics.newBuffer({
        { name = 'VertexPosition', type = 'vec3' },
    }, {
        vec3( 0.5, -0.5,  0.0), -- bottom right
        vec3(-0.5, -0.5,  0.0), -- bottom left
        vec3( 0.0,  0.5,  0.0), -- top
    })

    local indices = lovr.graphics.newBuffer('index16', { 1, 2, 3 })

    local draw = function(self, pass)
        pass:setClear(0.2, 0.3, 0.3, 1.0)

        pass:setShader(shader)

        local green_value = math.sin(lovr.timer.getTime()) / 2.0 + 0.5

        pass:send('ourColor', lovr.math.vec4(0.0, green_value, 0.0, 1.0))

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

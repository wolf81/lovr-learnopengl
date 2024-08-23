local Button = {}

local MARGIN = 8.0

Button.new = function(title, fn)
    fn = fn or function() print('clicked: "' .. title .. '"') end
    
    local is_hover, is_press, is_release = false, false, false

    local x, y = 0, 0
    local font = lovr.graphics.getDefaultFont()
    local w = font:getWidth(title) + MARGIN * 2
    local h = font:getHeight() + MARGIN * 2

    local update = function(self, dt)
        if is_release then return end

        local was_pressed = is_press and is_hover

        local mx, my = lovr.mouse.getPosition()
        is_press = lovr.mouse.isDown(1)
        is_hover = (
            mx > x - w / 2 and mx < x + w / 2 and
            my > y - h / 2 and my < y + h / 2)

        is_release = was_pressed == true and is_press == false

        if is_release then
            Timer.after(0.1, function() 
                fn()
                is_release = false
            end)
        end
    end

    local draw = function(self, pass)
        if is_hover and is_press then
            pass:setColor(0x333340)
        elseif is_hover then
            pass:setColor(0x454550)
        else
            pass:setColor(0x151520)
        end
        pass:plane(x, y, 0, w, h)

        pass:setColor(0xFFFFFF)
        pass:text(title, x, y, 0)
    end

    local setFrame = function(self, x_, y_, w_, h_)
        x = x_
        y = y_
        w = w_
        h = h_
    end

    local getFrame = function(self)
        return x, y, w, h
    end

    return setmetatable({
        -- methods
        draw        = draw,
        update      = update,
        setFrame    = setFrame,
        getFrame    = getFrame,
    }, Button)
end

return setmetatable(Button, {
    __call = function(_, ...) return Button.new(...) end,
})

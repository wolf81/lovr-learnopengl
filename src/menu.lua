local Menu = {}

local BUTTON_W = 320
local BUTTON_H = 50
local SPACING = 8

Menu.new = function(title, menu_items)
    local window_width, window_height = lovr.system.getWindowDimensions()

    -- setup 2D projection for user interface
    local projection = Mat4():orthographic(0, window_width, 0, window_height, -10, 10)

    -- ensure pixel units are used for fonts on UI elements
    lovr.graphics.getDefaultFont():setPixelDensity(1)

    local buttons = {}

    for _, menu_item in ipairs(menu_items) do
        buttons[#buttons + 1] = Button(menu_item.name, menu_item.action)
    end

    -- TODO: could use a simple layout engine here
    local x = window_width / 2
    local y = (window_height / 2) - (BUTTON_H * #buttons) / 2 - (SPACING * math.max(#buttons - 1, 0)) / 2 + BUTTON_H / 2
    for _, button in ipairs(buttons) do
        button:setFrame(x, y, BUTTON_W, BUTTON_H)
        y = y + SPACING + BUTTON_H
    end

    local update = function(self, dt)
        for _, button in ipairs(buttons) do
            button:update(dt)
        end
    end

    local draw = function(self, pass)
        pass:setClear(0x343434)

        -- ensure the view looks at the 2D projection
        pass:setViewPose(1, mat4():identity())
        pass:setProjection(1, projection)
        pass:setDepthTest()

        pass:setColor(0xFFFFFF)
        local x, y, w, h = buttons[1]:getFrame()
        pass:text(title, window_width / 2, 40, 0)

        -- draw UI elements
        for _, button in ipairs(buttons) do
            button:draw(pass)
        end
    end

    local enter = function(self, from)
        lovr.mouse.setRelativeMode(false)
    end
    
    return setmetatable({
        -- methods
        draw    = draw,
        enter   = enter,
        update  = update,
    }, Menu)
end

return setmetatable(Menu, {
    __call = function(_, ...) return Menu.new(...) end,
})

function lovr.conf(t)
    t.modules.headset = false
    t.window.width = 800
    t.window.height = 600
    t.window.title = 'Learn OpenGL'
    -- for tutorials that make use of stencil buffer
    t.graphics.stencil = 'd24s8'
    t.headset.stencil = 'd24s8'
    -- t.graphics.debug = true
    -- t.graphics.compileShaders = true
end

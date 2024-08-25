require 'dependencies'

io.stdout:setvbuf('no')

local getting_started_menu = Menu('Getting Started', 
{
    { ['name'] = 'Hello Triangle',      ['action'] = function() Gamestate.push(HelloTriangle()) end },
    { ['name'] = 'Shaders',             ['action'] = function() Gamestate.push(Shaders()) end },
    { ['name'] = 'Textures',            ['action'] = function() Gamestate.push(Textures()) end },
    { ['name'] = 'Transformations',     ['action'] = function() Gamestate.push(Transformations()) end },
    { ['name'] = 'Coordinate Systems',  ['action'] = function() Gamestate.push(CoordinateSystems()) end },
    { ['name'] = 'Camera',              ['action'] = function() Gamestate.push(Camera()) end },
    { ['name'] = 'Back',                ['action'] = function() Gamestate.pop() end },
})

local lighting_menu = Menu('Lighting', 
{
    { ['name'] = 'Colors',              ['action'] = function() Gamestate.push(Colors()) end },
    { ['name'] = 'Basic Lighting',      ['action'] = function() Gamestate.push(BasicLighting()) end },
    { ['name'] = 'Materials',           ['action'] = function() Gamestate.push(Materials()) end },
    { ['name'] = 'Lighting Maps',       ['action'] = function() Gamestate.push(LightingMaps()) end },
    { ['name'] = 'Light Casters',       ['action'] = function() Gamestate.push(LightCasters()) end },
    { ['name'] = 'Multiple Lights',     ['action'] = function() Gamestate.push(MultipleLights()) end },
    { ['name'] = 'Back',                ['action'] = function() Gamestate.pop() end },
})

local advanced_opengl = Menu('Advanced OpenGL',
{
    { ['name'] = 'Depth Testing',       ['action'] = function() Gamestate.push(DepthTesting()) end },
    { ['name'] = 'Stencil Testing',     ['action'] = function() Gamestate.push(StencilTesting()) end },
    { ['name'] = 'Blending',            ['action'] = function() Gamestate.push(Blending()) end },
    { ['name'] = 'Cubemaps',            ['action'] = function() Gamestate.push(Cubemaps()) end },
    { ['name'] = 'Advanced GLSL',       ['action'] = function() Gamestate.push(AdvancedGLSL()) end },
    { ['name'] = 'Instancing',          ['action'] = function() Gamestate.push(Instancing()) end },
    { ['name'] = 'Back',                ['action'] = function() Gamestate.pop() end },
})

local model_loading = Menu('Model Loading', {
    { ['name'] = 'Model',               ['action'] = function() Gamestate.push(Model()) end },
    { ['name'] = 'Back',                ['action'] = function() Gamestate.pop() end },
})

local main_menu = Menu('Learn OpenGL', 
{
    { ['name'] = 'Getting Started',     ['action'] = function() Gamestate.push(getting_started_menu) end },
    { ['name'] = 'Lighting',            ['action'] = function() Gamestate.push(lighting_menu) end },
    { ['name'] = 'Model Loading',       ['action'] = function() Gamestate.push(model_loading) end },
    { ['name'] = 'Advanced OpenGL',     ['action'] = function() Gamestate.push(advanced_opengl) end },
})

local function traverse(menu_item)
    print(menu_item:getName(), menu_item:getPath())

    for _, child in ipairs(menu_item:getChildren()) do
        traverse(child)
    end
end

function lovr.load(args)
    Gamestate.registerEvents()
    Gamestate.switch(main_menu)
end

function lovr.update(dt)
    Timer.update(dt)
end

function lovr.keypressed(key)
    if key == 'escape' then
        if Gamestate.current() == main_menu then
            lovr.event.quit()
        else
            Gamestate.pop()
        end 
    end
end

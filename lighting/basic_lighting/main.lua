local Camera = require 'lib.lovr-camera.camera'

local gammaToLinear = lovr.math.gammaToLinear

local lightingShader = lovr.graphics.newShader('shader/basic_lighting.vs', 'shader/basic_lighting.fs')
local lightCubeShader = lovr.graphics.newShader('shader/light_cube.vs', 'shader/light_cube.fs')

local lightPos = lovr.math.newVec3(1.2, 1.0, 2.0)

-- PLEASE NOTE: unlike original code, we need to add normals for lighting to work correctly 
--    positions          normals   
local vertices = {
    -- face 1
    { -0.5, -0.5, -0.5,  0.0,  0.0, -1.0, },
    {  0.5, -0.5, -0.5,  0.0,  0.0, -1.0, },
    {  0.5,  0.5, -0.5,  0.0,  0.0, -1.0, },
    {  0.5,  0.5, -0.5,  0.0,  0.0, -1.0, },
    { -0.5,  0.5, -0.5,  0.0,  0.0, -1.0, },
    { -0.5, -0.5, -0.5,  0.0,  0.0, -1.0, },
    -- face 2
    { -0.5, -0.5,  0.5,  0.0,  0.0, 1.0,  },
    {  0.5, -0.5,  0.5,  0.0,  0.0, 1.0,  },
    {  0.5,  0.5,  0.5,  0.0,  0.0, 1.0,  },
    {  0.5,  0.5,  0.5,  0.0,  0.0, 1.0,  },
    { -0.5,  0.5,  0.5,  0.0,  0.0, 1.0,  },
    { -0.5, -0.5,  0.5,  0.0,  0.0, 1.0,  },
    -- face 3
    { -0.5,  0.5,  0.5, -1.0,  0.0,  0.0, },
    { -0.5,  0.5, -0.5, -1.0,  0.0,  0.0, },
    { -0.5, -0.5, -0.5, -1.0,  0.0,  0.0, },
    { -0.5, -0.5, -0.5, -1.0,  0.0,  0.0, },
    { -0.5, -0.5,  0.5, -1.0,  0.0,  0.0, },
    { -0.5,  0.5,  0.5, -1.0,  0.0,  0.0, },
    -- face 4
    {  0.5,  0.5,  0.5,  1.0,  0.0,  0.0, },
    {  0.5,  0.5, -0.5,  1.0,  0.0,  0.0, },
    {  0.5, -0.5, -0.5,  1.0,  0.0,  0.0, },
    {  0.5, -0.5, -0.5,  1.0,  0.0,  0.0, },
    {  0.5, -0.5,  0.5,  1.0,  0.0,  0.0, },
    {  0.5,  0.5,  0.5,  1.0,  0.0,  0.0, },
    -- face 5
    { -0.5, -0.5, -0.5,  0.0, -1.0,  0.0, },
    {  0.5, -0.5, -0.5,  0.0, -1.0,  0.0, },
    {  0.5, -0.5,  0.5,  0.0, -1.0,  0.0, },
    {  0.5, -0.5,  0.5,  0.0, -1.0,  0.0, },
    { -0.5, -0.5,  0.5,  0.0, -1.0,  0.0, },
    { -0.5, -0.5, -0.5,  0.0, -1.0,  0.0, },
    -- face 6
    { -0.5,  0.5, -0.5,  0.0,  1.0,  0.0, },
    {  0.5,  0.5, -0.5,  0.0,  1.0,  0.0, },
    {  0.5,  0.5,  0.5,  0.0,  1.0,  0.0, },
    {  0.5,  0.5,  0.5,  0.0,  1.0,  0.0, },
    { -0.5,  0.5,  0.5,  0.0,  1.0,  0.0, },
    { -0.5,  0.5, -0.5,  0.0,  1.0,  0.0, },
}
local mesh = lovr.graphics.newMesh({
  { 'VertexPosition', 'vec3' },
  { 'VertexNormal',   'vec3' },
}, vertices)

local camera = Camera()

function lovr.load()
    camera:init()
end

function lovr.update(dt)
    camera:update(dt)
end

function lovr.draw(pass) 
    pass:setColor(gammaToLinear(0.1, 0.1, 0.1, 1.0))
    
    camera:draw(pass, function() 
        -- draw the cube
        pass:setShader(lightingShader)
        pass:send('objectColor', gammaToLinear(1.0, 0.5, 0.31))
        pass:send('lightColor', gammaToLinear(1.0, 1.0, 1.0))
        pass:send('lightPos', lightPos)
        pass:draw(mesh)

        -- transform
        local model = lovr.math.mat4(1.0)
        model:translate(lightPos)
        model:scale(0.2)
        pass:transform(model)
        
        -- draw the lamp object
        pass:setShader(lightCubeShader)
        pass:draw(mesh)
    end)
end

function lovr.keypressed(key)
    if key == 'escape' then
        lovr.event.quit()
    end
end

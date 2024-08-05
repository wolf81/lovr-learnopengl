local Camera = require 'lib.lovr-camera.camera'

-- PLEASE NOTE: this function is used to make colors appear same as in LearnOpenGL tutorial apps
local gammaToLinear = lovr.math.gammaToLinear

local camera = Camera()

local lightPos = { 1.2, 1.0, 2.0 }

local lightingShader = lovr.graphics.newShader('shd/lighting_maps.vs', 'shd/lighting_maps.fs')
local lightCubeShader = lovr.graphics.newShader('shd/light_cube.vs', 'shd/light_cube.fs')

--    positions          normals           tex coords
local vertices = {
    -- face 1
    { -0.5, -0.5, -0.5,  0.0,  0.0, -1.0,  0.0, 0.0, },
    {  0.5, -0.5, -0.5,  0.0,  0.0, -1.0,  1.0, 0.0, },
    {  0.5,  0.5, -0.5,  0.0,  0.0, -1.0,  1.0, 1.0, },
    {  0.5,  0.5, -0.5,  0.0,  0.0, -1.0,  1.0, 1.0, },
    { -0.5,  0.5, -0.5,  0.0,  0.0, -1.0,  0.0, 1.0, },
    { -0.5, -0.5, -0.5,  0.0,  0.0, -1.0,  0.0, 0.0, },
    -- face 2
    { -0.5, -0.5,  0.5,  0.0,  0.0, 1.0,   0.0, 0.0, },
    {  0.5, -0.5,  0.5,  0.0,  0.0, 1.0,   1.0, 0.0, },
    {  0.5,  0.5,  0.5,  0.0,  0.0, 1.0,   1.0, 1.0, },
    {  0.5,  0.5,  0.5,  0.0,  0.0, 1.0,   1.0, 1.0, },
    { -0.5,  0.5,  0.5,  0.0,  0.0, 1.0,   0.0, 1.0, },
    { -0.5, -0.5,  0.5,  0.0,  0.0, 1.0,   0.0, 0.0, },
    -- face 3
    { -0.5,  0.5,  0.5, -1.0,  0.0,  0.0,  1.0, 0.0, },
    { -0.5,  0.5, -0.5, -1.0,  0.0,  0.0,  1.0, 1.0, },
    { -0.5, -0.5, -0.5, -1.0,  0.0,  0.0,  0.0, 1.0, },
    { -0.5, -0.5, -0.5, -1.0,  0.0,  0.0,  0.0, 1.0, },
    { -0.5, -0.5,  0.5, -1.0,  0.0,  0.0,  0.0, 0.0, },
    { -0.5,  0.5,  0.5, -1.0,  0.0,  0.0,  1.0, 0.0, },
    -- face 4
    {  0.5,  0.5,  0.5,  1.0,  0.0,  0.0,  1.0, 0.0, },
    {  0.5,  0.5, -0.5,  1.0,  0.0,  0.0,  1.0, 1.0, },
    {  0.5, -0.5, -0.5,  1.0,  0.0,  0.0,  0.0, 1.0, },
    {  0.5, -0.5, -0.5,  1.0,  0.0,  0.0,  0.0, 1.0, },
    {  0.5, -0.5,  0.5,  1.0,  0.0,  0.0,  0.0, 0.0, },
    {  0.5,  0.5,  0.5,  1.0,  0.0,  0.0,  1.0, 0.0, },
    -- face 5
    { -0.5, -0.5, -0.5,  0.0, -1.0,  0.0,  0.0, 1.0, },
    {  0.5, -0.5, -0.5,  0.0, -1.0,  0.0,  1.0, 1.0, },
    {  0.5, -0.5,  0.5,  0.0, -1.0,  0.0,  1.0, 0.0, },
    {  0.5, -0.5,  0.5,  0.0, -1.0,  0.0,  1.0, 0.0, },
    { -0.5, -0.5,  0.5,  0.0, -1.0,  0.0,  0.0, 0.0, },
    { -0.5, -0.5, -0.5,  0.0, -1.0,  0.0,  0.0, 1.0, },
    -- face 6
    { -0.5,  0.5, -0.5,  0.0,  1.0,  0.0,  0.0, 1.0, },
    {  0.5,  0.5, -0.5,  0.0,  1.0,  0.0,  1.0, 1.0, },
    {  0.5,  0.5,  0.5,  0.0,  1.0,  0.0,  1.0, 0.0, },
    {  0.5,  0.5,  0.5,  0.0,  1.0,  0.0,  1.0, 0.0, },
    { -0.5,  0.5,  0.5,  0.0,  1.0,  0.0,  0.0, 0.0, },
    { -0.5,  0.5, -0.5,  0.0,  1.0,  0.0,  0.0, 1.0, },
}

local mesh = lovr.graphics.newMesh(vertices)

local diffuseMap = lovr.graphics.newTexture('gfx/container2.png')
local specularMap = lovr.graphics.newTexture('gfx/container2_specular.png')    

function lovr.load()
    camera:init()
end

function lovr.update(dt)
    camera:update(dt)
end

function lovr.draw(pass) 
    pass:setClear(0.1, 0.1, 0.1, 1.0)

    camera:draw(pass, function()
        -- activate shader for drawing cube
        pass:setShader(lightingShader)

        -- light properties
        pass:send('lightPosition', lightPos)
        pass:send('lightAmbient', gammaToLinear(0.2, 0.2, 0.2))
        pass:send('lightDiffuse', gammaToLinear(0.5, 0.5, 0.5))
        pass:send('lightSpecular', gammaToLinear(1.0, 1.0, 1.0))

        -- material properties 
        -- PLEASE NOTE: can likely use Material object instead with some shader modifications
        pass:send('matShininess', 64)
        pass:send('matDiffuse', diffuseMap)
        pass:send('matSpecular', specularMap)

        -- render
        pass:draw(mesh)

        -- activate shader for drawing lamp
        pass:setShader(lightCubeShader)
        pass:cube(1.2, 1.0, 2.0, 0.2)
    end)
end

function lovr.keypressed(key)
    if key == 'escape' then
        lovr.event.quit()
    end
end

local Camera = require 'lib.lovr-camera.camera'

-- PLEASE NOTE: this function is used to make colors appear same as in LearnOpenGL tutorial apps
local gammaToLinear = lovr.math.gammaToLinear

local camera = Camera(0, -3, 0)

local lightPos = { 1.2, 1.0, 2.0 }

local lightingShader = lovr.graphics.newShader('shd/multiple_lights.vs', 'shd/multiple_lights.fs')
local lightCubeShader = lovr.graphics.newShader('shd/light_cube.vs', 'shd/light_cube.fs')

local lightingShaderFormat = lightingShader:getBufferFormat('Lights')
-- we need to set layout to ensure data is properly padded
lightingShaderFormat.layout = 'std140'

--    positions            normals             tex coords
local vertices = {
    -- face 1
    { -0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  ;  0.0,  0.0  },
    {  0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  ;  1.0,  0.0  },
    {  0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  ;  1.0,  1.0  },
    {  0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  ;  1.0,  1.0  },
    { -0.5,  0.5, -0.5  ;  0.0,  0.0, -1.0  ;  0.0,  1.0  },
    { -0.5, -0.5, -0.5  ;  0.0,  0.0, -1.0  ;  0.0,  0.0  },
    -- face 2
    { -0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  ;  0.0,  0.0  },
    {  0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  ;  1.0,  0.0  },
    {  0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  ;  1.0,  1.0  },
    {  0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  ;  1.0,  1.0  },
    { -0.5,  0.5,  0.5  ;  0.0,  0.0,  1.0  ;  0.0,  1.0  },
    { -0.5, -0.5,  0.5  ;  0.0,  0.0,  1.0  ;  0.0,  0.0  },
    -- face 3
    { -0.5,  0.5,  0.5  ; -1.0,  0.0,  0.0  ;  1.0,  0.0  },
    { -0.5,  0.5, -0.5  ; -1.0,  0.0,  0.0  ;  1.0,  1.0  },
    { -0.5, -0.5, -0.5  ; -1.0,  0.0,  0.0  ;  0.0,  1.0  },
    { -0.5, -0.5, -0.5  ; -1.0,  0.0,  0.0  ;  0.0,  1.0  },
    { -0.5, -0.5,  0.5  ; -1.0,  0.0,  0.0  ;  0.0,  0.0  },
    { -0.5,  0.5,  0.5  ; -1.0,  0.0,  0.0  ;  1.0,  0.0  },
    -- face 4
    {  0.5,  0.5,  0.5  ;  1.0,  0.0,  0.0  ;  1.0,  0.0  },
    {  0.5,  0.5, -0.5  ;  1.0,  0.0,  0.0  ;  1.0,  1.0  },
    {  0.5, -0.5, -0.5  ;  1.0,  0.0,  0.0  ;  0.0,  1.0  },
    {  0.5, -0.5, -0.5  ;  1.0,  0.0,  0.0  ;  0.0,  1.0  },
    {  0.5, -0.5,  0.5  ;  1.0,  0.0,  0.0  ;  0.0,  0.0  },
    {  0.5,  0.5,  0.5  ;  1.0,  0.0,  0.0  ;  1.0,  0.0  },
    -- face 5
    { -0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  ;  0.0,  1.0  },
    {  0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  ;  1.0,  1.0  },
    {  0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  ;  1.0,  0.0  },
    {  0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  ;  1.0,  0.0  },
    { -0.5, -0.5,  0.5  ;  0.0, -1.0,  0.0  ;  0.0,  0.0  },
    { -0.5, -0.5, -0.5  ;  0.0, -1.0,  0.0  ;  0.0,  1.0  },
    -- face 6
    { -0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  ;  0.0,  1.0  },
    {  0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  ;  1.0,  1.0  },
    {  0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  ;  1.0,  0.0  },
    {  0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  ;  1.0,  0.0  },
    { -0.5,  0.5,  0.5  ;  0.0,  1.0,  0.0  ;  0.0,  0.0  },
    { -0.5,  0.5, -0.5  ;  0.0,  1.0,  0.0  ;  0.0,  1.0  },
}

local mesh = lovr.graphics.newMesh(vertices, 'gpu')

local cubePositions = {
    lovr.math.newVec3( 0.0,  0.0,   0.0),
    lovr.math.newVec3( 2.0,  5.0, -15.0),
    lovr.math.newVec3(-1.5, -2.2,  -2.5),
    lovr.math.newVec3(-3.8, -2.0, -12.3),
    lovr.math.newVec3( 2.4, -0.4,  -3.5),
    lovr.math.newVec3(-1.7,  3.0,  -7.5),
    lovr.math.newVec3( 1.3, -2.0,  -2.5),
    lovr.math.newVec3( 1.5,  2.0,  -2.5),
    lovr.math.newVec3( 1.5,  0.2,  -1.5),
    lovr.math.newVec3(-1.3,  1.0,  -1.5),
}

local pointLightPositions = {
    lovr.math.newVec3( 0.7,  0.2,   2.0),
    lovr.math.newVec3( 2.3, -3.3,  -4.0),
    lovr.math.newVec3(-4.0,  2.0, -12.0),
    lovr.math.newVec3( 0.0,  0.0,  -3.0),
}

local diffuseMap = lovr.graphics.newTexture('gfx/container2.png')
local specularMap = lovr.graphics.newTexture('gfx/container2_specular.png')

local dirLight = {
    ambient     = {  0.05, 0.05, 0.05 },
    diffuse     = {  0.4,  0.4,  0.4  },
    specular    = {  0.5,  0.5,  0.5  },
    direction   = { -0.2, -1.0, -0.3  },
}

local pointLights = {
    {
        ambient     = {  0.05, 0.05,  0.05 },
        diffuse     = {  0.8,  0.8,   0.8  },
        specular    = {  1.0,  1.0,   1.0  },
        position    = {  0.7,  0.2,   2.0  },
        constant    = 1.0,
        linear      = 0.09,
        quadratic   = 0.032,            
    },
    {
        ambient     = {  0.05, 0.05,  0.05 },
        diffuse     = {  0.8,  0.8,   0.8  },
        specular    = {  1.0,  1.0,   1.0  },
        position    = { -4.0,  2.0, -12.0  },
        constant    = 1.0,
        linear      = 0.09,
        quadratic   = 0.032,            
    },
    {
        ambient     = {  0.05, 0.05,  0.05 },
        diffuse     = {  0.8,  0.8,   0.8  },
        specular    = {  1.0,  1.0,   1.0  },
        position    = {  0.0,  0.0,  -3.0  },
        constant    = 1.0,
        linear      = 0.09,
        quadratic   = 0.032,            
    },
    {
        ambient     = {  0.05, 0.05,  0.05 },
        diffuse     = {  0.8,  0.8,   0.8  },
        specular    = {  1.0,  1.0,   1.0  },
        position    = {  0.7,  0.2,   2.0  },
        constant    = 1.0,
        linear      = 0.09,
        quadratic   = 0.032,            
    },
}

function lovr.load()
    camera:init()
end

function lovr.update(dt)
    camera:update(dt)
end

function lovr.draw(pass) 
    pass:setClear(0.1, 0.1, 0.1, 1.0)

    camera:draw(pass, function()
        pass:setShader(lightingShader)

        local lights = lovr.graphics.newBuffer(lightingShaderFormat, {
            pointLights = pointLights,
            dirLight    = dirLight,
            spotLight   = {
                ambient     = { 0.0, 0.0, 0.0 },
                diffuse     = { 1.0, 1.0, 1.0 },
                specular    = { 1.0, 1.0, 1.0 },
                position    = camera:getPosition(),
                direction   = camera:getDirection(),
                constant    = 1.0,
                linear      = 0.09,
                quadratic   = 0.032,
                cutOff      = math.cos(math.rad(12.5)),
                outerCutOff = math.cos(math.rad(15.0)),        
            },
        })

        pass:send('Lights', lights)

        -- material properties 
        -- PLEASE NOTE: can likely use Material object instead with some shader modifications
        pass:send('matShininess', 32.0)
        pass:send('matDiffuse', diffuseMap)
        pass:send('matSpecular', specularMap)

        -- render boxes
        for idx, position in ipairs(cubePositions) do
            local model = lovr.math.mat4(1.0)
            model:translate(position)
            local angle = (idx - 1) * 20
            model:rotate(math.rad(angle), 1.0, 0.3, 0.5)

            pass:draw(mesh, model)
        end

        -- activate shader for drawing lamp
        pass:setShader(lightCubeShader)

        -- render light cubes
        for idx, position in ipairs(pointLightPositions) do
            local model = lovr.math.mat4(1.0)
            model:translate(position)
            model:scale(0.2)
            pass:draw(mesh, model)
        end
    end)
end

function lovr.keypressed(key)
    if key == 'escape' then
        lovr.event.quit()
    end
end

-- lib
Gamestate           = require 'lib.hump.gamestate'
Timer               = require 'lib.hump.timer'
lovr.mouse          = require 'lib.lovr-mouse.lovr-mouse'

-- core app
Button              = require 'src.button'
Menu                = require 'src.menu'

-- tutorials: Lighting
Colors              = require 'src.tutorials.lighting.colors.tutorial'
Materials           = require 'src.tutorials.lighting.materials.tutorial'
LightCasters        = require 'src.tutorials.lighting.light_casters.tutorial'
LightingMaps        = require 'src.tutorials.lighting.lighting_maps.tutorial'
BasicLighting       = require 'src.tutorials.lighting.basic_lighting.tutorial'
MultipleLights      = require 'src.tutorials.lighting.multiple_lights.tutorial'

-- tutorials: Getting Started
Camera              = require 'src.tutorials.getting_started.camera.tutorial'
Shaders             = require 'src.tutorials.getting_started.shaders.tutorial'
Textures            = require 'src.tutorials.getting_started.textures.tutorial'
HelloTriangle       = require 'src.tutorials.getting_started.hello_triangle.tutorial'
Transformations     = require 'src.tutorials.getting_started.transformations.tutorial'
CoordinateSystems   = require 'src.tutorials.getting_started.coordinate_systems.tutorial'

-- tutorials: Advanced OpenGL
Blending            = require 'src.tutorials.advanced_opengl.blending.tutorial'
Cubemaps            = require 'src.tutorials.advanced_opengl.cubemaps.tutorial'
AdvancedGLSL        = require 'src.tutorials.advanced_opengl.advanced_glsl.tutorial'
DepthTesting        = require 'src.tutorials.advanced_opengl.depth_testing.tutorial'
StencilTesting      = require 'src.tutorials.advanced_opengl.stencil_testing.tutorial'

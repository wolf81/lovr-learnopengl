in vec2 TexCoord;

layout(set = 2, binding = 0) uniform texture2D texture1;
layout(set = 2, binding = 1) uniform texture2D texture2;

vec4 lovrmain() 
{
    return mix(getPixel(texture1, UV), getPixel(texture2, UV), 0.2);
}
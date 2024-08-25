layout(set = 2, binding = 1) uniform texture2D myTexture;

vec4 lovrmain() {
    return getPixel(myTexture, UV);
}

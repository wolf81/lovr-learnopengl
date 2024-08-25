layout(set = 2, binding = 0) uniform texture2D texture1;

vec4 lovrmain() {
    return getPixel(texture1, UV);
}

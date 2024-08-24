layout(set = 2, binding = 0) uniform textureCube skybox;

vec4 lovrmain() {

    vec3 I = normalize(PositionWorld - CameraPositionWorld);
    vec3 R = reflect(I, Normal);
    return vec4(getPixel(skybox, R).rgb, 1.0);
}

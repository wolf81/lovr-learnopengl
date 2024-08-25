layout(set = 2, binding = 0) uniform Transforms {
    mat4 transforms[10000];
};

vec4 lovrmain() {
    return Projection * View * transforms[InstanceIndex] * VertexPosition;
}

Constants {
    vec3 lightColor;
    vec3 objectColor;
};

vec4 lovrmain() {
    return vec4(lightColor * objectColor, 1.0);
}

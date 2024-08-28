Constants {
    vec3 matAmbient;
    vec3 matDiffuse;
    vec3 matSpecular;
    float matShininess;

    vec3 lightPosition;
    vec3 lightAmbient;
    vec3 lightDiffuse;
    vec3 lightSpecular;
};

vec4 lovrmain() {
    // ambient
    vec3 ambient = lightAmbient * matAmbient;
    
    // diffuse 
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(lightPosition - PositionWorld);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = lightDiffuse * (diff * matDiffuse);
    
    // specular
    vec3 viewDir = normalize(CameraPositionWorld - PositionWorld);
    vec3 reflectDir = reflect(-lightDir, norm);  
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), matShininess);
    vec3 specular = lightSpecular * (spec * matSpecular);  
        
    vec3 result = ambient + diffuse + specular;
    return vec4(result, 1.0);
}

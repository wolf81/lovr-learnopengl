Constants {
    float shininess;

    vec3 lightPosition;
    vec3 lightAmbient;
    vec3 lightDiffuse;
    vec3 lightSpecular;

    float matShininess;
};

layout(set = 2, binding = 0) uniform texture2D matDiffuse;
layout(set = 2, binding = 1) uniform texture2D matSpecular;
  
vec4 lovrmain()
{
    // ambient
    vec3 ambient = lightAmbient * getPixel(matDiffuse, UV).rgb;
    
    // diffuse 
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(lightPosition - PositionWorld);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = lightDiffuse * diff * getPixel(matDiffuse, UV).rgb;
    
    // specular
    vec3 viewDir = normalize(CameraPositionWorld - PositionWorld);
    vec3 reflectDir = reflect(-lightDir, norm);  
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), matShininess);
    vec3 specular = lightSpecular * spec * getPixel(matSpecular, UV).rgb;  
        
    vec3 result = ambient + diffuse + specular;
    return vec4(result, 1.0);
} 

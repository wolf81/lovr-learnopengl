Constants {
    float matShininess;
};

struct Light {
    vec3 position;  
    vec3 direction;
    float cutOff;
    float outerCutOff;
  
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    
    float constant;
    float linear;
    float quadratic;
};

// material textures

layout(set = 2, binding = 0) uniform texture2D matDiffuse;
layout(set = 2, binding = 1) uniform texture2D matSpecular;

// lights

layout(set = 2, binding = 3) buffer LightCaster {
    Light light;
};

vec4 lovrmain()
{
    // ambient
    vec3 ambient = light.ambient * getPixel(matDiffuse, UV).rgb;
    
    // diffuse 
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(light.position - PositionWorld);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * diff * getPixel(matDiffuse, UV).rgb;  
    
    // specular
    vec3 viewDir = normalize(CameraPositionWorld - PositionWorld);
    vec3 reflectDir = reflect(-lightDir, norm);  
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), matShininess);
    vec3 specular = light.specular * spec * getPixel(matSpecular, UV).rgb;  
    
    // spotlight (soft edges)
    float theta = dot(lightDir, normalize(-light.direction)); 
    float epsilon = (light.cutOff - light.outerCutOff);
    float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);
    diffuse  *= intensity;
    specular *= intensity;
    
    // attenuation
    float distance    = length(light.position - PositionWorld);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));    
    ambient  *= attenuation; 
    diffuse   *= attenuation;
    specular *= attenuation;   
        
    vec3 result = ambient + diffuse + specular;
    return vec4(result, 1.0);
} 

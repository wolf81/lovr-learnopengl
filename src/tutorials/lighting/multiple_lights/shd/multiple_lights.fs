Constants {
    float matShininess;
};

struct DirLight {    
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    vec3 direction;
};

struct PointLight {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    vec3 position;
    
    float constant;
    float linear;
    float quadratic;    
};

struct SpotLight {
    vec3 position;
    vec3 direction;
    float cutOff;
    float outerCutOff;
  
    float constant;
    float linear;
    float quadratic;
  
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;       
};

// material textures

layout(set = 2, binding = 0) uniform texture2D matDiffuse;
layout(set = 2, binding = 1) uniform texture2D matSpecular;

// lights

#define NR_POINT_LIGHTS 4

layout(set = 2, binding = 3) buffer Lights {
    DirLight dirLight;
    SpotLight spotLight;
    PointLight pointLights[NR_POINT_LIGHTS];
};

// function prototypes
vec3 CalcDirLight(DirLight light, vec3 viewDir) 
{
    vec3 lightDir = normalize(-light.direction);
    // diffuse shading
    float diff = max(dot(Normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, Normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), matShininess);
    // combine results
    vec3 ambient = light.ambient * getPixel(matDiffuse, UV).rgb; // shouldn't this be matAmbient?
    vec3 diffuse = light.diffuse * diff * getPixel(matDiffuse, UV).rgb;
    vec3 specular = light.specular * spec * getPixel(matSpecular, UV).rgb;
    return (ambient + diffuse + specular);
}

// calculates the color when using a point light.
vec3 CalcPointLight(PointLight light, vec3 viewDir)
{
    vec3 lightDir = normalize(light.position - PositionWorld);
    // diffuse shading
    float diff = max(dot(Normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, Normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), matShininess);
    // attenuation
    float distance = length(light.position - PositionWorld);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));    
    // combine results
    vec3 ambient = light.ambient * getPixel(matDiffuse, UV).rgb;
    vec3 diffuse = light.diffuse * diff * getPixel(matDiffuse, UV).rgb;
    vec3 specular = light.specular * spec * getPixel(matSpecular, UV).rgb;
    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;
    return (ambient + diffuse + specular);
}

// calculates the color when using a spot light.
vec3 CalcSpotLight(SpotLight light, vec3 viewDir)
{
    vec3 lightDir = normalize(light.position - PositionWorld);
    // diffuse shading
    float diff = max(dot(Normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, Normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), matShininess);
    // attenuation
    float distance = length(light.position - PositionWorld);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));    
    // spotlight intensity
    float theta = dot(lightDir, normalize(-light.direction)); 
    float epsilon = light.cutOff - light.outerCutOff;
    float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);
    // combine results
    vec3 ambient = light.ambient * getPixel(matDiffuse, UV).rgb;
    vec3 diffuse = light.diffuse * diff * getPixel(matDiffuse, UV).rgb;
    vec3 specular = light.specular * spec * getPixel(matSpecular, UV).rgb;
    ambient *= attenuation * intensity;
    diffuse *= attenuation * intensity;
    specular *= attenuation * intensity;
    return (ambient + diffuse + specular);
}

vec4 lovrmain()
{
    vec3 viewDir = normalize(CameraPositionWorld - PositionWorld);
    
    // == =====================================================
    // Our lighting is set up in 3 phases: directional, point lights and an optional flashlight
    // For each phase, a calculate function is defined that calculates the corresponding color
    // per lamp. In the main() function we take all the calculated colors and sum them up for
    // this fragment's final color.
    // == =====================================================
    // phase 1: directional lighting
    vec3 result = CalcDirLight(dirLight, viewDir);

    // phase 2: point lights
    for(int i = 0; i < NR_POINT_LIGHTS; i++) 
    {        
        result += CalcPointLight(pointLights[i], viewDir);    
    }

    // phase 3: spot light
    result += CalcSpotLight(spotLight, viewDir);         
    
    return vec4(result, 1.0);
} 

#version 150

uniform sampler2D DiffuseSampler;
uniform float Time;

in vec2 texCoord;
out vec4 fragColor;

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 pixel = texture(DiffuseSampler, texCoord);
    float redSens = 0.15;
    float greenSens = 1.0;
    float blueSens = 0.4;
    float sourceBrightness = (pixel.r * redSens + pixel.g * greenSens + pixel.b * blueSens) / (redSens + greenSens + blueSens);
    float noiseStrength = 0.075;
    float noise = ((rand(texCoord + Time) * 2.0) - 1.0) * noiseStrength;
    float amplification = 39.0;
    float finalVal = log(max(sourceBrightness + noise, 0.0) * amplification + 1.0) / log(amplification + 1.0);
    vec3 phosphorColor = vec3(0.639215, 1.0, 0.0);
    fragColor = vec4(phosphorColor * finalVal, 1.0);
}
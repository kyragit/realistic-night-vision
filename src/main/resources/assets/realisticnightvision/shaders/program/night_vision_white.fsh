#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D BrightnessSampler;
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
    float noiseStrength = 0.035;
    float noise = ((rand(texCoord + Time) * 2.0) - 1.0) * noiseStrength;
    float amplification = 51.0;
    float finalVal = log(max(sourceBrightness + noise, 0.0) * amplification + 1.0) / log(amplification + 1.0);
    finalVal = mix(finalVal, max(texture(BrightnessSampler, texCoord).r, finalVal), 0.75);
    vec3 phosphorColor = vec3(0.53725, 0.839215, 0.807843);
    fragColor = vec4(phosphorColor * finalVal, 1.0);
}
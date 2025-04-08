#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D BrightnessSampler;
uniform float Time;
uniform vec3 colorSensitivity;
uniform float noiseStrength;
uniform float amplification;
uniform vec3 phosphorColor;
uniform float anomalyChance;
uniform float anomalyStrength;

in vec2 texCoord;
out vec4 fragColor;

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 pixel = texture(DiffuseSampler, texCoord);
    float sourceBrightness = dot(pixel.rgb, colorSensitivity) / (colorSensitivity.r + colorSensitivity.g + colorSensitivity.b);
    float noise = ((rand(texCoord + Time) * 2.0) - 1.0) * noiseStrength;
    float newRand = rand(vec2(noise, pixel.g));
    float anom = ceil(anomalyChance - newRand);
    float finalVal = log(max(sourceBrightness + noise, 0.0) * amplification + 1.0) / log(amplification + 1.0);
    finalVal = mix(finalVal, max(texture(BrightnessSampler, texCoord).r, finalVal), 0.75);
    fragColor = mix(vec4(phosphorColor * finalVal, 1.0), vec4(1.0), anom * anomalyStrength);
}
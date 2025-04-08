#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D BrightnessCopySampler;

uniform float Time;
uniform float speed;

in vec2 texCoord;
out vec4 fragColor;

void main() {
    vec3 pixel = texture(DiffuseSampler, texCoord).rgb;
    float inBrightness = texture(BrightnessCopySampler, texCoord).r;
    float inTime = texture(BrightnessCopySampler, texCoord).g;
    float delta = max(Time - inTime, 0.0);
    float redSens = 0.15;
    float greenSens = 1.0;
    float blueSens = 0.4;
    float texBrightness = (pixel.r * redSens + pixel.g * greenSens + pixel.b * blueSens) / (redSens + greenSens + blueSens);
    texBrightness = (texBrightness * texBrightness * texBrightness * texBrightness * 4.0) - 0.1;
    fragColor.r = clamp(mix(inBrightness, texBrightness, delta * speed), 0.0, 1.0);
    fragColor.g = Time;
}
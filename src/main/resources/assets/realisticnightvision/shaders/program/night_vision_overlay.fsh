#version 150

uniform sampler2D DiffuseSampler;

uniform vec2 InSize;
uniform vec2 OutSize;

in vec2 texCoord;
out vec4 fragColor;

void main() {
    vec2 p1 = vec2(OutSize.x / 3.0, OutSize.y / 2.0);
    vec2 p2 = vec2(OutSize.x * (2.0 / 3.0), OutSize.y / 2.0);
    float dist1 = distance(texCoord * OutSize, p1);
    float dist2 = distance(texCoord * OutSize, p2);
    float dist = min(dist1, dist2);
    dist /= OutSize.y;
    vec4 inColor = texture(DiffuseSampler, texCoord);
    float radius = 0.55;
    float mult = 1.0 - min(dist / radius, 1.0);
    mult = min(12.0 * log(mult + 1.0), 1.0);
    fragColor = inColor * mult;
}
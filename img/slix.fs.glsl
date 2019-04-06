#version 330 core

in vec4 pos;
out vec4 color;

uniform vec2 dims;
uniform float width;

uniform sampler2D shampler;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

void main() {
    // use screen position as texcoords
    vec2 tc = pos.st;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    vec3 pixel = texture(shampler, tc).rgb;
    vec3 s = rgb2hsv(pixel);

    vec3 pixel2 = texture(shampler, tc + length(s)).rgb;
    vec3 s2 = rgb2hsv(pixel);

    float f = distance(s, s2);

    float d = distance(s2.gb, s.br);
    float e = distance(s.rg, vec2(d));

    float g = length(texture(shampler, tc + f * e * d + 1.0));

    vec4 prelook = texture(shampler, tc + vec2(-d*g, e*g));


    color = texture(shampler, tc + fract(f * 0.001)) * (fract(e * f) + 1.0) - ((prelook * g) / 5.0);
    color += 0.03;
}

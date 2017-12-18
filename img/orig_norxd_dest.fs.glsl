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
    // this is a hack to get proper texture coords from
    // the position array, never wrote proper texcoords
    // into my slab :/
    vec2 tc = pos.st;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    // constant zoom
    float scale_factor = 1.001;

    tc -= vec2(0.5);
    tc *= mat2(scale_factor, 0.0, 0.0, scale_factor);
    tc += vec2(0.5);

    vec3 pixel = texture(shampler, tc).rgb;
    vec3 s = rgb2hsv(pixel);

    float angle = ((tc.s + 0.4) * 0.04) * ((s.r * s.g) - 0.5);
    angle *= 0.025;

    float xscale = 1. + (-s.r * 0.0009);
    float yscale = 1. + (s.g  * 0.0009);

    tc -= vec2(0.5);
    tc *= mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
    tc += vec2(0.5);

    tc -= vec2(0.5);
    tc *= mat2(xscale, 0., 0., yscale);
    tc += vec2(0.5);


    color = texture(shampler, tc);
}

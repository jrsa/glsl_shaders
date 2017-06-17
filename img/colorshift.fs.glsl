#version 330 core

in vec4 pos;
out vec4 color;

uniform vec2 dims;
uniform sampler2D shampler;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}


vec3 hsv2rgb(vec3 color) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(color.xxx + K.xyz) * 6.0 - K.www);
    vec3 rgb = vec3(color.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), color.y));

    return rgb;
}

void main() {
    // halve coordinate space
    vec2 tc = pos.xy;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    vec4 src = texture(shampler, tc);

    vec3 hsv = rgb2hsv(src.rgb);

    // hue
    hsv.r *= 0.2;
    hsv.r += (hsv.g * 0.2) + 0.2;

    // saturation
    hsv.g = 1.0;
    
    // value
    hsv.b *= 1.0;

    color = vec4(hsv2rgb(hsv), src.r/src.b/src.g);
    // color = src;
}
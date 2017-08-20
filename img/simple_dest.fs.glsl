#version 330 core

in vec4 pos;
out vec4 color;
uniform sampler2D shampler;

// resolution, reciprocal of this gives the pixel size in openGL coordinates
uniform vec2 dims;

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

vec3 hueshift(vec3 color, float amt) {
    vec3 result = color;
    color = rgb2hsv(color);
    color.r += amt;
    color.b += amt/6.0; 
    return hsv2rgb(color);
}

void main() {
    // halve coordinate space
    vec2 tc = pos.xy;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    vec3 hsv_in = rgb2hsv(texture(shampler, tc).rgb);

    float amt = 0.0005 * hsv_in.b;
    float xscale = 1.0 - ((hsv_in.r + 0.5) * amt);
    float yscale = 1.0 - (hsv_in.g * amt);

    float angle = 0.001625* tc.t;

    tc *= mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
    tc *= mat2(xscale, 0.0, 0.0, yscale);

    vec2 offs = vec2(1. / dims.x, 1. / dims.y);
    float width = 2.0 / (hsv_in.r + 0.5);

    vec2 tc1 = tc + vec2(0.0, -offs.t * width);
    vec2 tc3 = tc + vec2(-offs.s * width, 0.0);
    vec2 tc5 = tc + vec2(offs.s * width, 0.0);
    vec2 tc7 = tc + vec2(0.0, offs.t * width);

    vec4 center = texture(shampler, tc);
    vec4 col1 = texture(shampler, tc1);
    vec4 col3 = texture(shampler, tc3);
    vec4 col5 = texture(shampler, tc5);
    vec4 col7 = texture(shampler, tc7);

    // col1.rgb = hueshift(col1.rgb, 0.01 * col7.g);
    // col3.rgb = hueshift(col3.rgb, 0.01 * col1.r);
    // col5.rgb = hueshift(col5.rgb, 0.01 * col3.g);
    // col7.rgb = hueshift(col7.rgb, 0.01 * col5.r);

    color = ( col1 + col3 + col5 + col7) * 0.25;
}
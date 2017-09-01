#version 330 core

in vec4 pos;
out vec4 color;

uniform vec2 dims;
uniform float width;
//uniform float amp;
uniform float scaleCoef;

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
    vec2 tc = pos.st;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    float scale_factor = (abs(pos.s) * 0.009) + 0.999;
    scale_factor += (-abs(pos.t) * 0.009) ;
    tc -= vec2(0.5);
    tc *= mat2(scale_factor, 0.0, 0.0, scale_factor);
    tc += vec2(0.5);

    vec3 pixel = texture(shampler, tc).rgb;
    vec3 pixel_hsv = rgb2hsv(pixel);

    mat2 sca = mat2(1. + pixel_hsv.g, 0., 0., 1. + pixel_hsv.r);

    float angle = 0.01 * pixel_hsv.g;
	mat2 rot = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));

    vec2 offs = vec2(1. / dims.x, 1. / dims.y);
	offs *= mat2(cos(angle), sin(width), -sin(width), cos(angle));

    tc *= sca;
    tc *= rot;
    vec2 src = tc;

    vec2 tc4 = src;
    vec2 tc1 = src + vec2(0.0, -offs.t * width);
    vec2 tc3 = src + vec2(-offs.s * width, 0.0);
    vec2 tc5 = src + vec2(offs.s * width, 0.0);
    vec2 tc7 = src + vec2(0.0, offs.t * width);

    vec2 tc0 = src + vec2(-offs.s * width, -offs.t * width);
    vec2 tc2 = src + vec2(offs.s * width, -offs.t * width);
    vec2 tc6 = src + vec2(-offs.s * width, offs.t * width);
    vec2 tc8 = src + vec2(offs.s * width, offs.t * width);

    vec4 col1 = texture(shampler, tc1);
    vec4 col3 = texture(shampler, tc3);
    vec4 col5 = texture(shampler, tc5);
    vec4 col7 = texture(shampler, tc7);

    pixel_hsv.r += 0.001;

    vec4 p = vec4(tc.y, tc.x, 0.0, 1.0);
    p += .2;

    float d = dot(p, vec4(pixel_hsv * 3.50, 1.0));

    // scale and offset `d`
    d *= 0.15;
    d += 0.2;
    
    pixel_hsv.r += (d * 0.0024);
    pixel_hsv.g -= (d * 0.0012);

    float amp = 16.0;
    color += vec4(hsv2rgb(pixel_hsv), 1.0) + (d * 0.1) - ((col1 + col3 + col5 + col7) / amp);
}

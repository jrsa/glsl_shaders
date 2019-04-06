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
    float inScale = 0.4989;
    tc *= mat2(inScale, 0.0, 0.0, inScale);

    float inRot = 0.0005;
    tc *= mat2(cos(inRot), sin(inRot), -sin(inRot), cos(inRot));
    tc += vec2(0.5);

    vec4 pixel = texture(shampler, tc);
    vec3 s = rgb2hsv(pixel.rgb);

    float transformFactor = 0.89;
    float scaleAmt = s.r * transformFactor;
    float angle    = s.r * transformFactor;

    mat2 sca = mat2(1. - scaleAmt, 0., 0., 1. - scaleAmt);
	mat2 rot = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));

    tc *= sca;
    tc *= rot;
    vec2 src = tc;

    float width = 1.3;
    vec2 offs = vec2(1. / dims.x, 1. / dims.y);

    vec2 tc4 = src;
    vec2 tc1 = src + vec2(0.0, -offs.t * width);
    vec2 tc3 = src + vec2(-offs.s * width, 0.0);
    vec2 tc5 = src + vec2(offs.s * width, 0.0);
    vec2 tc7 = src + vec2(0.0, offs.t * width);

    vec2 tc0 = src + vec2(-offs.s * width, -offs.t * width);
    vec2 tc2 = src + vec2(offs.s * width, -offs.t * width);
    vec2 tc6 = src + vec2(-offs.s * width, offs.t * width);
    vec2 tc8 = src + vec2(offs.s * width, offs.t * width);

    vec4 col0 = texture(shampler, tc0);
    vec4 col1 = texture(shampler, tc1);
    vec4 col2 = texture(shampler, tc2);
    vec4 col3 = texture(shampler, tc3);
    vec4 col4 = texture(shampler, tc4);
    vec4 col5 = texture(shampler, tc5);
    vec4 col6 = texture(shampler, tc6);
    vec4 col7 = texture(shampler, tc7);
    vec4 col8 = texture(shampler, tc8);

    // HUE SHIFT
    s.r += 0.01;

    // MAP SCALEs
    float scale = 0.66;
    vec2 maptc = tc;
    maptc *= mat2(scale, 0., 0., scale);

    // MAP gOFFSET
    maptc += 2.11; 
    vec4 grad = vec4(maptc.s, maptc.t, 0.0, 1.0);

    float d = dot(grad, vec4(s, 0.23)) * dot(grad, vec4(s * 3.50, 1.0));

    // FINAL GAIN
    float gain = 0.2 * d;

    // color = vec4(hsv2rgb(s), pixel.a) * gain - (col1 + col3 + col5 + col7);
    color = vec4(hsv2rgb(s), pixel.a) * gain - (col1 + col3 + col5 + col7);
}

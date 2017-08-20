#version 330 core

in vec4 pos;
out vec4 color;

uniform vec2 dims;
uniform float width;

uniform sampler2D shampler;

// -----------------------------------------------------
// functions to transform RGV to HSV and back
// -----------------------------------------------------
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
    // -----------------------------------------------------
    // get texcoords, (0 to 1) from positions, (-1 to 1)
    // -----------------------------------------------------
    vec2 tc = pos.st;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    // -----------------------------------------------------
    // get hsv of center pixel
    // -----------------------------------------------------
    vec3 pixel = texture(shampler, tc).rgb;
    vec3 s = rgb2hsv(pixel);

    // -----------------------------------------------------
    // scale/rotate texture coordinate based on hue
    // -----------------------------------------------------
    mat2 sca = mat2(1.- (s.r * 1.5), 0., 0., 1. - (s.r * 1.5));

    float angle = 0.015 * s.r;
	mat2 rot = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));

    tc *= sca;
    tc *= rot;

    // -----------------------------------------------------
    // 4 point convolution filter
    // -----------------------------------------------------
    float width = 1.0;
    vec2 step = vec2(1. / dims.x, 1. / dims.y);

    vec2 offs[4];
    offs[0] = vec2(0.0, -step.t * width);
    offs[1] = vec2(-step.s * width, 0.0);
    offs[2] = vec2(step.s * width, 0.0);
    offs[3] = vec2(0.0, step.t * width);

    float kern[4];
    kern[0] = 0.4;
    kern[1] = 0.8;
    kern[2] = 0.4;
    kern[3] = 0.8;

    vec4 sum;
    for (int i = 0; i < 4; i++) {
        sum += texture(shampler, tc + offs[i]) * kern[i];
    }
    
    // -----------------------------------------------------
    // bitch craft
    // -----------------------------------------------------
    float d = dot(tc.yxxy, vec4(s, 0.23));
    d *= dot(tc.xyyx, vec4(s * 3.50, 1.0));
    // d *= 2.01;
    d += 1.0;

    // -----------------------------------------------------
    // hue shift
    // -----------------------------------------------------
    s.r += (d * 0.01);

    color = vec4(hsv2rgb(s), 1.0) * d - sum;
}

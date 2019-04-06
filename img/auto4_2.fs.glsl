#version 330 core

in vec4 pos;
out vec4 color;

uniform sampler2D shampler;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec4 iter(sampler2D img, vec2 coord) {
    vec2 tc = coord;

    // constant zoom/rotate
    float scale_factor = 1.001;
    float fixangle = -0.001;
    tc -= vec2(0.5);
    tc *= mat2(scale_factor, 0.0, 0.0, scale_factor);
    tc *= mat2(cos(fixangle), sin(fixangle), -sin(fixangle), cos(fixangle));
    tc += vec2(0.5);

    tc -= vec2(1.0 / 3200.0, 1.0 / 1200.0); // offset displace amount below

    vec3 pixel = texture(img, tc).rgb;
    vec3 s = rgb2hsv(pixel);

    float d = length(s.bg);
    float e = length(s.rb);

    // get a neighboring pixel based on the above value
    float prelook_amount = 1.0;
    vec4 prelook = texture(img, tc + vec2(-d * prelook_amount, -e * prelook_amount));
    
    // don't look at me, idk man
    d *= prelook.b;
    d += length(prelook) / 4;
    d -= length(s) / 4;

    // second texture fetch which we will use for the output
    float displace_amount = 0.003;
    vec4 result = texture(img,  tc + vec2(d * displace_amount, e * displace_amount));

    // spatial differencing using intermediate pixel value (`prelook`)
    result += 0.0175 * vec4(0.5, 0.333, 0.666, 0.0);
    result -= (prelook * 0.04);
    return result;
}

void main() {
    // use screen position as texcoords
    vec2 tc = pos.st;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    color = iter(shampler, tc);
}

out vec4 fragColor;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec4 iter(sampler2D img, vec2 coord) {
    vec4 color;
    vec2 tc = coord;
    vec3 s = rgb2hsv(texture(img, coord).rgb);

    float d = length(s.bg);
    float e = length(s.rb);

    // get a neighboring pixel based on the above value
    float prelook_amount = 1.9;
    vec4 prelook = texture(img, coord + vec2(-d * prelook_amount, -e * prelook_amount));
    
    // don't look at me, idk man
    d *= prelook.r;
    d += length(prelook) / 4.0;
    d -= length(s) / 4.0;

    // second texture fetch which we will use for the output
    float displace_amount = 0.001;
    color = texture(img, tc + vec2(d * displace_amount , e * displace_amount));

    // spatial differencing using intermediate pixel value (`prelook`)
    color += vec4(0.0187, 0.0187, 0.0362, 0.0187);
    color -= (prelook * 0.1);
    return color;
}

void main() {
    fragColor = iter(sTD2DInputs[0], vUV.st);
}

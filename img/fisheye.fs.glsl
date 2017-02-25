#version 330 core

in vec4 pos;
out vec4 color;

uniform vec2 dims;

uniform sampler2D shampler;

// adapted from andrew benson's jitter implementation
void main() {
    //
    float EPSILON = .0000111;
    float lensradius = 2.2;
    float signcurvature = 0.3;
    float unk = 1.4427;
    //

    float curvature = abs(signcurvature);
    float extent = lensradius;
    float optics = extent / log2(curvature * extent + 1.0) / unk;

    vec2 tc = pos.xy;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    float radius = sqrt(tc.x * tc.x + tc.y * tc.y);

    float cosangle = tc.x / radius;
    float sinangle = tc.y / radius;

    float rad1 = (exp2((radius / optics) * unk) - 4.0) / curvature;
    float rad2 = optics * log2(1.0 + curvature * radius) / unk;
    float newradius = signcurvature > 0.0 ? rad1 : rad2;

    newradius = rad1;

    vec2 FE = vec2(newradius * cosangle, newradius * sinangle);
    FE = radius <= extent ? FE : tc;
    FE = curvature < EPSILON ? tc : FE;

    color = texture(shampler, tc);
}
#version 330 core

in vec4 pos;
out vec4 color;

uniform vec2 dims;

uniform sampler2D shampler;

// adapted from andrew benson's jitter implementation
void main() {
    //
    float EPSILON = 0.000011;
    float lensradius = 2.2;
    float signcurvature = 10.0;
    float unk = 1.4427;
    //

    float curvature = abs(signcurvature);
    float extent = lensradius;
    float optics = extent / log2(curvature * extent + 1.0) / unk;

    vec2 normalizeTD = pos.xy;
    normalizeTD *= mat2(0.5, 0.0, 0.0, 0.5);
    normalizeTD += vec2(0.5);
    
    vec2 PP = normalizeTD - vec2(0.5, 0.5);
    float P0 = PP.x;
    float P1 = PP.y;
    float radius = sqrt(P0 * P0 + P1 * P1);

    float cosangle = P0 / radius;
    float sinangle = P1 / radius;

    float rad1, rad2, newradius;
    rad1 = (exp2((radius / optics) * unk) - 4.0) / curvature;
    rad2 = optics * log2(1.0 + curvature * radius) / unk;
    newradius = signcurvature > 0.0 ? rad1 : rad2;

    vec2 FE = vec2(newradius * cosangle + 0.5, newradius * sinangle + 0.5);
    FE = radius <= extent ? FE : normalizeTD;
    FE = curvature < EPSILON ? normalizeTD : FE;

    color = texture(shampler, FE);
}
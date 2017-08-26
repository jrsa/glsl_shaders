#version 410 core

in vec2 vel;
out vec4 outColor;

vec3 hsv2rgb(vec3 color) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(color.xxx + K.xyz) * 6.0 - K.www);
    vec3 rgb = vec3(color.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), color.y));

    return rgb;
}

void main()
{
    outColor = vec4(hsv2rgb(vec3((vel.x * 0.5) + 0.7, 1.0, 1.0)), 1.0);
}
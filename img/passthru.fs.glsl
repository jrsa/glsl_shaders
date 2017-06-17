#version 330 core

in vec4 pos;
out vec4 color;

uniform vec2 dims;
uniform sampler2D shampler;

void main() {
    // halve coordinate space
    vec2 tc = pos.xy;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    color = texture(shampler, tc);
}
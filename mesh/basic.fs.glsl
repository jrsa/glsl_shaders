#version 330 core

in vec4 pos;
out vec4 color;

uniform float time;

void main() {
    color = vec4((pos.y * -time) + 0.5, 1.0 - cos(time / 10.0), sin(time), 1.0);
}

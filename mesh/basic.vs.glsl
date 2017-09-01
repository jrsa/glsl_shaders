#version 330 core

layout(location = 0) in vec3 vertexPosition;

uniform float time;
uniform vec2 mouse;

out vec4 pos;

void main(void)
{
    gl_Position.xyz = vertexPosition;

    // gl_Position.x += cos(time / (50.0 * mouse.x));
    // gl_Position.y += sin(time / (50.0 * mouse.y));
    gl_Position.x += sin(time * 3.20);
    gl_Position.y += sin(time * 2.30);

    gl_Position.w = 1.0;

    pos = gl_Position;
}

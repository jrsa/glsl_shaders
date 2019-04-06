#version 330 core

layout(location = 0) in vec3 vertexPosition;

uniform mat4 model;
uniform mat4 view;
uniform mat4 proj;

uniform vec2 mouse;

out vec4 prePos;
out vec4 postPos;

void main(void)
{
    prePos = vec4(vertexPosition, 1.0);
    postPos = proj * view * model * prePos;
    postPos.xy += mouse;
    gl_Position = postPos;
}

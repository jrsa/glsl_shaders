#version 410 core

layout(location = 0) in vec2 position;
layout(location = 1) in vec2 velocity;
layout(location = 2) in vec2 originalPos;

out vec2 outPosition;
out vec2 outVelocity;
out float dist;

uniform float time;
uniform vec2 mousePos;

void main()
{
    vec2 center = vec2(0.1, 0.1);
    center += noise3(vec3(originalPos, time)).xy;
    vec2 acceleration = .127f * normalize(center -position);

    vec2 newVelocity = originalPos - position;
    newVelocity = velocity + acceleration * time;
    
    vec2 newPosition = position + newVelocity * time;
    outPosition = newPosition;
    outVelocity = newVelocity;
    dist = distance(newPosition, originalPos);
    gl_Position = vec4(newPosition, 0.0, 1.0);
}
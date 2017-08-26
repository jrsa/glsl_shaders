#version 410 core

layout(location = 0) in vec2 position;
layout(location = 1) in vec2 velocity;
layout(location = 2) in vec2 originalPos;

out vec2 outPosition;
out vec2 outVelocity;

out vec2 vel;

uniform float time;
uniform vec2 mousePos;

void main()
{
    vec2 mousePos = mousePos;
    mousePos = vec2(0.0, 0.0);
    mousePos *= noise2(originalPos);

    vec2 newVelocity = originalPos - position;

    vec2 acceleration = .25f * normalize(mousePos -position);
    newVelocity = velocity + acceleration * time;
    
    if (length(newVelocity) > 1.0f)
        newVelocity = normalize(newVelocity);

    vec2 newPosition = position + newVelocity * time;
    outPosition = newPosition;
    outVelocity = newVelocity;
    vel = newVelocity;
    gl_Position = vec4(newPosition, 0.0, 1.0);
}
#version 410 core

layout(location = 0) in vec2 position;
layout(location = 1) in vec2 velocity;
layout(location = 2) in vec2 originalPos;

out vec2 outPosition;
out vec2 outVelocity;

uniform float time;
uniform vec2 mousePos;

void main()
{
    // Points move towards their original position...
    vec2 newVelocity = originalPos - position;

    // ... unless the mouse is nearby. In that case, they move towards the mouse.
    if (length(mousePos - originalPos) < 0.75f) {
        vec2 acceleration = 1.5f * normalize(mousePos - position);
        newVelocity = velocity + acceleration * time;
    }
    
    if (length(newVelocity) > 1.0f)
        newVelocity = normalize(newVelocity);

    vec2 newPosition = position + newVelocity * time;
    outPosition = newPosition;
    outVelocity = newVelocity;
    gl_Position = vec4(newPosition, 0.0, 1.0);
}
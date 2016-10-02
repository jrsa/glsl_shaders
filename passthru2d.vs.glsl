#version 330 core

layout(location = 0) in vec2 vertexPosition_modelspace;
layout(location = 1) in vec2 TexCoord;

void main(void) {
  gl_Position.xy = vertexPosition_modelspace;
  gl_Position.z = 0.5;
  gl_Position.w = 1.0;
}


#version 330 core

in vec4 pos;
out vec4 color;

void main(void){
    color = vec4(noise3(pos.xyz * 5.0), 0.0) * 3.0;
    // color = vec4(0.0);
}

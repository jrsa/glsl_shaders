#version 330 core

in vec4 pos;
out vec4 color;

uniform sampler2D shampler;

void main() {
    vec2 tc = pos.st;
    tc *= mat2(0.5, 0.0, 0.0, 0.5);
    tc += vec2(0.5);

    vec2 center = texture(shampler, tc).rb; 
    tc -= center;
    tc *= mat2(0.999, 0.0, 0.0, 0.999);
    tc += center;
            
    color = texture(shampler, tc);

    color.g = mod(3.4 * length(color.rb), 0.5) + 0.5;    
    color.b = mod(color.b + (length(center) / 1000.0), 1.0);
    color.r = mod(color.r + (length(color.rgb) / 1000.0), 1.0);
}

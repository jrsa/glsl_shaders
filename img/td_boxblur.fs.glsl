out vec4 fragColor;

void main() {
    vec2 tc = vUV.st;
    vec2 offs = uTD2DInfos[0].res.xy; 
    vec4 color;

    vec2 src = tc;

    float width = 0.5;
    vec2 tc4 = src;
    vec2 tc1 = src + vec2(0.0, -offs.t * width);
    vec2 tc3 = src + vec2(-offs.s * width, 0.0);
    vec2 tc5 = src + vec2(offs.s * width, 0.0);
    vec2 tc7 = src + vec2(0.0, offs.t * width);

    vec2 tc0 = src + vec2(-offs.s * width, -offs.t * width);
    vec2 tc2 = src + vec2(offs.s * width, -offs.t * width);
    vec2 tc6 = src + vec2(-offs.s * width, offs.t * width);
    vec2 tc8 = src + vec2(offs.s * width, offs.t * width);

    vec4 col0 = texture(sTD2DInputs[0], tc0);
    // vec4 col1 = texture(sTD2DInputs[0], tc1);
    vec4 col2 = texture(sTD2DInputs[0], tc2);
    // vec4 col3 = texture(sTD2DInputs[0], tc3);
    vec4 col4 = texture(sTD2DInputs[0], tc4);
    // vec4 col5 = texture(sTD2DInputs[0], tc5);
    vec4 col6 = texture(sTD2DInputs[0], tc6);
    // vec4 col7 = texture(sTD2DInputs[0], tc7);
    vec4 col8 = texture(sTD2DInputs[0], tc8);

    // pass transformed pixel out with no convolution
//    color = texture(shampler, tc);

    // color = (col4 + col1 + col3 + col5 + col7) * 0.2;
    color = (col4 + col2 + col0 + col6 + col8) * 0.2;
//    color = col4 * 4.1 - (col1 + col3 + col5 + col7);
    fragColor = color;
}

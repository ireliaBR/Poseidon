
#version 300 es
precision mediump float;

in highp vec2 textureCoordinate;
uniform sampler2D inputTexture;
uniform lowp float intensity;

out vec4 fragColor;

// Values from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham
const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

void main() {
    lowp vec4 textureColor = texture(inputTexture, textureCoordinate);
    lowp float luminance = dot(textureColor.rgb, luminanceWeighting);
    lowp vec3 greyScaleColor = vec3(luminance);
    
    fragColor = vec4(mix(greyScaleColor, textureColor.rgb, intensity), textureColor.w);
}

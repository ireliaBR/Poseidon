
#version 300 es
precision mediump float;

in highp vec2 textureCoordinate;
uniform sampler2D inputTexture;
uniform lowp float intensity;

out vec4 fragColor;

void main() {
    lowp vec4 textureColor = texture(inputTexture, textureCoordinate);
    fragColor = vec4(((textureColor.rgb - vec3(0.5)) * intensity + vec3(0.5)), textureColor.w);
}


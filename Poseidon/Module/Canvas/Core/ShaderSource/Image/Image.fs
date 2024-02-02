
#version 300 es
precision mediump float;

uniform sampler2D texture1;

in vec2 TexCoord;
out vec4 fragColor;

void main()
{
    fragColor = texture(texture1, TexCoord);
}

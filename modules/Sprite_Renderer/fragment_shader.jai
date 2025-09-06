#scope_module

FRAGMENT_SHADER :: #string GLSL
#version 330 core

in vec2 TexCoord;
in vec4 InstanceColor;

out vec4 FragColor;

uniform sampler2D spriteTexture;

void main()
{
    FragColor = texture(spriteTexture, TexCoord) * InstanceColor;
}
GLSL

#scope_module

FRAGMENT_SHADER :: #string GLSL
#version 330 core

in vec2 textureCoordinates;
in vec4 instanceColor;

out vec4 fragmentColor;

uniform sampler2D spriteTexture;

void main()
{
    fragmentColor = texture(spriteTexture, textureCoordinates) * instanceColor;
}
GLSL

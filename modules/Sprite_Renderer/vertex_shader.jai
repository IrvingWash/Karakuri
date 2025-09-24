#scope_module

VERTEX_SHADER :: #string GLSL
#version 330 core

layout (location = 0) in vec2 aPosition;
layout (location = 1) in vec2 aTexture;

layout (location = 2) in vec2 iPosition;
layout (location = 3) in vec2 iScale;
layout (location = 4) in float iRotation;
layout (location = 5) in vec4 iColor;
layout (location = 6) in vec2 iOrigin;

out vec2 textureCoordinates;
out vec4 instanceColor;

uniform float pixelsPerUnit;
uniform float textureWidth;
uniform float textureHeight;
uniform mat4 projection;
uniform mat4 view;

void main()
{
    mat2 rotation = mat2(
        cos(iRotation),
        -sin(iRotation),
        sin(iRotation),
        cos(iRotation)
    );

    vec2 scaled = (aPosition + iOrigin)
        * iScale
        * vec2(textureWidth / pixelsPerUnit, textureHeight / pixelsPerUnit);
    vec2 rotated = rotation * scaled;
    vec2 worldPosition = iPosition + rotated;

    gl_Position = projection * view * vec4(worldPosition, 0.0, 1.0);

    textureCoordinates = aTexture;
    instanceColor = iColor;
}
GLSL

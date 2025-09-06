#scope_module

VERTEX_SHADER :: #string GLSL
#version 330 core

layout (location = 0) in vec2 aPos;
layout (location = 1) in vec2 aTex;

layout (location = 2) in vec2 iPos;
layout (location = 3) in vec2 iScale;
layout (location = 4) in float iRotation;
layout (location = 5) in vec4 iColor;

out vec2 TexCoord;
out vec4 InstanceColor;

uniform mat4 projection;

void main()
{
    mat2 rotation = mat2(
        cos(iRotation),
        -sin(iRotation),
        sin(iRotation),
        cos(iRotation)
    );

    vec2 scaled = aPos * iScale;
    vec2 rotated = rotation * scaled;
    vec2 worldPos = iPos + rotated;

    gl_Position = projection * vec4(worldPos, 0.0, 1.0);

    TexCoord = aTex;
    InstanceColor = iColor;
}
GLSL

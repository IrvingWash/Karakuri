#scope_module

DYNAMIC_BUFFER_SIZE :: 100_000;

Quad_Mesh :: struct {
    vertices: [16]float : .[
        // position     text. coords
        -0.5, -0.5,     0.0, 0.0,
         0.5, -0.5,     1.0, 0.0,
         0.5,  0.5,     1.0, 1.0,
        -0.5,  0.5,     0.0, 1.0
    ];
    indices: [6]u32 : .[
        0, 1, 2,
        2, 3, 0
    ];
    vao: u32;
    vbo: u32;
    ebo: u32;
    instance_vbo: u32;
}

Sprite_Instance :: struct {
    position: Vector2;
    scale: Vector2;
    rotation: float;
    color: Vector4;
}

create_quad_mesh :: () -> Quad_Mesh {
    mesh: Quad_Mesh;

    using gl;

    glGenVertexArrays(1, *mesh.vao);
    glGenBuffers(1, *mesh.vbo);
    glGenBuffers(1, *mesh.ebo);
    glGenBuffers(1, *mesh.instance_vbo);

    glBindVertexArray(mesh.vao);

    // VBO
    glBindBuffer(GL_ARRAY_BUFFER, mesh.vbo);
    glBufferData(
        GL_ARRAY_BUFFER,
        size_of(type_of(mesh.vertices.data)) * mesh.vertices.count,
        mesh.vertices.data,
        GL_STATIC_DRAW,
    );

    // EBO
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mesh.ebo);
    glBufferData(
        GL_ELEMENT_ARRAY_BUFFER,
        size_of(type_of(mesh.indices.data)) * mesh.indices.count,
        mesh.indices.data,
        GL_STATIC_DRAW,
    );

    // Position
    glVertexAttribPointer(
        0,
        2,
        GL_FLOAT,
        GL_FALSE,
        4 * size_of(float),
        cast(*void) 0,
    );
    glEnableVertexAttribArray(0);

    // Texture coordinates
    glVertexAttribPointer(
        1,
        2,
        GL_FLOAT,
        GL_FALSE,
        4 * size_of(float),
        cast(*void) (2 * size_of(float)),
    );
    glEnableVertexAttribArray(1);

    // Instance VBO
    glBindBuffer(GL_ARRAY_BUFFER, mesh.instance_vbo);
    glBufferData(
        GL_ARRAY_BUFFER,
        DYNAMIC_BUFFER_SIZE * size_of(Sprite_Instance),
        null,
        GL_DYNAMIC_DRAW,
    );

    // Position
    glVertexAttribPointer(
        2,
        2,
        GL_FLOAT,
        GL_FALSE,
        size_of(Sprite_Instance),
        cast(*void) offset_of(Sprite_Instance, "position"),
    );
    glEnableVertexAttribArray(2);
    glVertexAttribDivisor(2, 1);

    // Scale
    glVertexAttribPointer(
        3,
        2,
        GL_FLOAT,
        GL_FALSE,
        size_of(Sprite_Instance),
        cast(*void) offset_of(Sprite_Instance, "scale"),
    );
    glEnableVertexAttribArray(3);
    glVertexAttribDivisor(3, 1);

    // Rotation
    glVertexAttribPointer(
        4,
        1,
        GL_FLOAT,
        GL_FALSE,
        size_of(Sprite_Instance),
        cast(*void) offset_of(Sprite_Instance, "rotation"),
    );
    glEnableVertexAttribArray(4);
    glVertexAttribDivisor(4, 1);

    // Color
    glVertexAttribPointer(
        5,
        4,
        GL_FLOAT,
        GL_FALSE,
        size_of(Sprite_Instance),
        cast(*void) offset_of(Sprite_Instance, "color"),
    );
    glEnableVertexAttribArray(5);
    glVertexAttribDivisor(5, 1);

    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    return mesh;
}

destroy_quad_mesh :: (mesh: Quad_Mesh) {
    glDeleteVertexArrays(1, *mesh.vao);
    glDeleteBuffers(1, *mesh.vbo);
    glDeleteBuffers(1, *mesh.ebo);
}

#scope_file

offset_of :: ($T: Type, $member: string) -> int {
    for type_info(T).members {
        if it.name == member{
            return it.offset_in_bytes;
        }
    }

    assert(false, "Type '%' does not have member '%'", T, member);
    return -1;
}

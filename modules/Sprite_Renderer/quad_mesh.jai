#scope_module

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
}

create_quad_mesh :: () -> Quad_Mesh {
    mesh: Quad_Mesh;

    using gl;

    glGenVertexArrays(1, *mesh.vao);
    glGenBuffers(1, *mesh.vbo);
    glGenBuffers(1, *mesh.ebo);

    glBindVertexArray(mesh.vao);

    // VBO
    glBindBuffer(GL_ARRAY_BUFFER, mesh.vbo);
    glBufferData(
        GL_ARRAY_BUFFER,
        size_of(type_of(mesh.vertices.data)) * mesh.vertices.count, // @TODO try size_of(type_of(mesh.vertices))
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

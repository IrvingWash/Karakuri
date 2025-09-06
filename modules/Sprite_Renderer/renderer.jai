#import "GL";
GLFW :: #import "GLFW";
using Hash_Table :: #import "Hash_Table";

#load "quad_mesh.jai";
#load "shader.jai";
#load "texture.jai";
#load "vertex_shader.jai";
#load "fragment_shader.jai";

init :: (window: *GLFW.Window, pixels_per_unit: u32) {
    renderer = .{
        window = window,
        pixels_per_unit = pixels_per_unit,
        quad_mesh = create_quad_mesh(),
        shader = create_shader(VERTEX_SHADER, FRAGMENT_SHADER),
    };
    renderer.projection = make_projection_matrix();
}

deinit :: () {
    destroy_quad_mesh(renderer.quad_mesh);
    destroy_shader(renderer.shader);

    Hash_Table.deinit(*renderer.sprites); // @TODO figure out what to do with memory of the table and it's arrays

    renderer = .{};
}

start_drawing :: () {
    using gl;

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glClearColor(0, 1, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);

    use_shader(renderer.shader);
    set_uniform(renderer.shader, "projection", renderer.projection);
}

finish_drawing :: () {
    using gl;

    for sprites, texture : renderer.sprites {
        glBindBuffer(GL_ARRAY_BUFFER, renderer.quad_mesh.instance_vbo);
        glBufferSubData(
            GL_ARRAY_BUFFER,
            0,
            sprites.count * size_of(Sprite_Instance),
            sprites.data,
        );

        use_shader(renderer.shader);
        glBindVertexArray(renderer.quad_mesh.vao);

        glActiveTexture(GL_TEXTURE0);
        bind_texture(texture);
        set_uniform(renderer.shader, "spriteTexture", cast(s32) 0);

        glDrawElementsInstanced(
            GL_TRIANGLES,
            6,
            GL_UNSIGNED_INT,
            cast(*void) 0,
            xx sprites.count,
        );

        glBindVertexArray(0);
    }

    GLFW.swap_buffers(renderer.window);

    table_reset(*renderer.sprites); // @TODO temp?
}

draw :: (
    position: Vector2,
    scale: Vector2,
    rotation: float,
    color: Vector4,
    texture: Texture
) {
    texture_sprites := table_find_pointer(*renderer.sprites, texture.id);
    payload: Sprite_Instance = .{
        position = position,
        scale = scale,
        rotation = rotation,
        color = color,
    };

    if (texture_sprites == null) {
        sprites: [..]Sprite_Instance;
        sprites.allocator = temp;
        array_add(*sprites, payload);

        table_add(
            *renderer.sprites,
            texture.id,
            sprites,
        );
    } else {
        array_add(
            texture_sprites,
            payload,
        );
    }
}

#scope_file

Renderer :: struct {
    window: *GLFW.Window;
    pixels_per_unit: u32;
    projection: Matrix4;
    quad_mesh: Quad_Mesh;
    shader: Shader;
    sprites: Table(u32, [..]Sprite_Instance);
}

// @TODO do this also when resizing window
make_projection_matrix :: () -> Matrix4 {
    width, height: s32;

    GLFW.get_frame_buffer_size(renderer.window, *width, *height);

    return orthographic_projection_matrix(
        -(width / 2.0),
        width / 2.0,
        -(height / 2.0),
        height / 2.0,
        -1,
        1,
    );
}

renderer: Renderer = ---;

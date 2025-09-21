#import "GL";
GLFW :: #import "GLFW";
#import "Hash_Table";

#load "quad_mesh.jai";
#load "shader.jai";
#load "texture.jai";
#load "vertex_shader.jai";
#load "fragment_shader.jai";

init :: (window: *GLFW.Window) {
    renderer = .{
        window = window,
        quad_mesh = create_quad_mesh(),
        shader = create_shader(VERTEX_SHADER, FRAGMENT_SHADER),
    };

    GLFW.set_framebuffer_size_callback(window, on_framebuffer_size_change);
}

deinit :: () {
    destroy_quad_mesh(renderer.quad_mesh);
    destroy_shader(renderer.shader);

    deinit(*renderer.sprite_batches);

    renderer = .{};
}

start_drawing :: (
    clear_color: Vector4,
    camera_position: Vector2,
    camera_front: Vector3,
    camera_up: Vector3
) {
    using gl;

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    {
        using clear_color;
        glClearColor(x, y, z, w);
    }
    glClear(GL_COLOR_BUFFER_BIT);

    renderer.projection = make_projection_matrix();
    renderer.view = make_view_matrix(camera_position, camera_front, camera_up);

    use_shader(renderer.shader);
    set_uniform(renderer.shader, "projection", renderer.projection);
    set_uniform(renderer.shader, "view", renderer.view);
}

finish_drawing :: () {
    using gl;

    for batch, id : renderer.sprite_batches {
        glBindBuffer(GL_ARRAY_BUFFER, renderer.quad_mesh.instance_vbo);
        glBufferSubData(
            GL_ARRAY_BUFFER,
            0,
            batch.sprites.count * size_of(Sprite_Instance),
            batch.sprites.data,
        );

        use_shader(renderer.shader);
        glBindVertexArray(renderer.quad_mesh.vao);

        glActiveTexture(GL_TEXTURE0);
        bind_texture(batch.texture);
        set_uniform(renderer.shader, "spriteTexture", cast(s32) 0);

        glDrawElementsInstanced(
            GL_TRIANGLES,
            6,
            GL_UNSIGNED_INT,
            cast(*void) 0,
            xx batch.sprites.count,
        );

        glBindVertexArray(0);
    }

    GLFW.swap_buffers(renderer.window);

    table_reset(*renderer.sprite_batches);
}

draw :: (
    position: Vector2,
    scale: Vector2,
    rotation: float,
    color: Vector4,
    texture: Texture
) {
    batch := table_find_pointer(*renderer.sprite_batches, texture.id);
    payload: Sprite_Instance = .{
        position = position,
        scale = scale,
        rotation = rotation,
        color = color,
    };

    if (batch == null) {
        sprites: [..]Sprite_Instance;
        sprites.allocator = temp; // @TODO: consider not using temp and cleaning up at every finished draw
        array_add(*sprites, payload);

        table_add(
            *renderer.sprite_batches,
            texture.id,
            .{
                texture = texture,
                sprites = sprites,
            },
        );
    } else {
        array_add(
            *batch.sprites,
            payload,
        );
    }
}

#scope_file

Renderer :: struct {
    window: *GLFW.Window;
    projection: Matrix4;
    view: Matrix4;
    quad_mesh: Quad_Mesh;
    shader: Shader;
    sprite_batches: Table(u32, Sprite_Batch);
}

Sprite_Batch :: struct {
    texture: Texture;
    sprites: [..]Sprite_Instance;
}

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

make_view_matrix :: (camera_position: Vector2, camera_front: Vector3, camera_up: Vector3) -> Matrix4 {
    position_3d: Vector3 = .{
        camera_position.x,
        camera_position.y,
        0,
    };

    return make_look_at_matrix(
        position_3d,
        position_3d + camera_front,
        camera_up,
        false,
    );
}

on_framebuffer_size_change :: (window: *GLFW.Window, width: s32, height: s32) #c_call {
    using gl;

    glViewport(0, 0, xx width, xx height);
}

renderer: Renderer = ---;

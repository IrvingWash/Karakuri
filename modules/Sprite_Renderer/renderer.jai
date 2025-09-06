#import "GL";
GLFW :: #import "GLFW";

#load "quad_mesh.jai";
#load "shader.jai";
#load "texture.jai";

init :: (window: *GLFW.Window, pixels_per_unit: u32) {
    renderer = .{
        window = window,
        pixels_per_unit = pixels_per_unit,
        quad_mesh = create_quad_mesh(),
    };
}

deinit :: () {
    destroy_quad_mesh(renderer.quad_mesh);
    destroy_shader(renderer.shader);

    renderer = .{};
}

start_drawing :: () {}

finish_drawing :: () {}

#scope_file

Renderer :: struct {
    window: *GLFW.Window;
    pixels_per_unit: u32;
    quad_mesh: Quad_Mesh;
    shader: Shader;
}

renderer: Renderer = ---;

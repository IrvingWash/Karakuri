#import "GL";

#load "quad_mesh.jai";

init :: () {
    renderer = .{
        quad_mesh = create_quad_mesh(),
    };
}

start_drawing :: () {}

finish_drawing :: () {}

#scope_file

Renderer :: struct {
    quad_mesh: Quad_Mesh;
}

renderer: Renderer = ---;

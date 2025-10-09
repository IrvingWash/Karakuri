init :: (title: string) {
    is_initialized := GLFW.init();
    assert(xx is_initialized, "Failed to initialize GLFW");

    GLFW.window_hint(.CONTEXT_VERSION_MAJOR, 3);
    GLFW.window_hint(.CONTEXT_VERSION_MINOR, 3);
    GLFW.window_hint(.OPENGL_PROFILE, .OPENGL_CORE_PROFILE);
    #if OS == .MACOS {
        GLFW.window_hint(.OPENGL_FORWARD_COMPAT, .TRUE);
    }

    // @Todo P4 width and height are hardcoded
    manager.window = GLFW.create_window(800, 600, title);
    assert(manager.window != null, "Failed to create GLFW window");

    GLFW.make_context_current(manager.window);

    gl_load(*gl, GLFW.get_proc_address);
}

deinit :: () {
    GLFW.destroy_window(manager.window);
    GLFW.terminate();
    manager = .{};
}

should_window_close :: inline () -> bool {
    return xx GLFW.window_should_close(manager.window);
}

poll_events :: inline () {
    GLFW.poll_events();
}

get_window :: inline () -> *GLFW.Window {
    return manager.window;
}

get_render_size :: () -> u32, u32 {
    width, height: s32;
    GLFW.get_frame_buffer_size(manager.window, *width, *height);

    return xx width, xx height;
}

get_dpi_scale :: () -> float, float {
    x, y: float;

    GLFW.get_window_content_scale(manager.window, *x, *y);

    return x, y;
}

#scope_file

Window_Manager :: struct {
    window: *GLFW.Window;
}

manager: Window_Manager = ---;

#import "Basic";
#import "GL";
GLFW :: #import "GLFW";

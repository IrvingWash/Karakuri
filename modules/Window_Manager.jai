init :: (title: string) {
    is_initialized := GLFW.init();
    assert(xx is_initialized, "Failed to initialize GLFW");

    GLFW.window_hint(.CONTEXT_VERSION_MAJOR, 3);
    GLFW.window_hint(.CONTEXT_VERSION_MINOR, 3);
    GLFW.window_hint(.OPENGL_PROFILE, .OPENGL_CORE_PROFILE);
    #if OS == .MACOS {
        GLFW.window_hint(.OPENGL_FORWARD_COMPAT, .TRUE);
    }

    // @Todo width and height are hardcoded
    manager.window = GLFW.create_window(800, 600, title);
    assert(manager.window != null, "Failed to create GLFW window");

    GLFW.make_context_current(manager.window);

    gl_load(*gl, GLFW.get_proc_address);
}

deinit :: () {
    GLFW.destroy_window(manager.window);
    GLFW.terminate();
}

should_window_close :: inline () -> bool {
    return xx GLFW.window_should_close(manager.window);
}

poll_events :: inline () {
    GLFW.poll_events();
}

swap_buffers :: inline () {
    GLFW.swap_buffers(manager.window);
}

#scope_file

Window_Manager :: struct {
    window: *GLFW.Window;
}

manager: Window_Manager = ---;

#import "Basic";
#import "GL";
GLFW :: #import "GLFW";

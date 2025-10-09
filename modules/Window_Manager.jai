init :: (title: string, vsync: bool) {
    is_initialized := GLFW.init();
    assert(is_initialized, "Failed to initialize GLFW");

    GLFW.window_hint(.CONTEXT_VERSION_MAJOR, 3);
    GLFW.window_hint(.CONTEXT_VERSION_MINOR, 3);
    GLFW.window_hint(.OPENGL_PROFILE, .OPENGL_CORE_PROFILE);
    GLFW.window_hint(.FOCUS_ON_SHOW, .TRUE);
    #if OS == .MACOS {
        GLFW.window_hint(.OPENGL_FORWARD_COMPAT, .TRUE);
    }

    monitor := GLFW.get_primary_monitor();
    video_mode := GLFW.get_video_mode(monitor);

    manager.window = GLFW.create_window(
        video_mode.width,
        video_mode.height,
        title,
        monitor,
    );
    assert(manager.window != null, "Failed to create GLFW window");

    GLFW.make_context_current(manager.window);

    if !vsync {
        GLFW.swap_interval(0);
    }

    gl_load(*gl, GLFW.get_proc_address);
}

deinit :: () {
    GLFW.destroy_window(manager.window);

    ok := GLFW.terminate();
    assert(ok, "Failed to terminate GLFW");

    manager = .{};
}

should_window_close :: inline () -> bool {
    return GLFW.window_should_close(manager.window);
}

poll_events :: inline () {
    GLFW.poll_events();
}

get_window :: inline () -> *GLFW.Window {
    return manager.window;
}

get_render_size :: () -> u32, u32 {
    width, height := GLFW.get_frame_buffer_size(manager.window);

    return width, height;
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

Window :: GLFW.Window;

init :: (title: string, vsync: bool) {
    is_initialized := GLFW.init();
    assert(is_initialized, "Failed to initialize GLFW");

    GLFW.window_hint(.CONTEXT_VERSION_MAJOR, 3);
    GLFW.window_hint(.CONTEXT_VERSION_MINOR, 3);
    GLFW.window_hint(.OPENGL_PROFILE, .OPENGL_CORE_PROFILE);
    GLFW.window_hint(.FOCUS_ON_SHOW, .TRUE);
    GLFW.window_hint(.RESIZABLE, .FALSE);
    #if OS == .MACOS {
        GLFW.window_hint(.OPENGL_FORWARD_COMPAT, .TRUE);
    }

    manager.monitor = GLFW.get_primary_monitor();
    video_mode := GLFW.get_video_mode(manager.monitor);

    manager.window = GLFW.create_window(
        video_mode.width,
        video_mode.height,
        title,
        manager.monitor,
    );
    assert(manager.window != null, "Failed to create GLFW window");

    GLFW.make_context_current(manager.window);

    if vsync {
        GLFW.swap_interval(1);
    } else {
        GLFW.swap_interval(0);
    }

    GLFW.set_error_callback(on_error);

    gl_load(*gl, GLFW.get_proc_address);
}

deinit :: () {
    GLFW.destroy_window(manager.window);

    ok := GLFW.terminate();
    assert(ok, "Failed to terminate GLFW");

    manager = {};
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
    x, y := GLFW.get_window_content_scale(manager.window);

    return x, y;
}

set_resolution :: (width: u32, height: u32) {
    if is_fullscreen() {
        video_mode := GLFW.get_video_mode(manager.monitor);

        GLFW.set_window_monitor(
            manager.window,
            manager.monitor,
            0,
            0,
            width,
            height,
            video_mode.refresh_rate,
        );
    } else {
        GLFW.set_window_size(manager.window, xx width, xx height);
    }
}

is_fullscreen :: () -> bool {
    return GLFW.get_window_monitor(manager.window) != null;
}

set_fullscreen :: () {
    if is_fullscreen() {
        return;
    }

    video_mode := GLFW.get_video_mode(manager.monitor);

    GLFW.set_window_monitor(
        manager.window,
        manager.monitor,
        0,
        0,
        video_mode.width,
        video_mode.height,
        video_mode.refresh_rate,
    );
}

set_windowed :: () {
    if !is_fullscreen() {
        return;
    }

    video_mode := GLFW.get_video_mode(manager.monitor);

    GLFW.set_window_monitor(
        manager.window,
        null,
        0,
        0,
        video_mode.width,
        video_mode.height,
        video_mode.refresh_rate,
    );
}

#scope_file

Window_Manager :: struct {
    window:  *GLFW.Window;
    monitor: *GLFW.Monitor;
}

manager: Window_Manager = ---;

on_error :: (error: s32, description: *u8) #c_call {
    push_context {
        print("%\n", description);
    }
}

#import "Basic";
#import "GL";
GLFW :: #import "GLFW";

#import "Basic";

#load "structs.jai";
#load "enums.jai";
#load "proc_types.jai";
#load "internal.jai";

init :: inline () -> ok: bool {
    return xx glfwInit();
}

terminate :: inline () -> bool {
    return xx glfwTerminate();
}

window_hint :: (
    hint:  Hint_Name,
    value: Hint_Value
) #foreign glfw "glfwWindowHint";

create_window :: (
    width:   u32,
    height:  u32,
    $$title: string,
    monitor: *Monitor = null,
    share:   *Window  = null
) -> *Window {
    #if is_constant(title) {
        return glfwCreateWindow(
            cast(s32) width,
            cast(s32) height,
            title.data,
            monitor,
            share,
        );
    } else {
        return glfwCreateWindow(
            cast(s32) width,
            cast(s32) height,
            temp_c_string(title),
            monitor,
            share,
        );
    }
}

destroy_window :: (window: *Window) #foreign glfw "glfwDestroyWindow";

make_context_current :: (
    window: *Window
) #foreign glfw "glfwMakeContextCurrent";

window_should_close :: inline (window: *Window) -> bool {
    return xx glfwWindowShouldClose(window);
}

swap_buffers :: (window: *Window) #foreign glfw "glfwSwapBuffers";

poll_events :: () #foreign glfw "glfwPollEvents";

get_primary_monitor :: () -> *Monitor #foreign glfw "glfwGetPrimaryMonitor";

get_video_mode :: (monitor: *Monitor) -> Video_Mode {
    using raw_video_mode := glfwGetVideoMode(monitor);

    return .{
        width        = xx width,
        height       = xx height,
        red_bits     = xx redBits,
        green_bits   = xx greenBits,
        blue_bits    = xx blueBits,
        refresh_rate = xx refreshRate,
    };
}

get_frame_buffer_size :: (window: *Window) -> width: u32, height: u32 {
    width, height: s32;
    glfwGetFrameBufferSize(window, *width, *height);

    return xx width, xx height;
}

get_window_content_scale :: (window: *Window) -> x_scale: float, y_scale: float {
    x_scale, y_scale: float;
    glfwGetWindowContentScale(window, *x_scale, *y_scale);

    return x_scale, y_scale;
}

set_window_size :: inline (window: *Window, width: u32, height: u32) {
    glfwSetWindowSize(window, xx width, xx height);
}

get_window_monitor :: (
    window: *Window
) -> *Monitor #foreign glfw "glfwGetWindowMonitor";

set_window_monitor :: inline (
    window:       *Window,
    monitor:      *Monitor,
    x_position:   u32,
    y_position:   u32,
    width:        u32,
    height:       u32,
    refresh_rate: u32
) {
    glfwSetWindowMonitor(
        window,
        monitor,
        xx x_position,
        xx y_position,
        xx width,
        xx height,
        xx refresh_rate,
    );
}

set_framebuffer_size_callback :: (
    window:   *Window,
    callback: Framebuffer_Size_Proc
) #foreign glfw "glfwSetFramebufferSizeCallback";

get_key :: (
    window: *Window,
    key: Key
) -> Key_Action #foreign glfw "glfwGetKey";

get_cursor_position :: inline (window: *Window) -> x: float, y: float {
    x, y: float64;
    glfwGetCursorPos(window, *x, *y);

    return xx x, xx y;
}

set_window_should_close :: inline (window: *Window, value: bool) {
    glfwSetWindowShouldClose(window, xx value);
}

get_proc_address :: (
    proc_name: *u8
) -> *void #foreign glfw "glfwGetProcAddress";

swap_interval :: inline (interval: u16) {
    glfwSwapInterval(xx interval);
}

set_input_mode :: (
    window: *Window,
    mode:   Input_Mode_Name,
    value:  Input_Mode_Value
) #foreign glfw "glfwSetInputMode";

set_cursor_position :: (
    window: *Window,
    x:      float64,
    y:      float64
) #foreign glfw "glfwSetCursorPos";

set_cursor_position_callback :: (
    window:   *Window,
    callback: Cursor_Position_Proc
) #foreign glfw "glfwSetCursorPosCallback";

set_scroll_callback :: (
    window:   *Window,
    callback: Scroll_Proc
) #foreign glfw "glfwSetScrollCallback";

set_key_callback :: (
    window:   *Window,
    callback: Key_Proc
) #foreign glfw "glfwSetKeyCallback";

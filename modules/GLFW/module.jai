Window :: struct {}

Monitor :: struct {}

Hint_Name :: enum_flags #specified {
    CONTEXT_VERSION_MAJOR: : 0x00022002;
    CONTEXT_VERSION_MINOR: : 0x00022003;
    OPENGL_PROFILE:        : 0x00022008;
    OPENGL_FORWARD_COMPAT: : 0x00022006;
}

Hint_Value :: enum_flags #specified {
    OPENGL_CORE_PROFILE: : 0x00032001;
    TRUE:                : 1;
}

Input_Mode_Name :: enum_flags #specified {
    CURSOR :: 0x00033001;
}

Input_Mode_Value :: enum_flags #specified {
    CURSOR_DISABLED :: 0x00034003;
}

Framebuffer_Size_Proc :: #type (
    window: *Window,
    width:  s32,
    height: s32
) #c_call;

Cursor_Position_Proc :: #type (
    window: *Window,
    x: float64,
    y: float64
) #c_call;

Scroll_Proc :: #type (
    window: *Window,
    offset_x: float64,
    offset_y: float64
) #c_call;

Key :: enum #specified {
    ESCAPE :: 256;
    A :: 65;
    D :: 68;
    E :: 69;
    Q :: 81;
    R :: 82;
    S :: 83;
    W :: 87;
}

Key_Action :: enum #specified {
    RELEASE: : 0;
    PRESS:   : 1;
    REPEAT:  : 2;
}

init :: () -> s32 #foreign glfw "glfwInit";

terminate :: () -> s32 #foreign glfw "glfwTerminate";

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

window_should_close :: (
    window: *Window
) -> s32 #foreign glfw "glfwWindowShouldClose";

swap_buffers  :: (window: *Window) #foreign glfw "glfwSwapBuffers";

poll_events  :: () #foreign glfw "glfwPollEvents";

get_frame_buffer_size :: (
    window: *Window,
    width:  *s32,
    height: *s32
) #foreign "glfwGetFramebufferSize";

set_framebuffer_size_callback :: (
    window:   *Window,
    callback: Framebuffer_Size_Proc
) #foreign glfw "glfwSetFramebufferSizeCallback";

get_key :: (
    window: *Window, key: Key
) -> Key_Action #foreign glfw "glfwGetKey";

set_window_should_close :: (
    window: *Window,
    value:  int
) #foreign "glfwSetWindowShouldClose";

get_proc_address :: (
    proc_name: *u8
) -> *void #foreign glfw "glfwGetProcAddress";

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
    window: *Window,
    callback: Cursor_Position_Proc
) #foreign glfw "glfwSetCursorPosCallback";

set_scroll_callback :: (
    window:   *Window,
    callback: Scroll_Proc
) #foreign glfw "glfwSetScrollCallback";

#scope_file;

#import "Basic";

glfwCreateWindow :: (
    width:   s32,
    height:  s32,
    title:   *u8,
    monitor: *Monitor,
    share:   *Window
) -> *Window #foreign glfw;

#if OS == .MACOS {
    glfw :: #library "macos/libglfw.3";
} else #if OS == .LINUX {
    glfw :: #library "linux/libglfw";
}

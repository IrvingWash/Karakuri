#scope_module;

GLFWvidmode :: struct {
    width:       s32;
    height:      s32;
    redBits:     s32;
    greenBits:   s32;
    blueBits:    s32;
    refreshRate: s32;
}

glfwInit :: () -> s32 #foreign glfw "glfwInit";

glfwTerminate :: () -> s32 #foreign glfw "glfwTerminate";

glfwCreateWindow :: (
    width:   s32,
    height:  s32,
    title:   *u8,
    monitor: *Monitor,
    share:   *Window
) -> *Window #foreign glfw;

glfwGetVideoMode :: (
    monitor: *Monitor
) -> *GLFWvidmode #foreign glfw "glfwGetVideoMode";

glfwWindowShouldClose :: (
    window: *Window
) -> s32 #foreign glfw "glfwWindowShouldClose";

glfwSetWindowShouldClose :: (
    window: *Window,
    value:  int
) #foreign "glfwSetWindowShouldClose";

glfwGetFrameBufferSize :: (
    window: *Window,
    width:  *s32,
    height: *s32
) #foreign glfw "glfwGetFramebufferSize";

glfwSwapInterval :: (interval: s32) #foreign glfw "glfwSwapInterval";

#if OS == .MACOS {
    glfw :: #library "macos/libglfw.3";
} else #if OS == .LINUX {
    glfw :: #library "linux/libglfw";
}

GLFW :: #import "GLFW";

init :: (window: *GLFW.Window) {
    manager = .{ window = window };
}

deinit :: () {
    manager = .{};
}

#scope_file

Input_Manager :: struct {
    window: *GLFW.Window;
}

manager: Input_Manager = ---;

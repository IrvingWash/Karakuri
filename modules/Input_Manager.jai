GLFW :: #import "GLFW";

Key :: GLFW.Key;
Key_State :: GLFW.Key_Action;

init :: (window: *GLFW.Window) {
    manager = .{ window = window };
}

deinit :: () {
    manager = .{};
}

is_key_pressed :: (key: Key) -> bool {
    return GLFW.get_key(manager.window, key) == .PRESS;
}

#scope_file

Input_Manager :: struct {
    window: *GLFW.Window;
}

manager: Input_Manager = ---;

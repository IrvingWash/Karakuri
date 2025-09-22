GLFW :: #import "GLFW";

Key :: GLFW.Key;
Key_State :: GLFW.Key_Action;

init :: (window: *GLFW.Window) {
    manager = .{ window = window };
}

deinit :: () {
    manager = .{};
}

get_key_state :: (key: Key) -> Key_State {
    return GLFW.get_key(manager.window, key);
}

#scope_file

Input_Manager :: struct {
    window: *GLFW.Window;
}

manager: Input_Manager = ---;

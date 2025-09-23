GLFW :: #import "GLFW";

Key :: GLFW.Key;
Key_State :: GLFW.Key_Action;

init :: (window: *GLFW.Window) {
    manager = .{ window = window };

    GLFW.set_key_callback(window, on_key);
}

deinit :: () {
    GLFW.set_key_callback(manager.window, null);

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

on_key :: (
    window:    *GLFW.Window,
    key:       GLFW.Key,
    scan_code: s32,
    action:    GLFW.Key_Action,
    modifiers: s32
) #c_call {
    // @Todo
}


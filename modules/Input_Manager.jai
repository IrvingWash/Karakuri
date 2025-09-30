#import "Basic";
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

is_key_down :: (key: Key) -> bool {
    return manager.key_state[key] == .PRESS;
}

reset_key_state :: () {
    for *key_state: manager.key_state {
        key_state.* = .RELEASE;
    }
}

#scope_file

_, HIGHEST_KEY :: #run enum_range(Key);

Input_Manager :: struct {
    window: *GLFW.Window;
    key_state: [HIGHEST_KEY]Key_State;
}

manager: Input_Manager = ---;

on_key :: (
    window:    *GLFW.Window,
    key:       GLFW.Key,
    scan_code: s32,
    action:    GLFW.Key_Action,
    modifiers: s32
) #c_call {
    if key >= HIGHEST_KEY {
        return;
    }

    manager.key_state[key] = action;
}


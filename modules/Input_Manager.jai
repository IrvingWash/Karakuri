#import "Basic";
GLFW :: #import "GLFW";

Key :: GLFW.Key;
Key_State :: GLFW.Key_Action;

init :: (window: *GLFW.Window, pixels_per_unit: u32) {
    manager = {
        window     = window,
        halved_ppu = pixels_per_unit / 2,
    };

    GLFW.set_key_callback(manager.window, on_key);
    // GLFW.set_input_mode(manager.window, .CURSOR, .CURSOR_DISABLED);
}

deinit :: () {
    GLFW.set_key_callback(manager.window, null);

    manager = {};
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

get_cursor_position :: () -> x: float, y: float {
    raw_x, raw_y := GLFW.get_cursor_position(manager.window);
    width, height := GLFW.get_frame_buffer_size(manager.window);
    x_scale, y_scale := GLFW.get_window_content_scale(manager.window);

    raw_x -= width / x_scale / 2;
    raw_y -= height / y_scale / 2;
    raw_y = -raw_y;

    raw_x /= manager.halved_ppu;
    raw_y /= manager.halved_ppu;

    return raw_x, raw_y;
}

#scope_file

_, HIGHEST_KEY :: #run enum_range(Key);

Input_Manager :: struct {
    window:          *GLFW.Window;
    key_state:       [HIGHEST_KEY]Key_State;
    halved_ppu: u32;
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


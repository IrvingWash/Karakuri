settings_manager_prefab :: () -> Karakuri.Entity_Params {
    return .{
        on_start  = on_start,
        on_update = on_update,
    };
}

#scope_file;

on_start :: (self: *Karakuri.Entity) {
    Karakuri.set_windowed();
    Karakuri.set_screen_resolution(270 * 2, 480 * 2);
}

on_update :: (self: *Karakuri.Entity) {
    if Karakuri.Input_Manager.is_key_down(.ESCAPE) {
        Karakuri.Time_Manager.set_time_scale(xx state.is_paused);

        state.is_paused = !state.is_paused;
    }
}

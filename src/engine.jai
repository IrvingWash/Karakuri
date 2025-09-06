init :: (config: Engine_Config) {
    Window_Manager.init(config.title);
    FPS_Manager.init(config.target_fps);
}

deinit :: () {
    Window_Manager.deinit();
}

run :: () {
    while !Window_Manager.should_window_close() {
        delta_time := FPS_Manager.cap_frame_rate();

        process_input();
    }
}

#scope_file

process_input :: () {
    Window_Manager.poll_events();
}

Engine_Config :: struct {
    title: string = "Karakuri";
    target_fps: u32 = 60;
}

#import "Basic";
Window_Manager :: #import "Window_Manager";
FPS_Manager :: #import "FPS_Manager";

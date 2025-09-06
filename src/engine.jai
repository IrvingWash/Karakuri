init :: (config: Engine_Config) {
    Window_Manager.init(config.title);
    FPS_Manager.init(config.target_fps);
    Sprite_Renderer.init(Window_Manager.get_window(), config.pixels_per_unit);
}

deinit :: () {
    Sprite_Renderer.deinit();
    FPS_Manager.deinit();
    Window_Manager.deinit();
}

run :: () {
    while !Window_Manager.should_window_close() {
        delta_time := FPS_Manager.cap_frame_rate();

        process_input();

        update(delta_time);

        render();

        reset_temporary_storage();
    }
}

#scope_file

process_input :: () {
    Window_Manager.poll_events();
}

update :: (delta_time: float) {}

render :: () {
    Sprite_Renderer.start_drawing();
    Sprite_Renderer.finish_drawing();
}

Engine_Config :: struct {
    title: string = "Karakuri";
    target_fps: u32 = 60;
    pixels_per_unit: u32 = 100;
}

#import "Basic";
Window_Manager :: #import "Window_Manager";
FPS_Manager :: #import "FPS_Manager";
Sprite_Renderer :: #import "Sprite_Renderer";

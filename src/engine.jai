Engine_Config :: struct {
    title: string = "Karakuri";
    target_fps: u32 = 60;
    initial_scene: Scene = DEFAULT_SCENE_LOADER;
}

init :: (config: Engine_Config) {
    Window_Manager.init(config.title);
    Time_Manager.init(config.target_fps);
    Sprite_Renderer.init(Window_Manager.get_window());
    Asset_Manager.init();

    initial_entities := config.initial_scene();
    defer array_free(*initial_entities);
    init_world(initial_entities);
}

deinit :: () {
    deinit_world();
    Asset_Manager.deinit();
    Sprite_Renderer.deinit();
    Time_Manager.deinit();
    Window_Manager.deinit();
}

run :: () {
    while !Window_Manager.should_window_close() {
        Time_Manager.cap_frame_rate();

        process_input();

        update();

        render();

        reset_temporary_storage();

        #if DEBUG {
            memory_visualizer_per_frame_update();
        }
    }
}

#scope_file

process_input :: () {
    Window_Manager.poll_events();
}

update :: () {
    update_world();
}

render :: () {
    Sprite_Renderer.start_drawing(
        .{1, 1, 1, 1}, // @TODO dummy data while we don't have camera
        .{0, 0},
        .{0, 0, -1},
        .{0, 1, 0},
    );

    Sprite_Renderer.finish_drawing();
}

#import "Basic";

Window_Manager :: #import "Window_Manager";
Time_Manager :: #import "Time_Manager";
Sprite_Renderer :: #import "Sprite_Renderer";
Asset_Manager :: #import "Asset_Manager";

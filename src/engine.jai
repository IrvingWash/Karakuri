Engine_Config :: struct {
    title:             string = "Karakuri";
    target_fps:        u32    = 60;
    initial_scene:     Scene  = DEFAULT_SCENE_LOADER;
    vsync:             bool   = true;
}

init :: (config: Engine_Config) {
    Window_Manager.init(config.title, config.vsync);
    Time_Manager.init(config.target_fps);
    Sprite_Renderer.init(Window_Manager.get_window(), PIXELS_PER_UNIT);
    Asset_Manager.init();
    Input_Manager.init(Window_Manager.get_window(), PIXELS_PER_UNIT);
    Timer_Manager.init();

    #if DEBUG {
        init_editor();

        Asset_Manager.add_texture("assets/textures/square.png");
    }

    initial_entities := config.initial_scene();
    defer array_free(initial_entities);

    init_world(initial_entities);

    init_rendering_system();
    init_animation_system();
    init_physics_system();
}

deinit :: () {
    deinit_physics_system();
    deinit_animation_system();
    deinit_rendering_system();

    deinit_world();

    #if DEBUG {
        deinit_editor();
    }

    Timer_Manager.deinit();
    Input_Manager.deinit();
    Asset_Manager.deinit();
    Sprite_Renderer.deinit();
    Time_Manager.deinit();
    Window_Manager.deinit();
}

run :: () {
    while !Window_Manager.should_window_close() {
        Time_Manager.cap_frame_rate();
        Timer_Manager.update(Time_Manager.get_delta_time());

        process_input();

        update();

        reset_temporary_storage();

        #if DEBUG {
            memory_visualizer_per_frame_update();
        }
    }
}

#scope_module

Input_Manager :: #import "Input_Manager";
Time_Manager  :: #import "Time_Manager";
Asset_Manager :: #import "Asset_Manager";
Timer_Manager :: #import "Timer_Manager";

PIXELS_PER_UNIT :: 100;

#scope_file

process_input :: () {
    Input_Manager.reset_key_state();
    Window_Manager.poll_events();
}

update :: () {
    update_world();

    run_physics_system();
    run_animation_system();
    run_rendering_system();
}

#import "Basic";

Window_Manager :: #import "Window_Manager";
Sprite_Renderer :: #import "Sprite_Renderer";
#load "systems/physics_system.jai";
#load "systems/rendering_system.jai";
#load "systems/animation_system.jai";

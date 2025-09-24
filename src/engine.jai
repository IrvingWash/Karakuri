Input_Manager :: #import "Input_Manager";
Time_Manager :: #import "Time_Manager";

Engine_Config :: struct {
    title:         string = "Karakuri";
    target_fps:    u32 = 60;
    initial_scene: Scene = DEFAULT_SCENE_LOADER;
}

init :: (config: Engine_Config) {
    Window_Manager.init(config.title);
    Time_Manager.init(config.target_fps);
    Sprite_Renderer.init(Window_Manager.get_window(), PIXELS_PER_UNIT);
    Asset_Manager.init();
    Input_Manager.init(Window_Manager.get_window());

    print("= 1\n"); // @TODO everything crashes without this call

    if DEBUG {
        Asset_Manager.add_texture("assets/textures/square.png");
    }

    initial_entities := config.initial_scene();
    defer array_free(initial_entities);

    init_world(initial_entities);
}

deinit :: () {
    deinit_world();
    Input_Manager.deinit();
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

#scope_module

Asset_Manager :: #import "Asset_Manager";

PIXELS_PER_UNIT :: 100;

#scope_file

process_input :: () {
    Input_Manager.reset_key_state();
    Window_Manager.poll_events();
}

update :: () {
    update_world();
}

render :: () {
    cameras := get_world_entities(.CAMERA);

    for camera: cameras {
        Sprite_Renderer.start_drawing(
            camera.camera.color,
            camera.transform.position,
            camera.camera.front,
            camera.camera.up,
            camera.camera.size,
        );

        drawable_entities := get_world_entities(.SPRITE);
        for entity: drawable_entities {
            ok, texture := Asset_Manager.get_texture(entity.sprite.texture_path);
            if !ok {
                log(
                    "Texture `%` not loaded into the Asset Manager.",
                    entity.sprite.texture_path,
                    flags = .WARNING,
                );

                continue;
            }

            Sprite_Renderer.draw(
                entity.transform.position,
                entity.transform.scale,
                entity.transform.rotation,
                entity.sprite.color,
                entity.sprite.pixels_per_unit,
                entity.sprite.origin,
                texture,
            );
        }

        if DEBUG {
            entities_with_box_colliders := get_world_entities(.BOX_COLLIDER);
            for entity: entities_with_box_colliders {
                ok, texture := Asset_Manager.get_texture("assets/textures/square.png");
                assert(ok, "Stock texture `square.png` not found.");

                Sprite_Renderer.draw(
                    entity.transform.position,
                    entity.box_collider.size * entity.transform.scale,
                    entity.transform.rotation,
                    .{ 0, 1, 0, 0.5 },
                    PIXELS_PER_UNIT,
                    entity.box_collider.offset,
                    texture,
                );
            }
        }

        Sprite_Renderer.finish_drawing();
    }
}

#import "Basic";

Window_Manager :: #import "Window_Manager";
Sprite_Renderer :: #import "Sprite_Renderer";

#scope_module

#import "IntroSort";

init_rendering_system :: () {
    system = .{};
}

deinit_rendering_system :: () {
    array_reset(*system.cameras);
    array_reset(*system.entities);
    #if DEBUG {
        array_reset(*system.box_colliders);
    }

    system = .{};
}

run_rendering_system :: () {
    if system.cameras.count == 0 || has_world_changed() {
        array_reset(*system.cameras);
        system.cameras = array_copy(get_world_entities(.CAMERA));
    }

    for camera: system.cameras {
        Sprite_Renderer.start_drawing(
            camera.camera.color,
            camera.transform.position,
            camera.camera.front,
            camera.camera.up,
            camera.camera.size,
        );

        if system.entities.count == 0 || has_world_changed() {
            array_reset(*system.entities);
            system.entities = array_copy(get_world_entities(.SPRITE));
            insertion_sort(
                system.entities,
                (a, b) => cast(s64)(a.sprite.sorting_layer) - cast(s64)(b.sprite.sorting_layer)
            );
        }

        for entity: system.entities {
            ok, texture := Asset_Manager.get_texture(entity.sprite.texture_path);
            if !ok {
                log(
                    "Texture `%` not loaded into the Asset Manager.",
                    entity.sprite.texture_path,
                    flags = .WARNING,
                );

                continue;
            }

            {
                using entity;

                Sprite_Renderer.draw(
                    transform.position,
                    transform.scale,
                    transform.rotation,
                    sprite.color,
                    sprite.pixels_per_unit,
                    sprite.origin,
                    sprite.clip,
                    sprite.offset,
                    texture,
                );
            }
        }

        #if DEBUG {
            if system.box_colliders.count == 0 || has_world_changed() {
                array_reset(*system.box_colliders);
                system.box_colliders = array_copy(get_world_entities(.BOX_COLLIDER));
            }

            ok, texture := Asset_Manager.get_texture("assets/textures/square.png");
            assert(ok, "Stock texture `square.png` not found.");

            for entity: system.box_colliders {
                Sprite_Renderer.draw(
                    entity.transform.position,
                    entity.box_collider.size * entity.transform.scale,
                    entity.transform.rotation,
                    BOX_COLLIDER_COLOR,
                    PIXELS_PER_UNIT,
                    entity.box_collider.offset,
                    UNIT_VECTOR2,
                    ZERO_VECTOR2,
                    texture,
                );
            }
        }

        Sprite_Renderer.finish_drawing();

        #if EDITOR {
            update_editor(*camera.transform.position);
        }

        Sprite_Renderer.present();
    }
}

#scope_file

Sprite_Renderer :: #import "Sprite_Renderer";

Rendering_System :: struct {
    cameras:  []*Entity;
    entities: []*Entity;
#if DEBUG {
    box_colliders: []*Entity;
}
}

system: Rendering_System = ---;

#if DEBUG {
    BOX_COLLIDER_COLOR: Vector4 : .{ 0, 1, 0, 0.2 };
}

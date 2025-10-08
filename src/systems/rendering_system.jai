#scope_module

#import "IntroSort";

run_rendering_system :: () {
    cameras := get_world_entities(.CAMERA);

    for camera: cameras {
        Sprite_Renderer.start_drawing(
            camera.camera.color,
            camera.transform.position,
            camera.camera.front,
            camera.camera.up,
            camera.camera.size,
        );

        // @Optimization: we can avoid getting entities each frame if the world marks itself dirty when new entities are added
        drawable_entities := get_world_entities(.SPRITE);
        insertion_sort(
            drawable_entities,
            (a, b) => cast(s64)(a.sprite.sorting_layer) - cast(s64)(b.sprite.sorting_layer)
        );

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
            ok, texture := Asset_Manager.get_texture("assets/textures/square.png");
            assert(ok, "Stock texture `square.png` not found.");

            for entity: entities_with_box_colliders {
                Sprite_Renderer.draw(
                    entity.transform.position,
                    entity.box_collider.size * entity.transform.scale,
                    entity.transform.rotation,
                    BOX_COLLIDER_COLOR,
                    PIXELS_PER_UNIT,
                    entity.box_collider.offset,
                    texture,
                );
            }
        }

        Sprite_Renderer.finish_drawing();
    }
}

#scope_file

Sprite_Renderer :: #import "Sprite_Renderer";

BOX_COLLIDER_COLOR: Vector4 : .{ 0, 1, 0, 0.2 };

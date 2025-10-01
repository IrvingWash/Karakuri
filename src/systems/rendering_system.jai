#scope_module

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

#scope_file
Sprite_Renderer :: #import "Sprite_Renderer";

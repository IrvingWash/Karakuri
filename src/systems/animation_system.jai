play_animation :: (using entity: *Entity, animation_name: string) {
    if (
        !animation_controller.current
        || animation_controller.current.name != animation_name
    ) {
        animation := table_find_pointer(
            *entity.animation_controller.animations,
            animation_name,
        );
        if !animation {
            log(
                "Animation `%` not found",
                animation_name,
                flags = .WARNING,
            );

            return;
        }

        animation.current_frame = 0;
        animation.time_playing = 0;

        entity.animation_controller.current = animation;
    }
}

stop_animation :: (entity: *Entity) {
    entity.animation_controller.current = null;
}

#scope_module

run_animation_system :: () {
    animating_entities := get_world_entities(.ANIMATION_CONTROLLER);

    for entity: animating_entities {
        using entity;

        animation := animation_controller.current;
        if !animation || (
            !animation.looping && (animation.current_frame == animation.frame_count - 1)
        ) {
            continue;
        }

        animation.time_playing += Time_Manager.get_delta_time();

        animation.current_frame = cast(u16)(
            animation.time_playing
            * cast(float)(animation.frame_rate)
        ) % animation.frame_count;

        sprite.clip = .{ 1.0 / animation.frame_count, 1 }; // @TODO 1 is hardcoded
        sprite.offset = .{ sprite.clip.x * animation.current_frame, 0 }; // @TODO 0 is hardcoded

        if sprite.texture_path != animation.texture_path {
            sprite.texture_path = animation.texture_path;
        }
    }
}

#scope_file;

#import "Hash_Table";
Time_Manager :: #import "Time_Manager";

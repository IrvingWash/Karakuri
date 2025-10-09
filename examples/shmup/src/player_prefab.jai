#import "Hash_Table";

player_prefab :: () -> Karakuri.Entity_Params {
    animation_controller: Karakuri.Animation_Controller;
    table_add(
        *animation_controller.animations,
        "idle",
        PLAYER_IDLE,
    );
    table_add(
        *animation_controller.animations,
        "strafe_forward",
        PLAYER_STRAFE_FORWARD,
    );
    table_add(
        *animation_controller.animations,
        "strafe_right",
        PLAYER_STRAFE_RIGHT,
    );
    table_add(
        *animation_controller.animations,
        "strafe_left",
        PLAYER_STRAFE_LEFT,
    );

    return .{
        name = "Player",
        transform = .{
            position = .{ 0, Karakuri.screen_bottom_to_world() + 2 },
            scale = .{ 3, 3 },
        },
        animation_controller = animation_controller,
        behavior = New(Player),
        box_collider = .{
            size = .{ 0.2, 0.45 },
            offset = .{ 0, 0.05 },
        },

        on_update    = on_update,
        on_collision = on_collision,
    };
}

Player :: struct {
    #as using behavior: Karakuri.Behavior;
    speed := 5;
}

#scope_file
on_start :: (entity: *Karakuri.Entity) {
    Karakuri.play_animation(entity, "idle");
}

on_update :: (entity: *Karakuri.Entity) {
    shoot(entity);
    move(entity);
}

on_collision :: (self: *Karakuri.Entity, other: *Karakuri.Entity) {
    if (
        other.name == "Projectile"
        && other.behavior.(*Projectile).emitter != .PLAYER
    ) {
        Karakuri.despawn_entity_from_world(self.token);
    }
}

move :: (entity: *Karakuri.Entity) {
    disposition := (cast(*Player) entity.behavior).speed
        * Karakuri.Time_Manager.get_delta_time();
    vector: Vector2;

    if Karakuri.Input_Manager.is_key_pressed(.W) {
        vector.y += disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.S) {
        vector.y -= disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.A) {
        vector.x -= disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.D) {
        vector.x += disposition;
    }

    if vector.x > 0 {
        Karakuri.play_animation(entity, "strafe_right");
    } else if vector.x < 0 {
        Karakuri.play_animation(entity, "strafe_left");
    } else if vector.y > 0 {
        Karakuri.play_animation(entity, "strafe_forward");
    } else {
        Karakuri.play_animation(entity, "idle");
    }

    entity.transform.position += vector;
}

shoot :: (entity: *Karakuri.Entity) {
    if Karakuri.Input_Manager.is_key_down(.SPACE) {
        Karakuri.spawn_entity_into_world(
            projectile_prefab(
                entity.transform.position + .{ 0, 1.0 },
                .PLAYER,
            ),
        );
    }
}

#scope_file
#load "../animations/player_animations.jai";

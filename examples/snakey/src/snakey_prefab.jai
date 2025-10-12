#import "Math";
#import "Hash_Table";

snakey_prefab :: () -> Karakuri.Entity_Params {
    animation_controller: Karakuri.Animation_Controller;
    table_add(
        *animation_controller.animations,
        "run",
        .{
            name         = "run",
            texture_path = "examples/snakey/assets/snakey_run.png",
            frame_count  = 3,
            frame_rate   = 8,
            looping      = true,
        },
    );
    table_add(
        *animation_controller.animations,
        "idle",
        .{
            name         = "idle",
            texture_path = "examples/snakey/assets/snakey_idle.png",
            frame_count  = 3,
            frame_rate   = 4,
            looping      = true,
        },
    );

    return .{
        name = "Player",
        transform = .{
            position = .{ -9, 0 },
        },
        animation_controller = animation_controller,
        box_collider = .{
            size = .{ 1.6, 2.65 },
            offset = .{ 0, -0.07 },
        },
        flags = .RIGID_BODY,

        on_start  = on_start,
        on_update = on_update,
    };
}

#scope_file

on_start :: (self: *Karakuri.Entity) {
    Karakuri.play_animation(self, "idle");
}

on_update :: (self: *Karakuri.Entity) {
    move(self);
}

move :: (self: *Karakuri.Entity) {
    disposition := 5 * Karakuri.Time_Manager.get_delta_time();
    vector: Vector2;

    if Karakuri.Input_Manager.is_key_pressed(.A) {
        vector.x -= disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.D) {
        vector.x += disposition;
    }
    if Karakuri.Input_Manager.is_key_down(.SPACE) {
        self.rigid_body.velocity.y += 30 * Karakuri.Time_Manager.get_delta_time();
    }

    self.transform.position += vector;

    if vector.x != 0 {
        Karakuri.play_animation(self, "run");
    } else {
        Karakuri.play_animation(self, "idle");
    }
}

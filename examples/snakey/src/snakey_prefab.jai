#import "Math";
#import "Hash_Table";

snakey_prefab :: () -> Karakuri.Entity_Params {
    behavior := New(Snakey);

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
        sprite = .{
            offset = .{ 0, 0 }, // @Todo P3 this is from bottom left, but we want from top left
        },
        behavior = behavior,
        animation_controller = animation_controller,

        on_start  = on_start,
        on_update = on_update,
    };
}

Snakey :: struct {
    #as using behavior: Karakuri.Behavior;
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

    if vector != Karakuri.ZERO_VECTOR2 {
        self.transform.position += vector;
        Karakuri.play_animation(self, "run");
    } else {
        Karakuri.play_animation(self, "idle");
    }
}

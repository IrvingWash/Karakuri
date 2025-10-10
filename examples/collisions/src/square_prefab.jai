#import "Math";

square_prefab :: (controlled: bool) -> Karakuri.Entity_Params {
    behavior := New(Square);
    behavior.controlled = controlled;

    return .{
        name = "Square",
        transform = .{
            scale = .{ 3, 2 },
        },
        sprite = .{
            texture_path = "examples/collisions/textures/square.png",
            sorting_layer = ifx controlled
                then 999
                else 0,
        },
        box_collider = .{
            size = .{ 0.8, 0.8 },
            offset = .{ 0.2, 0.2 },
        },
        behavior = behavior,

        on_update = on_update,
        on_collision = on_collision,
    };
}

Square :: struct {
    #as using behavior: Karakuri.Behavior;
    controlled: bool;
}

#scope_file

on_update :: (self: *Karakuri.Entity) {
    square := self.behavior.(*Square);

    if square.controlled {
        move(self);
    }

    self.sprite.color = .{ 1, 1, 1, 1 };
}

on_collision :: (self: *Karakuri.Entity, other: *Karakuri.Entity) {
    square := self.behavior.(*Square);

    if square.controlled {
        self.sprite.color = .{ 1, 0, 0, 1 };
    }
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

    self.transform.position += vector;
}

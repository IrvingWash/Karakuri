#import "Math";

square_prefab :: (controlled: bool = false) -> Karakuri.Entity_Params {
    behavior := New(Square);
    behavior.controlled = controlled;

    return .{
        transform = .{
            scale = .{ 2, 2 },
        },
        sprite = .{
            texture_path = "examples/squares/assets/square.png",
            color = ifx controlled
                then Vector4.{ 1, 0, 0, 1 }
                else Vector4.{ 0, 1, 0, 1 },
            sorting_layer = ifx controlled
                then 1
                else 0,
        },
        behavior = behavior,

        on_update = on_update,
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
}

move :: (self: *Karakuri.Entity) {
    disposition := 10 * Karakuri.Time_Manager.get_delta_time();

    if Karakuri.Input_Manager.is_key_pressed(.W) {
        self.transform.position.y += disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.S) {
        self.transform.position.y -= disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.A) {
        self.transform.position.x -= disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.D) {
        self.transform.position.x += disposition;
    }
}

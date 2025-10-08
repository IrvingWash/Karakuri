#import "Math";

snakey_prefab :: (controlled: bool = false) -> Karakuri.Entity_Params {
    behavior := New(Snakey);
    behavior.controlled = controlled;

    return .{
        transform = .{
            position = .{
                xx ifx controlled
                    then -2
                    else 2,
                0,
            },
        },
        sprite = .{
            texture_path = "examples/snakey/assets/snakey.png",
            color = ifx controlled
                then Vector4.{ 1, 1, 1, 1 }
                else Vector4.{ 0.7, 0.7, 0.7, 1 },
            sorting_layer = ifx controlled
                then 1
                else 0,
        },
        behavior = behavior,

        on_update = on_update,
    };
}

Snakey :: struct {
    #as using behavior: Karakuri.Behavior;
    controlled: bool;
}

#scope_file

on_update :: (self: *Karakuri.Entity) {
    snakey := self.behavior.(*Snakey);

    if snakey.controlled {
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

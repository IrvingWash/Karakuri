#import "Math";

snakey_prefab :: () -> Karakuri.Entity_Params {
    behavior := New(Snakey);

    return .{
        sprite = .{
            texture_path = "examples/snakey/assets/snakey.png",
            clip = .{ 0.25, 0.5 },
            offset = .{ 0, 0.5 }, // @Todo this is from bottom left, but we want from top left
        },
        behavior = behavior,

        on_update = on_update,
    };
}

Snakey :: struct {
    #as using behavior: Karakuri.Behavior;
}

#scope_file

on_update :: (self: *Karakuri.Entity) {
    move(self);

    if Karakuri.Input_Manager.is_key_down(.X) {
        using self.sprite;

        if offset.x == 0.5 {
            offset.x = 0;
        } else {
            offset.x += 0.25;
        }
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

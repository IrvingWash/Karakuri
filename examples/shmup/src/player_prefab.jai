player_prefab :: () -> Karakuri.Entity_Params {
    return .{
        name = "Player",
        transform = .{
            scale = .{ 100, 100 },
        },
        sprite = .{
            texture_path = "examples/shmup/assets/main_ship-1.png",
        },
        behavior = New(Player),
        flags = .SPRITE | .BEHAVIOR, // @TODO this is redundant

        on_update = on_update,
    };
}

Player :: struct {
    #as using behavior: Karakuri.Behavior;
    speed := 100;
}

#scope_file

on_update :: (entity: *Karakuri.Entity) {
    move(entity);
}

move :: (entity: *Karakuri.Entity) {
    disposition := (cast(*Player) entity.behavior).speed * Karakuri.Time_Manager.get_delta_time();

    if Karakuri.Input_Manager.get_key_state(.W) == .PRESS {
        entity.transform.position.y += disposition;
    }
    if Karakuri.Input_Manager.get_key_state(.S) == .PRESS {
        entity.transform.position.y -= disposition;
    }
    if Karakuri.Input_Manager.get_key_state(.A) == .PRESS {
        entity.transform.position.x -= disposition;
    }
    if Karakuri.Input_Manager.get_key_state(.D) == .PRESS {
        entity.transform.position.x += disposition;
    }
}

player_prefab :: () -> Karakuri.Entity_Params {
    return .{
        name = "Player",
        transform = .{
            position = .{ 0, -4 },
            scale = .{ 3, 3 },
        },
        sprite = .{
            texture_path = "examples/shmup/assets/main_ship-1.png",
        },
        behavior = New(Player),

        on_update = on_update,
    };
}

Player :: struct {
    #as using behavior: Karakuri.Behavior;
    speed := 5;
}

#scope_file

on_update :: (entity: *Karakuri.Entity) {
    shoot(entity);
    move(entity);
}

move :: (entity: *Karakuri.Entity) {
    disposition := (cast(*Player) entity.behavior).speed * Karakuri.Time_Manager.get_delta_time();

    if Karakuri.Input_Manager.is_key_pressed(.W) {
        entity.transform.position.y += disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.S) {
        entity.transform.position.y -= disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.A) {
        entity.transform.position.x -= disposition;
    }
    if Karakuri.Input_Manager.is_key_pressed(.D) {
        entity.transform.position.x += disposition;
    }
}

shoot :: (entity: *Karakuri.Entity) {
    // @TODO this is not a oneshot...
    if Karakuri.Input_Manager.is_key_down(.SPACE) {
        Karakuri.spawn_entity_into_world(projectile_prefab(entity.transform.position));
    }
}

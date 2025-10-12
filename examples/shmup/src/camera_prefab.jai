camera_prefab :: () -> Karakuri.Entity_Params {
    return .{
        name = "Camera",
        flags = .CAMERA,
        camera = .{
            color = .{ 0.3, 0.3, 0.3, 1 },
        },
        behavior = New(Camera),

        on_start = on_camera_start,
        on_late_update = on_camera_late_update,
    };
}

#scope_file

Camera :: struct {
    #as using behavior: Karakuri.Behavior;
    player_token: Karakuri.Entity_Token;
    is_targeting: bool;
}

on_camera_start :: (entity: *Karakuri.Entity) {
    camera := cast(*Camera) entity.behavior;

    player := Karakuri.get_world_entity("Player");

    camera.player_token = player.token;
}

on_camera_late_update :: (entity: *Karakuri.Entity) {
    camera := cast(*Camera) entity.behavior;

    if Karakuri.Input_Manager.is_key_down(.C) {
        camera.is_targeting = !camera.is_targeting;
    }

    if !camera.is_targeting {
        return;
    }

    player := Karakuri.get_world_entity(camera.player_token);
    if !player {
        return;
    }

    entity.transform.position = player.transform.position;
}

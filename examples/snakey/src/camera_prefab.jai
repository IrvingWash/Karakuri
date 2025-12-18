camera_prefab :: () -> Karakuri.Entity_Params {
    return {
        name     = "Camera",
        flags    = .CAMERA,
        behavior = New(Camera),

        on_start  = on_start,
        on_update = on_update,
    };
}

Camera :: struct {
    #as using behavior: Karakuri.Behavior;
    player_token: Karakuri.Entity_Token;
}

on_start :: (self: *Karakuri.Entity) {
    camera := self.behavior.(*Camera);

    player := Karakuri.get_world_entity("Player");
    assert(player != null);

    camera.player_token = player.token;
}

on_update :: (self: *Karakuri.Entity) {
    camera := self.behavior.(*Camera);
    player := Karakuri.get_world_entity(camera.player_token);
    if !player {
        return;
    }

    self.transform.position.x = player.transform.position.x;
}

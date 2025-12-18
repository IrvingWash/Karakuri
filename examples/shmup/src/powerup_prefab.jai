powerup_prefab :: (position: Vector2) -> Karakuri.Entity_Params {
    return {
        name = "Powerup",
        transform = {
            position = position,
            scale = { 2, 2 },
        },
        sprite = {
            texture_path = "examples/shmup/textures/icon-powerup.png",
        },
        box_collider = {
            size = { 0.2, 0.2 },
        },

        on_update = on_update,
        on_collision = on_collision,
    };
}

#scope_file

on_update :: (self: *Karakuri.Entity) {
    self.transform.position.y -= 5 * Karakuri.Time_Manager.get_delta_time();
}

on_collision :: (self: *Karakuri.Entity, other: *Karakuri.Entity) {
    if other.name == "Player" {
        Karakuri.despawn_entity_from_world(self.token);
    }
}

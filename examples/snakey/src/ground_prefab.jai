ground_prefab :: (x: float, y: float) -> Karakuri.Entity_Params {
    return {
        name = "Ground",
        transform = {
            position = { x, y },
            scale = { 10, 1 },
        },
        sprite = {
            texture_path = "examples/snakey/assets/square.png",
            color = { 0, 154.0 / 255.0, 23.0 / 255.0, 1 },
        },
        flags = .BOX_COLLIDER,

        on_collision = on_collision,
    };
}

#scope_file

on_collision :: (self: *Karakuri.Entity, other: *Karakuri.Entity) {
    if !Karakuri.entity_has_flags(other, .RIGID_BODY) || other.rigid_body.static {
        return;
    }

    other.transform.position.y = self.transform.position.y
        + self.box_collider.size.y / 2
        + other.box_collider.size.y / 2
        - other.box_collider.offset.y * 2;

    if other.rigid_body.velocity.y < 0 {
        other.rigid_body.velocity.y = 0;
    }
}

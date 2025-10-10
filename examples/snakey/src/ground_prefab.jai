ground_prefab :: (x: float, y: float) -> Karakuri.Entity_Params {
    behavior := New(Ground);
    behavior.flags |= .STATIC;

    return .{
        name = "Ground",
        transform = .{
            position = .{ x, y },
            scale = .{ 10, 1 },
        },
        sprite = .{
            texture_path = "examples/snakey/assets/square.png",
            color = .{ 0, 154.0 / 255.0, 23.0 / 255.0, 1 },
        },
        flags = .BOX_COLLIDER,
        behavior = behavior,

        on_collision = on_collision,
    };
}

Ground :: struct {
    #as using behavior: Karakuri.Behavior;
    #as using snakey_entity: Snakey_Entity;
}

#scope_file

on_collision :: (self: *Karakuri.Entity, other: *Karakuri.Entity) {
    if (.STATIC & other.behavior.(*Snakey_Entity).flags) == .STATIC {
        return;
    }

    other.transform.position.y = self.transform.position.y
        + self.box_collider.size.y / 2
        + other.box_collider.size.y / 2
        - other.box_collider.offset.y * 2;

    other.behavior.(*Snakey_Entity).velocity.y = 0;
}

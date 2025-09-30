Projectile_Destroyer_Placement :: enum {
    TOP;
    BOTTOM;
}

projectile_destroyer_prefab :: (
    placement: Projectile_Destroyer_Placement
) -> Karakuri.Entity_Params {
    return .{
        name = "Projectile Destroyer",
        transform = .{
            position = .{
                y = ifx placement == .TOP
                    then Karakuri.screen_top_to_world() + VERTICAL_OFFSET
                    else Karakuri.screen_bottom_to_world() - VERTICAL_OFFSET,
            },
        },
        box_collider = .{
            size = .{ 16, 1 },
        },
        on_collision = on_collision,
    };
}

#scope_file

VERTICAL_OFFSET :: 0.4;

on_collision :: (self: *Karakuri.Entity, other: *Karakuri.Entity) {
    if other.name == "Projectile" {
        Karakuri.despawn_entity_from_world(other.token);
    }
}

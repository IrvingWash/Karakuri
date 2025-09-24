Projectile_Destroyer_Placement :: enum {
    TOP;
    BOTTOM;
}

projectile_destroyer :: (
    placement: Projectile_Destroyer_Placement
) -> Karakuri.Entity_Params {
    return .{
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
    };
}

#scope_file
VERTICAL_OFFSET :: 0.3;

ground_prefab :: () -> Karakuri.Entity_Params {
    return .{
        transform = .{
            position = .{ 0, -2 },
            scale = .{ 10, 1 },
        },
        sprite = .{
            texture_path = "examples/snakey/assets/square.png",
        },
        flags = .BOX_COLLIDER,
    };
}

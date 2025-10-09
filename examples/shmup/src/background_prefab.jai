background_prefab :: () -> Karakuri.Entity_Params {
    return .{
        transform = .{
            scale = .{ 3, 3 },
        },
        sprite = .{
            texture_path = "examples/shmup/textures/background.png",
        },
    };
}

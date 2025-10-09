stars_overlay_prefab :: () -> Karakuri.Entity_Params {
    return .{
        transform = .{
            scale = .{
                Karakuri.screen_right_to_world(),
                Karakuri.screen_top_to_world() / 2,
            },
        },
        sprite = .{
            texture_path = "examples/shmup/textures/stars.png",
        },
    };
}

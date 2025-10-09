background_prefab :: () -> Karakuri.Entity_Params {
    print("%\n", Karakuri.screen_right_to_world());
    return .{
        transform = .{
            scale = .{
                Karakuri.screen_right_to_world(),
                Karakuri.screen_top_to_world() / 2,
            },
        },
        sprite = .{
            texture_path = "examples/shmup/textures/background.png",
        },
    };
}

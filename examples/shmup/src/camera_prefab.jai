camera_prefab :: () -> Karakuri.Entity_Params {
    return .{
        flags = .CAMERA,
        camera = .{
            color = .{ 0.3, 0.3, 0.3, 1 },
        }
    };
}

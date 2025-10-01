test_check_aabb_colliding :: () {
    a := create_entity(
        .{
            transform = .{
                position = .{ 4.25, 1.1 },
                scale = .{ 3, 3 },
            },
            box_collider = .{
                size = .{ 0.2, 0.45 },
                offset = .{0, 0.05 },
            },
        },
        .{ 0, 0 },
    );

    b := create_entity(
        .{
            transform = .{
                position = .{
                    x = 0,
                    y = 0,
                }
            },
            box_collider = .{
                size = .{ 8, 1 },
            },
        },
        .{ 1, 0 },
    );

    assert(check_aabb(a, b));
} @Test

test_check_aabb_not_colliding :: () {
    a := create_entity(
        .{
            transform = .{
                position = .{ 5, 1 },
                scale = .{ 3, 3 },
            },
            box_collider = .{
                size = .{ 0.2, 0.45 },
                offset = .{0, 0.05 },
            },
        },
        .{ 0, 0 },
    );

    b := create_entity(
        .{
            transform = .{
                position = .{
                    x = 0,
                    y = 0,
                }
            },
            box_collider = .{
                size = .{ 8, 1 },
            },
        },
        .{ 1, 0 },
    );

    assert(!check_aabb(a, b));
} @Test

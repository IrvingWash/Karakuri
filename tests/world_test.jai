#load "../src/world.jai";

test_deinit_world :: () {
    init_world();

    spawn_entity_into_world(.{});
    spawn_entity_into_world(.{});
    spawn_entity_into_world(.{});

    update_world();

    spawn_entity_into_world(.{});
    spawn_entity_into_world(.{});
    spawn_entity_into_world(.{});
    despawn_entity_from_world(.{ id = 1, generation = 0 });

    deinit_world();
} @Test

test_world :: () {
    init_world();
    defer deinit_world();

    spawn_entity_into_world(create_mario_params());
    spawn_entity_into_world(.{
        name = "Luigi",
        flags = .SPRITE,
        transform = .{
            position = .{ 30, 25 },
            scale = .{ 3, 3 },
            rotation = 0,
        },
        sprite = .{},
    });

    update_world();

    assert(get_world_entities().count == 2);

    despawn_entity_from_world(.{ 0, 0 });

    update_world();

    assert(get_world_entities().count == 2);

    peach_tags: [..]string;
    array_add(*peach_tags, "humanoid");

    spawn_entity_into_world(.{
        name = "Peach",
        flags = .SPRITE,
        tags = peach_tags,
    });

    despawn_entity_from_world(get_world_entity("Luigi").token);

    update_world();

    entities := get_world_entities();

    assert(entities.count == 2);
    assert(entities[1].name == "Peach");
    assert(entities[1].id == 1);
    assert(entities[1].generation == 1);

    spawn_entity_into_world(create_mario_params());
    spawn_entity_into_world(.{ name = "Finish Line" });

    update_world();

    alive_entities := get_world_entities(.ALIVE);
    assert(alive_entities.count == 3);

    entities_with_sprites := get_world_entities(.SPRITE);
    assert(entities_with_sprites.count == 2);

    alive_entities_with_sprites := get_world_entities(.ALIVE | .SPRITE);
    assert(entities_with_sprites.count == 2);

    humanoid_entities := get_world_entities(.["humanoid"]);
    assert(humanoid_entities.count == 2);
} @Test

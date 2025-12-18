create_mario :: (id: u32, generation: u32) -> Entity {
    return create_entity(
        create_mario_params(),
        {id, generation},
    );
}

create_mario_params :: () -> Entity_Params {
    mario_tags: [..]string;
    array_add(
        *mario_tags,
        "player",
        "controllable",
        "humanoid",
    );

    on_start :: (entity: *Entity) {}
    on_destroy :: (entity: *Entity) {}

    return {
        name = "Mario",
        tags = mario_tags,
        flags = .ALIVE | .SPRITE,
        transform = {
            position = {100, 200},
            scale = {2, 3},
            rotation = 0.785398,
        },
        on_start = on_start,
        on_destroy = on_destroy,
    };
}

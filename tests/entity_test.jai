#import "Basic";
#load "../src/entity.jai";

test_entity_creation :: () {
    mario := create_mario(1, 2);

    assert(mario.name == "Mario");
    assert(array_find(mario.tags, "player"));
    assert(array_find(mario.tags, "controllable"));
    assert(mario.flags & .ALIVE != 0);
    assert(mario.flags & .SPRITE != 0);
    assert(mario.transform.position.x == 100);
    assert(mario.transform.position.y == 200);
    assert(mario.transform.scale.x == 2);
    assert(mario.transform.scale.y == 3);
    assert(mario.transform.rotation == 0.785398);
    assert(mario.on_start != null);
    assert(mario.on_update == null);
    assert(mario.on_destroy != null);
    assert(mario.id == 1);
    assert(mario.generation == 2);
} @Test

test_entity_destruction :: () {
    mario := create_mario(1, 2);
    destroy_entity(*mario);

    assert(mario.name == "Mario");
    assert(mario.tags.count == 0);
    assert(mario.flags == 0);
    assert(mario.on_start == null);
    assert(mario.on_update == null);
    assert(mario.on_destroy == null);
} @Test

create_mario :: (id: u32, generation: u32) -> Entity {
    mario_tags: [..]string;
    array_add(
        *mario_tags,
        "player",
        "controllable",
    );

    on_start :: (entity: *Entity) {
        print("It's a-me!\n");
    }

    on_destroy :: (entity: *Entity) {
        print("Uwaaaaah\n");
    }

    return create_entity(
        Entity_Params.{
            name = "Mario",
            tags = mario_tags,
            flags = .ALIVE | .SPRITE,
            transform = .{
                position = .{100, 200},
                scale = .{2, 3},
                rotation = 0.785398,
            },
            on_start = on_start,
            on_destroy = on_destroy,
        },
        .{id, generation},
    );
}

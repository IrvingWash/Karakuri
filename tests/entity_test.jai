#import "Basic";

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
} @Test

test_is_alive :: () {
    mario := create_mario(1, 2);

    assert(is_alive(mario));

    destroy_entity(*mario);

    assert(!is_alive(mario));
} @Test

test_entity_comparison :: () {
    mario := create_mario(1, 2);

    assert(mario == mario);
} @Test

test_entity_has_flags :: () {
    mario := create_mario(1, 2);

    assert(entity_has_flags(mario, .ALIVE));
    assert(entity_has_flags(mario, .SPRITE));
    assert(entity_has_flags(mario, .ALIVE | .SPRITE));

    destroy_entity(*mario);

    assert(!entity_has_flags(mario, .ALIVE));
    assert(!entity_has_flags(mario, .SPRITE));
    assert(!entity_has_flags(mario, .ALIVE | .SPRITE));

    mario.flags = .SPRITE;

    assert(!entity_has_flags(mario, .ALIVE));
    assert(entity_has_flags(mario, .SPRITE));
    assert(!entity_has_flags(mario, .ALIVE | .SPRITE));
} @Test

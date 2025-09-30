#scope_module

run_physics_system :: () {
    entities_with_colliders := get_world_entities(.ALIVE | .BOX_COLLIDER);

    for a, i: entities_with_colliders {
        j := i + 1;

        while j < entities_with_colliders.count {
            defer j += 1;

            b := entities_with_colliders[j];

            if check_aabb(a, b) {
                if a.on_collision {
                    a.on_collision(a, b);
                }

                if b.on_collision {
                    b.on_collision(b, a);
                }
            }
        }
    }
}

#scope_file

check_aabb :: (
    a: Entity,
    b: Entity
) -> bool {
    a_size      := a.transform.scale * a.box_collider.size;
    a_half_size := a_size / 2;
    a_position  := a.transform.position + a.box_collider.offset * a_size;
    a_left      := a_position.x - a_half_size.x;
    a_top       := a_position.y + a_half_size.y;

    b_size      := b.transform.scale * b.box_collider.size;
    b_half_size := b_size / 2;
    b_position  := b.transform.position + b.box_collider.offset * b_size;
    b_left      := b_position.x - b_half_size.x;
    b_top       := b_position.y + b_half_size.y;

    return a_left            < b_left + b_size.x
        && a_left + a_size.x > b_left
        && a_top             > b_top - b_size.y
        && a_top - a_size.y  < b_top;
}

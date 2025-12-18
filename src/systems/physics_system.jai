#scope_module

init_physics_system :: () {
    system = {};
}

deinit_physics_system :: () {
    array_reset(*system.box_colliders);
    array_reset(*system.rigid_bodies);

    system = {};
}

run_physics_system :: () {
    if system.box_colliders.count == 0 || has_world_changed() {
        array_reset(*system.box_colliders);
        system.box_colliders = array_copy(get_world_entities(.BOX_COLLIDER));
    }
    for a, i: system.box_colliders {
        j := i + 1;

        while j < system.box_colliders.count {
            defer j += 1;

            b := system.box_colliders[j];

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

    if system.rigid_bodies.count == 0 || has_world_changed() {
        array_reset(*system.rigid_bodies);
        system.rigid_bodies = array_copy(get_world_entities(.RIGID_BODY));
    }
    for entity: system.rigid_bodies {
        if !entity.rigid_body.static {
            entity.transform.position += entity.rigid_body.velocity;
        }
    }
}

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

#scope_file

Physics_System :: struct {
    box_colliders: []*Entity;
    rigid_bodies:  []*Entity;
}

system: Physics_System = ---;

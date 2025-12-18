get_world_entities :: (flags: Entity_Flags = .ALIVE) -> []*Entity {
    patched_flags := flags | .ALIVE;

    result: [..]*Entity;
    result.allocator = temp;

    for *entity: world.entities {
        if entity_has_flags(entity, patched_flags) {
            array_add(*result, entity);
        }
    }

    return result;
}

get_world_entities :: (tags: []string) -> []*Entity {
    result: [..]*Entity;
    result.allocator = temp;

    for *entity: world.entities {
        if !is_alive(entity) {
            continue;
        }

        has_all_tags := true;

        for  tag: tags {
            if !array_find(entity.tags, tag) {
                has_all_tags = false;

                break;
            }
        }

        if has_all_tags {
            array_add(*result, entity);
        }
    }

    return result;
}

get_world_entity :: (token: Entity_Token) -> *Entity {
    entity := *world.entities[token.id];

    if (
        is_alive(entity)
        && entity.generation == token.generation
    ) {
        return entity;
    }

    return null;
}

get_world_entity :: (name: string) -> *Entity {
    for *entity: world.entities {
        if is_alive(entity) && name == entity.name {
            return entity;
        }
    }

    return null;
}

spawn_entity_into_world :: (entity_params: Entity_Params) {
    array_add(*world.entities_to_spawn, entity_params);
}

despawn_entity_from_world :: (token: Entity_Token) {
    array_add_if_unique(*world.entities_to_despawn, token);
}

#scope_module

#import "Basic";

World :: struct {
    entities:            [..]Entity;
    free_tokens:         [..]Entity_Token;
    entities_to_spawn:   [..]Entity_Params;
    entities_to_despawn: [..]Entity_Token;
    has_changed:         bool = true;
}

init_world :: (entities: []Entity_Params) {
    world = {};

    for entity: entities {
        spawn_entity(entity);
    }

    for *entity: world.entities {
        start_entity(entity);
    }
}

deinit_world :: () {
    for *entity: world.entities {
        if is_alive(entity) {
            destroy_entity(entity);
        }
    }
    array_reset(*world.entities);

    for *entity: world.entities_to_spawn {
        destroy_entity_params(entity);
    }
    array_reset(*world.entities_to_spawn);

    array_reset(*world.free_tokens);
    array_reset(*world.entities_to_despawn);
}

has_world_changed :: () -> bool {
    return world.has_changed;
}

update_world :: () {
    world.has_changed = false;

    despawn_entities();

    spawn_entities();

    update_entities();

    late_update_entities();
}

#scope_file

world: World = ---;

despawn_entities :: () {
    if world.entities_to_despawn.count > 0 {
        world.has_changed = true;
    }

    defer array_reset(*world.entities_to_despawn);

    for token: world.entities_to_despawn {
        entity := get_world_entity(token);
        if !entity {
            continue;
        }

        array_add(*world.free_tokens, entity.token);

        destroy_entity(entity);
    }
}

spawn_entities :: () {
    if world.entities_to_spawn.count > 0 {
        world.has_changed = true;
    }

    defer array_reset(*world.entities_to_spawn);

    entities_to_start: [..]Entity_Token;
    defer array_reset(*entities_to_start);

    for entity_params: world.entities_to_spawn {
        token := spawn_entity(entity_params);

        array_add(*entities_to_start, token);
    }

    for token: entities_to_start {
        entity := get_world_entity(token);
        if entity {
            start_entity(entity);
        }
    }
}

update_entities :: () {
    for *entity: world.entities {
        if is_alive(entity) {
            update_entity(entity);
        }
    }
}

late_update_entities :: () {
    for *entity: world.entities {
        if is_alive(entity) {
            late_update_entity(entity);
        }
    }
}

spawn_entity :: (params: Entity_Params) -> Entity_Token {
    token: Entity_Token = ---;
    if world.free_tokens.count > 0 {
        token = pop(*world.free_tokens);
        token.generation += 1;

        world.entities[token.id] = create_entity(params, token);
    } else {
        token = { id = xx world.entities.count };

        array_add(
            *world.entities,
            create_entity(params, token),
        );
    }

    return token;
}

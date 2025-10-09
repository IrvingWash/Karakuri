Entity :: struct {
    #as   using params: Entity_Params;
    using token: Entity_Token;
}

Entity_Flags :: enum_flags u64 {
    ALIVE;
    SPRITE;
    CAMERA;
    BEHAVIOR;
    BOX_COLLIDER;
    ANIMATION_CONTROLLER;
}

Entity_Params :: struct {
    name:       string;
    tags:       [..]string;
    flags:      Entity_Flags;

    transform:            Transform;
    sprite:               Sprite;
    camera:               Camera;
    behavior:             *Behavior;
    box_collider:         Box_Collider;
    animation_controller: Animation_Controller;

    on_start:       (self: *Entity);
    on_update:      (self: *Entity);
    on_late_update: (self: *Entity);
    on_destroy:     (self: *Entity);
    on_collision:   (self: *Entity, other: *Entity);
}

operator == :: (a: Entity_Token, b: Entity_Token) -> bool {
    return a.id == b.id && a.generation == b.generation;
}

operator == :: (a: Entity, b: Entity) -> bool {
    return a.token == b.token;
}

is_alive :: inline (using entity: Entity) -> bool {
    return flags & .ALIVE != 0;
}

entity_has_flags :: inline (entity: Entity, flags: Entity_Flags) -> bool {
    return (flags & entity.flags) == flags;
}

entity_has_flags :: inline (
    entity: Entity_Params,
    flags: Entity_Flags
) -> bool {
    return (flags & entity.flags) == flags;
}

#scope_module

Entity_Token :: struct {
    id:         u32;
    generation: u32;
}

create_entity :: (params: Entity_Params, token: Entity_Token) -> Entity {
    entity := Entity.{
        token = token,
        params = params,
    };

    entity.flags |= .ALIVE;
    if entity.sprite.texture_path != "" {
        entity.flags |= .SPRITE;
    }
    if entity.behavior {
        entity.flags |= .BEHAVIOR;
    }
    if (
        entity.box_collider.size != DEFAULT_SCALE
        || entity.box_collider.offset != ZERO_VECTOR2
    ) {
        entity.flags |= .BOX_COLLIDER;
    }
    if entity.animation_controller.animations.count > 0 {
        entity.flags |= .ANIMATION_CONTROLLER;
        entity.flags |= .SPRITE;
    }

    if entity_has_flags(entity, .SPRITE) {
        Asset_Manager.add_texture(params.sprite.texture_path);
    }
    if entity_has_flags(entity, .ANIMATION_CONTROLLER) {
        for animation: params.animation_controller.animations {
            Asset_Manager.add_texture(animation.texture_path);
        }
    }

    return entity;
}

start_entity :: inline (using entity: *Entity) {
    if on_start {
        on_start(entity);
    }
}

update_entity :: inline (using entity: *Entity) {
    if on_update {
        on_update(entity);
    }
}

late_update_entity :: inline (using entity: *Entity) {
    if on_late_update {
        on_late_update(entity);
    }
}

// @TODO P5 entity is cleaned up and it's lifecycle event is called at the same time. If this entity wants to refer to another entity destroyed in the same pass, things will go badly
destroy_entity :: (using entity: *Entity) {
    if on_destroy {
        on_destroy(entity);
    }

    destroy_entity_params(entity);
}

destroy_entity_params :: (using entity_params: *Entity_Params) {
    array_reset(*tags);

    if behavior {
        free(behavior);
    }

    if entity_has_flags(entity_params, .ANIMATION_CONTROLLER) {
        deinit(*animation_controller.animations);
    }

    flags = 0;
}

#scope_file

using Basic :: #import "Basic";
#poke_name Basic operator ==;
#import "Hash_Table";

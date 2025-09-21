#import "Basic";
#load "components.jai";

Entity :: struct {
    using token: Entity_Token;
    using params: Entity_Params;
}

Entity_Flags :: enum_flags u64 {
    ALIVE;
    SPRITE;
}

Entity_Params :: struct {
    name: string;
    tags: [..]string;
    flags: Entity_Flags;

    transform: Transform;
    sprite: Sprite;

    on_start: (self: *Entity);
    on_update: (self: *Entity);
    on_destroy: (self: *Entity);
}

#scope_module

Entity_Token :: struct {
    id: u32;
    generation: u32;
}

create_entity :: (params: Entity_Params, token: Entity_Token) -> Entity {
    return .{
        token = token,
        params = params,
    };
}

destroy_entity :: (using entity: *Entity) {
    array_reset(*tags);
    flags = 0;

    on_start = null;
    on_update = null;
    on_destroy = null;
}

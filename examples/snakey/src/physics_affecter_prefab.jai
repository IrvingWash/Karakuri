physics_affecter_prefab :: () -> Karakuri.Entity_Params {
    return .{
        name = "Physics Affecter",

        on_update = on_update,
    };
}

#scope_file

on_update :: (self: *Karakuri.Entity) {
    entities := Karakuri.get_world_entities();

    for entity: entities {
        if self == entity {
            continue;
        }

        snakey_entity := entity.behavior.(*Snakey_Entity);

        if ((.STATIC & snakey_entity.flags) == .STATIC) {
            continue;
        }

        snakey_entity.velocity.y -= 1 * Karakuri.Time_Manager.get_delta_time();

        entity.transform.position += snakey_entity.velocity;
    }
}

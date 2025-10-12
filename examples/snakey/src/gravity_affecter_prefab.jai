gravity_affecter_prefab :: () -> Karakuri.Entity_Params {
    return .{
        name = "Physics Affecter",

        on_update = on_update,
    };
}

#scope_file

on_update :: (self: *Karakuri.Entity) {
    entities := Karakuri.get_world_entities();

    for entity: entities {
        if self == entity
            || !Karakuri.entity_has_flags(entity, .RIGID_BODY)
            || entity.rigid_body.static
        {
            continue;
        }

        entity.rigid_body.velocity.y -= 1 * Karakuri.Time_Manager.get_delta_time();
    }
}

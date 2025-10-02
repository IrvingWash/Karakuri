enemy_spawner_prefab :: () -> Karakuri.Entity_Params {
    return .{
        behavior = New(Enemy_Spawner),

        on_start   = on_start,
        on_destroy = on_destroy,
    };
}

#scope_file

Enemy_Spawner :: struct {
    #as using behavior: Karakuri.Behavior;
    spawn_timer_id: s64 = -1;
}

on_start :: (self: *Karakuri.Entity) {
    enemy_spawner := self.behavior.(*Enemy_Spawner);

    Karakuri.Timer_Manager.set_timer(
        2,
        (data: *void) {
            Karakuri.spawn_entity_into_world(enemy_prefab(.{
                Karakuri.random_in_range(-5, 5),
                Karakuri.random_in_range(2, 5)
            }));
        },
        is_interval = true,
    );
}

on_destroy :: (self: *Karakuri.Entity) {
    enemy_spawner := self.behavior.(*Enemy_Spawner);

    Karakuri.Timer_Manager.cancel_timers(xx enemy_spawner.spawn_timer_id);
}

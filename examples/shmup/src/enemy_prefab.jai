enemy_prefab :: (position: Vector2) -> Karakuri.Entity_Params {
    return .{
        name = "Enemy",
        transform = .{
            position = position,
            scale = .{ 3, 3 },
        },
        sprite = .{
            texture_path = "examples/shmup/textures/enemy_2_1.png",
        },
        box_collider = .{
            size = .{ 0.4, 0.3 },
        },
        behavior = New(Enemy),

        on_start     = on_start,
        on_collision = on_collision,
        on_destroy   = on_destroy,
    };
}

Enemy :: struct {
    #as using behavior: Karakuri.Behavior;
    shoot_timer_id: s64 = -1;
}

#scope_file

on_start :: (self: *Karakuri.Entity) {
    enemy := self.behavior.(*Enemy);

    token_for_timer := New(Karakuri.Entity_Token);
    token_for_timer.* = self.token;
    enemy.shoot_timer_id = Karakuri.Timer_Manager.set_timer(
        1,
        (token: *void) {
            self := Karakuri.get_world_entity(
                token.(*Karakuri.Entity_Token)
            );

            Karakuri.spawn_entity_into_world(
                projectile_prefab(
                    self.transform.position - .{ 0, 1.0 },
                    .ENEMY,
                ),
            );
        },
        token_for_timer,
        is_interval = true,
    );
}

on_collision :: (self: *Karakuri.Entity, other: *Karakuri.Entity) {
    if (
        other.name == "Projectile"
        && other.behavior.(*Projectile).emitter == .PLAYER
    ) {
        if Karakuri.random_in_range(0, 1) >= 0.9 {
            Karakuri.spawn_entity_into_world(powerup_prefab(self.transform.position));
        }

        Karakuri.despawn_entity_from_world(self.token);
    }
}

on_destroy :: (self: *Karakuri.Entity) {
    Karakuri.Timer_Manager.cancel_timers(
        xx self.behavior.(*Enemy).shoot_timer_id,
    );
}

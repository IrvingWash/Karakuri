#import "Math";

Projectile_Emitter :: enum {
    PLAYER;
    ENEMY;
}

projectile_prefab :: (
    position: Vector2,
    emitter: Projectile_Emitter
) -> Karakuri.Entity_Params {
    behavior := New(Projectile);
    behavior.emitter = emitter;
    if emitter == .ENEMY {
        behavior.speed *= -1;
    }

    return .{
        name = "Projectile",
        transform = .{
            position = position,
            scale = .{ 3, 3 },
        },
        sprite = .{
            texture_path = "examples/shmup/assets/projectile_1.png",
        },
        behavior = behavior,
        box_collider = .{
            size = .{ 0.1, 0.3 },
        },

        on_update = on_projectile_update,
        on_collision = on_collision,
    };
}

Projectile :: struct {
    #as using behavior: Karakuri.Behavior;
    speed:              = 20;
    emitter:            Projectile_Emitter;
}

move :: (entity: *Karakuri.Entity) {
    speed := (cast(*Projectile) entity.behavior).speed;
    disposition := Karakuri.Time_Manager.get_delta_time() * speed;

    entity.transform.position.y += disposition;
}

#scope_file

on_projectile_update :: (entity: *Karakuri.Entity) {
    move(entity);
}

on_collision :: (self: *Karakuri.Entity, other: *Karakuri.Entity) {
    if other.name == "Projectile Destroyer" {
        Karakuri.despawn_entity_from_world(self.token);
    }

    if (
        other.name == "Enemy"
        && self.behavior.(*Projectile).emitter != .ENEMY
    ) {
        Karakuri.despawn_entity_from_world(self.token);
    }

    if (
        other.name == "Player"
        && self.behavior.(*Projectile).emitter != .PLAYER
    ) {
        Karakuri.despawn_entity_from_world(self.token);
    }
}

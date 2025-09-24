#import "Math";

projectile_prefab :: (position: Vector2) -> Karakuri.Entity_Params {
    return .{
        name = "Projectile",
        transform = .{
            position = position,
            scale = .{ 3, 3 },
        },
        sprite = .{
            texture_path = "examples/shmup/assets/projectile_1.png",
        },
        behavior = New(Projectile),
        box_collider = .{
            size = .{ 0.1, 0.3 },
        },

        on_update = on_projectile_update,
    };
}

Projectile :: struct {
    #as using behavior: Karakuri.Behavior;
    speed := 20;
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

#import "Math";

projectile_prefab :: (position: Vector2) -> Karakuri.Entity_Params {
    return .{
        name = "Projectile",
        transform = .{
            position = position,
            scale = .{ 10, 20 },
        },
        sprite = .{
            texture_path = "examples/shmup/assets/projectile_1.png",
        },
        behavior = New(Projectile),

        on_update = on_projectile_update,
    };
}

Projectile :: struct {
    #as using behavior: Karakuri.Behavior;
    speed := 200;
}

move :: (entity: *Karakuri.Entity) {
    speed := (cast(*Projectile) entity.behavior).speed;
    disposition := Karakuri.Time_Manager.get_delta_time() * speed;
    print("%\n", speed);

    entity.transform.position.y += disposition;
}

#scope_file
on_projectile_update :: (entity: *Karakuri.Entity) {
    move(entity);
}

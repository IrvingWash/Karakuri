#import "Basic"()(MEMORY_DEBUGGER = true, TEMP_ALLOCATOR_POISON_FREED_MEMORY = true);
Karakuri :: #import "Karakuri"()(DEBUG = true);

#load "../../utils.jai";
#load "camera_prefab.jai";
#load "player_prefab.jai";
#load "projectile_prefab.jai";
#load "projectile_destroyer_prefab.jai";
#load "enemy_prefab.jai";
#load "enemy_spawner_prefab.jai";

main :: () {
    setup_formatting();

    Karakuri.init(.{
        title = "Shmup",
        target_fps = 60,
        initial_scene = scene,
    });

    Karakuri.run();

    Karakuri.deinit();

    report_memory_leaks();
}

scene :: () -> [..]Karakuri.Entity_Params {
    result: [..]Karakuri.Entity_Params;

    array_add(
        *result,
        camera_prefab(),
        player_prefab(),
        projectile_destroyer_prefab(.TOP),
        projectile_destroyer_prefab(.BOTTOM),
        enemy_spawner_prefab(),
    );

    return result;
}


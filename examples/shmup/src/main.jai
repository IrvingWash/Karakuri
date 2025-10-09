#import "Basic"()(MEMORY_DEBUGGER = true, TEMP_ALLOCATOR_POISON_FREED_MEMORY = true);
Karakuri :: #import "Karakuri"()(DEBUG = true);

#load "../../utils.jai";
#load "camera_prefab.jai";
#load "player_prefab.jai";
#load "projectile_prefab.jai";
#load "projectile_destroyer_prefab.jai";
#load "enemy_prefab.jai";
#load "enemy_spawner_prefab.jai";
#load "background_prefab.jai";
#load "stars_overlay_prefab.jai";

main :: () {
    setup_formatting();

    Karakuri.init(.{
        title         = "Shmup",
        target_fps    = 60,
        initial_scene = scene,
        fullscreen    = true,
        vsync         = false,
        window_width  = 270 * 2,
        window_height = 480 * 2,
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
        background_prefab(),
        stars_overlay_prefab(),
        player_prefab(),
        projectile_destroyer_prefab(.TOP),
        projectile_destroyer_prefab(.BOTTOM),
        enemy_spawner_prefab(),
    );

    return result;
}


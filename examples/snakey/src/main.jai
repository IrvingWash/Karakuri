#import "Basic"()(MEMORY_DEBUGGER = true, TEMP_ALLOCATOR_POISON_FREED_MEMORY = true);
Karakuri :: #import "Karakuri"()(DEBUG = true, EDITOR = false);

#load "../../utils.jai";
#load "camera_prefab.jai";
#load "snakey_prefab.jai";
#load "ground_prefab.jai";
#load "gravity_affecter_prefab.jai";

main :: () {
    setup_formatting();

    Karakuri.init({
        title             = "Snakey",
        target_fps        = 120,
        initial_scene     = scene,
        vsync             = false,
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
        snakey_prefab(),
        ground_prefab(-5, -2),
        ground_prefab(15, -2),
        ground_prefab(6, 0),
        gravity_affecter_prefab(),
    );

    return result;
}

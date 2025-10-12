#import "Basic"()(MEMORY_DEBUGGER = true, TEMP_ALLOCATOR_POISON_FREED_MEMORY = true);
Karakuri :: #import "Karakuri"()(DEBUG = true, EDITOR = true);

#load "../../utils.jai";
#load "camera_prefab.jai";
#load "square_prefab.jai";

main :: () {
    setup_formatting();

    Karakuri.init(.{
        title             = "Snakey",
        target_fps        = 120,
        initial_scene     = scene,
        vsync             = true,
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
        square_prefab(true),
        square_prefab(false),
    );

    return result;
}

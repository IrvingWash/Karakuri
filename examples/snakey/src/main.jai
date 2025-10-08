#import "Basic"()(MEMORY_DEBUGGER = true, TEMP_ALLOCATOR_POISON_FREED_MEMORY = true);
Karakuri :: #import "Karakuri";

#load "../../utils.jai";
#load "camera_prefab.jai";
#load "snakey_prefab.jai";

main :: () {
    setup_formatting();

    Karakuri.init(.{
        title = "Snakey",
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
        snakey_prefab(true),
        snakey_prefab(),
    );

    return result;
}

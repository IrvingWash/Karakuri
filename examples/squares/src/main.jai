#import "Basic"()(MEMORY_DEBUGGER = true, TEMP_ALLOCATOR_POISON_FREED_MEMORY = true);
Karakuri :: #import "Karakuri";

#load "../../utils.jai";
#load "camera_prefab.jai";
#load "square_prefab.jai";

main :: () {
    setup_formatting();

    Karakuri.init(.{
        title = "Squares",
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
        square_prefab(true),
        square_prefab(),
    );

    return result;
}

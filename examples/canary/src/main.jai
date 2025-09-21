#import "Basic"()(MEMORY_DEBUGGER = true, TEMP_ALLOCATOR_POISON_FREED_MEMORY = true);
#load "../../utils.jai";
Karakuri :: #import "Karakuri"()(DEBUG = true);

main :: () {
    setup_formatting();

    Karakuri.init(.{
        title = "Canary",
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
        Karakuri.Entity_Params.{
            flags = .CAMERA,
        },
        Karakuri.Entity_Params.{
            name = "Sonic",
            transform = .{
                position = .{ 500, 300 },
            },
            sprite = .{},
            flags = .SPRITE,
            on_start = on_sonic_start,
            on_update = on_sonic_update,
            on_destroy = on_sonic_destroy,
        }
    );

    return result;
}

on_sonic_start :: (entity: *Karakuri.Entity) {
    print("Sonic started\n");
}

on_sonic_update :: (entity: *Karakuri.Entity) {
    print("Sonic updated\n");
}

on_sonic_destroy :: (entity: *Karakuri.Entity) {
    print("Sonic destroyed\n");
}

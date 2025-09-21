#import "Basic"()(MEMORY_DEBUGGER = true, TEMP_ALLOCATOR_POISON_FREED_MEMORY = true);
#load "../../utils.jai";
Karakuri :: #import "Karakuri"()(DEBUG = true);

main :: () {
    setup_formatting();

    Karakuri.init(.{
        title = "Canary",
        target_fps = 60,
    });

    Karakuri.run();

    Karakuri.deinit();

    report_memory_leaks();
}

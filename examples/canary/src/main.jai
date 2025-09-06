#import "Basic"()(MEMORY_DEBUGGER = true, TEMP_ALLOCATOR_POISON_FREED_MEMORY = true);
#load "../../utils.jai";

main :: () {
    setup_formatting();

    print("Hello, Canary!\n");
}

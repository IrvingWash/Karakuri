init :: (config: Engine_Config) {}

deinit :: () {}

run :: () {}

#scope_file

Engine_Config :: struct {
    name: string = "Karakuri";
    target_fps: u32 = 60;
}

#import "Basic";

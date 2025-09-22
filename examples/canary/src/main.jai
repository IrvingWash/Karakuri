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
            camera = .{
                color = .{ 0.3, 0.3, 0.3, 1 },
            }
        },
        Karakuri.Entity_Params.{
            name = "Sonic",
            transform = .{
                position = .{ 50, 30 },
                scale = .{ 50, 50 },
            },
            sprite = .{
                texture_path = "examples/canary/assets/square.png",
                color = .{ 0, 0, 1, 1 },
            },
            flags = .SPRITE,
            on_start = on_sonic_start,
            on_update = on_sonic_update,
            on_destroy = on_sonic_destroy,
        },
        Karakuri.Entity_Params.{
            name = "Tails",
            transform = .{
                position = .{ 100, 100 },
                scale = .{ 50, 50 },
            },
            sprite = .{
                texture_path = "examples/canary/assets/square.png",
                color = .{ 1, 1, 0, 1 },
            },
            flags = .SPRITE,
        }
    );

    return result;
}

on_sonic_start :: (entity: *Karakuri.Entity) {
    print("Sonic started\n");
}

on_sonic_update :: (entity: *Karakuri.Entity) {
    if Karakuri.Input_Manager.get_key_state(.W) == Karakuri.Input_Manager.Key_State.PRESS {
        entity.transform.position.y += 100 * Karakuri.Time_Manager.get_delta_time();
    }
    if Karakuri.Input_Manager.get_key_state(.S) == Karakuri.Input_Manager.Key_State.PRESS {
        entity.transform.position.y -= 100 * Karakuri.Time_Manager.get_delta_time();
    }
    if Karakuri.Input_Manager.get_key_state(.A) == Karakuri.Input_Manager.Key_State.PRESS {
        entity.transform.position.x -= 100 * Karakuri.Time_Manager.get_delta_time();
    }
    if Karakuri.Input_Manager.get_key_state(.D) == Karakuri.Input_Manager.Key_State.PRESS {
        entity.transform.position.x += 100 * Karakuri.Time_Manager.get_delta_time();
    }
}

on_sonic_destroy :: (entity: *Karakuri.Entity) {
    print("Sonic destroyed\n");
}

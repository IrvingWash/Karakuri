#import "Basic";

init :: (target_fps: u32) {
    target_delta_time: float64 = 1.0 / target_fps;
    max_delta_time: float64 = target_delta_time * 2.0;

    manager = .{
        target_delta_time = target_delta_time,
        max_delta_time = max_delta_time,
    };
}

cap_frame_rate :: () -> delta_time: float {
    time_to_wait := manager.target_delta_time - (seconds_since_init() - manager.last_time);

    if time_to_wait > 0 && time_to_wait <= manager.target_delta_time {
        sleep_milliseconds(cast(s32) (time_to_wait * 1000.0));
    }

    now := seconds_since_init();
    delta_time := now - manager.last_time;
    if delta_time > manager.max_delta_time {
        delta_time = manager.max_delta_time;
    }

    manager.last_time = now;

    return xx delta_time;
}

#scope_file

FPS_Manager :: struct {
    target_delta_time: float64;
    last_time: float64;
    max_delta_time: float64;
}

manager: FPS_Manager = ---;

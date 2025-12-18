#import "Basic";

init :: (target_fps: u32) {
    target_delta_time: float64 = 1.0 / target_fps;
    max_delta_time: float64 = target_delta_time * 2.0;

    manager = {
        target_delta_time = target_delta_time,
        max_delta_time = max_delta_time,
    };
}

deinit :: () {
    manager = {};
}

cap_frame_rate :: () {
    time_to_wait := manager.target_delta_time - (seconds_since_init() - manager.last_time);

    if time_to_wait > 0 && time_to_wait <= manager.target_delta_time {
        sleep_milliseconds(cast(s32) (time_to_wait * 1000.0));
    }

    now := seconds_since_init();

    manager.delta_time = (now - manager.last_time) * manager.time_scale;
    if manager.delta_time > manager.max_delta_time {
        manager.delta_time = manager.max_delta_time;
    }

    manager.last_time = now;
}

get_delta_time :: () -> float {
    return xx manager.delta_time;
}

set_time_scale :: (value: float64) {
    manager.time_scale = value;
}

#scope_file

Time_Manager :: struct {
    target_delta_time: float64;
    last_time:         float64;
    max_delta_time:    float64;
    delta_time:        float64;
    time_scale:        float64 = 1;
}

manager: Time_Manager = ---;

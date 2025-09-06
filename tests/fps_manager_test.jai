#import "Basic";
#import "FPS_Manager";

test_max_delta_time :: () {
    target_fps: u32 = 60;
    target_delta_time: float64 = 1.0 / target_fps;
    max_delta_time: float64 = target_delta_time * 2.0;

    init(target_fps);

    cap_frame_rate();

    sleep_milliseconds(300);

    dt_after_long_sleep := cap_frame_rate();

    assert(dt_after_long_sleep <= max_delta_time);
} @Test

init_timer_manager :: () {
    manager = .{};
}

deinit_timer_manager :: () {
    for timer: manager.timers {
        if timer.should_cleanup && timer.data {
            free(timer.data);
        }
    }

    table_reset(*manager.timers);

    manager = .{};
}

update_timer_manager :: (delta_time: float) {
    manager.current_time += delta_time;

    for *timer: manager.timers {
        if timer.start_time + timer.duration > manager.current_time {
            continue;
        }

        timer.proc(timer.data);

        if timer.is_interval {
            timer.start_time += timer.duration;
        } else {
            table_remove(*manager.timers, timer.id);
        }
    }
}

set_timer :: (
    milliseconds: float,
    proc: (data: *void),
    data: *void,
    is_interval: bool = false,
    should_cleanup: bool = true
) -> id: u32 {
    defer manager.next_id += 1;

    table_add(
        *manager.timers,
        manager.next_id,
        .{
            id             = manager.next_id,
            start_time     = manager.current_time,
            duration       = milliseconds,
            proc           = proc,
            data           = data,
            is_interval    = is_interval,
            should_cleanup = should_cleanup,
        },
    );

    return manager.next_id;
}

cancel_timer :: (id: u32) {
    ok, timer := table_remove(*manager.timers, id);

    if ok && timer.should_cleanup && timer.data {
        free(timer.data);
    }
}

#scope_file

Timer_Manager :: struct {
    current_time: float;
    next_id:      u32;
    timers:       Table(u32, Timer_Data);
}

Timer_Data :: struct {
    id:             u32;
    start_time:     float;
    duration:       float;
    proc:           (data: *void);
    data:           *void;
    is_interval:    bool;
    should_cleanup: bool;
}

manager: Timer_Manager = ---;

#scope_file

#import "Hash_Table";
#import "Basic";

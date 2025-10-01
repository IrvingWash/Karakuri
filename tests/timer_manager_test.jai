Timer_Manager :: #import "Timer_Manager";

test_proc_call_count: u32;

test_proc :: (data: *void) {
    test_proc_call_count += 1;
};

test_set_timer_non_interval :: () {
    test_proc_call_count = 0;

    Timer_Manager.init();
    defer Timer_Manager.deinit();

    first_id := Timer_Manager.set_timer(1, test_proc, null);
    assert(first_id == 0);

    Timer_Manager.update(0.5);
    assert(test_proc_call_count == 0);

    Timer_Manager.update(0.5);
    assert(test_proc_call_count == 1);

    second_id := Timer_Manager.set_timer(3, test_proc, null);
    assert(second_id == 1);

    Timer_Manager.update(1.9);
    assert(test_proc_call_count == 1);

    Timer_Manager.cancel_timers(second_id);

    Timer_Manager.update(7.1);
    assert(test_proc_call_count == 1);
} @Test

test_set_timer_interval :: () {
    test_proc_call_count = 0;

    Timer_Manager.init();
    defer Timer_Manager.deinit();

    first_id := Timer_Manager.set_timer(1, test_proc, null, is_interval = true);
    assert(first_id == 0);

    Timer_Manager.update(0.5);
    assert(test_proc_call_count == 0);

    Timer_Manager.update(0.4);
    assert(test_proc_call_count == 0);

    Timer_Manager.update(0.1);
    assert(test_proc_call_count == 1);

    Timer_Manager.update(0.5);
    assert(test_proc_call_count == 1);

    Timer_Manager.update(0.5);
    assert(test_proc_call_count == 2);

    Timer_Manager.update(3);
    assert(test_proc_call_count == 3);

    Timer_Manager.cancel_timers(first_id);

    Timer_Manager.update(5);
    assert(test_proc_call_count == 3);
} @Test

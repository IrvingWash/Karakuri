#import "Timer_Manager";

test_proc_call_count: u32;

test_proc :: (data: *void) {
    test_proc_call_count += 1;
};

test_set_timer_non_interval :: () {
    test_proc_call_count = 0;

    init_timer_manager();
    defer deinit_timer_manager();

    first_id := set_timer(1, test_proc, null);
    assert(first_id == 0);

    update_timer_manager(0.5);
    assert(test_proc_call_count == 0);

    update_timer_manager(0.5);
    assert(test_proc_call_count == 1);

    second_id := set_timer(3, test_proc, null);
    assert(second_id == 1);

    update_timer_manager(1.9);
    assert(test_proc_call_count == 1);

    cancel_timer(second_id);

    update_timer_manager(7.1);
    assert(test_proc_call_count == 1);
} @Test

test_set_timer_interval :: () {
    test_proc_call_count = 0;

    init_timer_manager();
    defer deinit_timer_manager();

    first_id := set_timer(1, test_proc, null, is_interval = true);
    assert(first_id == 0);

    update_timer_manager(0.5);
    assert(test_proc_call_count == 0);

    update_timer_manager(0.4);
    assert(test_proc_call_count == 0);

    update_timer_manager(0.1);
    assert(test_proc_call_count == 1);

    update_timer_manager(0.5);
    assert(test_proc_call_count == 1);

    update_timer_manager(0.5);
    assert(test_proc_call_count == 2);

    update_timer_manager(3);
    assert(test_proc_call_count == 3);

    cancel_timer(first_id);

    update_timer_manager(5);
    assert(test_proc_call_count == 3);
} @Test

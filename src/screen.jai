screen_bottom_to_world :: () -> float {
    _, height := Window_Manager.get_render_size();
    _, y_scale := Window_Manager.get_dpi_scale();

    return -cast(float) height / y_scale / cast(float) PIXELS_PER_UNIT;
}

screen_top_to_world :: () -> float {
    _, height := Window_Manager.get_render_size();
    _, y_scale := Window_Manager.get_dpi_scale();

    return cast(float) height / y_scale / cast(float) PIXELS_PER_UNIT;
}

screen_right_to_world :: () -> float {
    width, _ := Window_Manager.get_render_size();
    x_scale, _ := Window_Manager.get_dpi_scale();

    return cast(float) width / x_scale / cast(float) PIXELS_PER_UNIT;
}

screen_left_to_world :: () -> float {
    width, _ := Window_Manager.get_render_size();
    x_scale, _ := Window_Manager.get_dpi_scale();

    return -cast(float) width / x_scale / cast(float) PIXELS_PER_UNIT;
}

#scope_file

Window_Manager :: #import "Window_Manager";

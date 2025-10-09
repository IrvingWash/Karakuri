Framebuffer_Size_Proc :: #type (
    window: *Window,
    width:  s32,
    height: s32
) #c_call;

Cursor_Position_Proc :: #type (
    window: *Window,
    x:      float64,
    y:      float64
) #c_call;

Scroll_Proc :: #type (
    window:   *Window,
    offset_x: float64,
    offset_y: float64
) #c_call;

Key_Proc :: #type (
    window:    *Window,
    key:       Key,
    scan_code: s32,
    action:    Key_Action,
    modifiers: s32
) #c_call;

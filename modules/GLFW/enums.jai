Hint_Name :: enum_flags #specified {
    CONTEXT_VERSION_MAJOR :: 0x00022002;
    CONTEXT_VERSION_MINOR :: 0x00022003;
    OPENGL_PROFILE        :: 0x00022008;
    OPENGL_FORWARD_COMPAT :: 0x00022006;
    FOCUS_ON_SHOW         :: 0x0002000C;
    RESIZABLE             :: 0x00020003;
}

Hint_Value :: enum_flags #specified {
    OPENGL_CORE_PROFILE :: 0x00032001;
    FALSE               :: 0;
    TRUE                :: 1;
}

Input_Mode_Name :: enum_flags #specified {
    CURSOR :: 0x00033001;
}

Input_Mode_Value :: enum_flags #specified {
    CURSOR_DISABLED :: 0x00034003;
}

Key :: enum #specified {
    SPACE       :: 32;
    A           :: 65;
    B           :: 66;
    C           :: 67;
    D           :: 68;
    E           :: 69;
    F           :: 70;
    G           :: 71;
    H           :: 72;
    I           :: 73;
    J           :: 74;
    K           :: 75;
    L           :: 76;
    M           :: 77;
    N           :: 78;
    O           :: 79;
    P           :: 80;
    Q           :: 81;
    R           :: 82;
    S           :: 83;
    T           :: 84;
    U           :: 85;
    V           :: 86;
    W           :: 87;
    X           :: 88;
    Y           :: 89;
    Z           :: 90;
    ESCAPE      :: 256;
    ARROW_RIGHT :: 262;
    ARRAOW_LEFT :: 263;
    ARROW_DOWN  :: 264;
    ARROW_UP    :: 265;
}

Key_Action :: enum #specified {
    RELEASE :: 0;
    PRESS   :: 1;
    REPEAT  :: 2;
}

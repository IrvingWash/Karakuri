player_animation_controller :: () -> Karakuri.Animation_Controller {
    animation_controller: Karakuri.Animation_Controller;

    for animation: PLAYER_ANIMATIONS {
        table_add(
            *animation_controller.animations,
            animation.name,
            animation,
        );
    }

    return animation_controller;
}

#scope_file

PLAYER_ANIMATIONS :: Karakuri.Animation.[
    Karakuri.Animation.{
        name         = "idle",
        texture_path = "examples/shmup/textures/player_idle.png",
        frame_count  = 1,
        frame_rate   = 1,
        looping      = true,
    },
    Karakuri.Animation.{
        name         = "strafe_forward",
        texture_path = "examples/shmup/textures/player_strafe_forward.png",
        frame_count  = 3,
        frame_rate   = 8,
        looping      = false,
    },
    Karakuri.Animation.{
        name         = "strafe_right",
        texture_path = "examples/shmup/textures/player_strafe_right.png",
        frame_count  = 6,
        frame_rate   = 16,
        looping      = false,
    },
    Karakuri.Animation.{
        name         = "strafe_left",
        texture_path = "examples/shmup/textures/player_strafe_left.png",
        frame_count  = 6,
        frame_rate   = 16,
        looping      = false,
    },
];

#import "Math";
#import "Hash_Table";

Transform :: struct {
    position: Vector2;
    scale:    Vector2 = DEFAULT_SCALE;
    rotation: float;
}

Sprite :: struct {
    texture_path:    string;
    color:           Vector4 = .{ 1, 1, 1, 1 };
    pixels_per_unit: u32 = PIXELS_PER_UNIT;
    origin:          Vector2;
    sorting_layer:   s64;
    clip:            Vector2 = .{ 1, 1 }; // @TODO P4 is this from bottom left??? We want from top left.
    offset:          Vector2;
}

Camera :: struct {
    size:  float = 1;
    color: Vector4 = .{ 0.25, 0.5, 0.95, 1 };

    front  :: Vector3.{ 0, 0, -1 };
    up     :: Vector3.{ 0, 1, 0 };
    right  :: Vector3.{ 1, 1, 0 };
}

Behavior :: struct {}

Box_Collider :: struct {
    size: Vector2 = DEFAULT_SCALE;
    offset: Vector2;
}

Animation_Controller :: struct {
    current:    *Animation;
    animations: Table(string, Animation);
}

Animation :: struct {
    name:         string;
    texture_path: string;
    frame_count:  u16;
    frame_rate:   u16;
    looping:      bool;
    current_frame: u16;
    time_playing:  float;
}

#scope_module
DEFAULT_SCALE :: Vector2.{ 1, 1 };

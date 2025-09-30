#import "Math";

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

#scope_module
DEFAULT_SCALE :: Vector2.{ 1, 1 };

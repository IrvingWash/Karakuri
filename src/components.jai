#import "Math";

Transform :: struct {
    position: Vector2;
    scale: Vector2 = .{ 1, 1 };
    rotation: float;
}

Sprite :: struct {
    // @Todo
}

Camera :: struct {
    size:  float = 1;

    front :: Vector3.{0, 0, -1};
    up :: Vector3.{0, 1, 0};
    right :: Vector3.{1, 1, 0};
}

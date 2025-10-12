#scope_module

make_entity_editor :: (entity: *Entity) {
    PushID(
        tprint("%-%", entity.token.id, entity.token.generation)
    );

    if CollapsingHeader(
        temp_c_string(
            tprint(
                "%, %-%",
                entity.name,
                entity.token.id,
                entity.token.generation,
            ),
        ),
    ) {
        make_transform_editor(*entity.transform);

        if entity_has_flags(entity, .BOX_COLLIDER) {
            make_box_collider_editor(*entity.box_collider);
        }

        if entity_has_flags(entity, .CAMERA) {
            make_camera_editor(*entity.camera);
        }

        if entity_has_flags(entity, .SPRITE) {
            make_sprite_editor(*entity.sprite);
        }

        if entity_has_flags(entity, .RIGID_BODY) {
            make_rigid_body_editor(*entity.rigid_body);
        }
    }

    PopID();
}

#scope_file;

make_transform_editor :: (transform: *Transform) {
    SeparatorText("Transform");

    position := float.[
        transform.position.x,
        transform.position.y,
    ];
    if DragFloat2("Position", *position, 0.1, flags = .NoInput) {
        transform.position.x = position[0];
        transform.position.y = position[1];
    }

    scale := float.[
        transform.scale.x,
        transform.scale.y,
    ];
    if DragFloat2("Scale", *scale, 0.1, flags = .NoInput) {
        transform.scale.x = scale[0];
        transform.scale.y = scale[1];
    }

    rotation := transform.rotation;
    if DragFloat("Rotation", *rotation, 0.1, flags = .NoInput) {
        transform.rotation = rotation;
    }
}

make_box_collider_editor :: (box_collider: *Box_Collider) {
    SeparatorText("Box Collider");

    box_collider_size := float.[
        box_collider.size.x,
        box_collider.size.y,
    ];
    if DragFloat2("Size", *box_collider_size, 0.1, flags = .NoInput) {
        box_collider.size.x = box_collider_size[0];
        box_collider.size.y = box_collider_size[1];
    }

    box_collider_offset := float.[
        box_collider.offset.x,
        box_collider.offset.y,
    ];
    if DragFloat2("Offset", *box_collider_offset, 0.1, flags = .NoInput) {
        box_collider.offset.x = box_collider_offset[0];
        box_collider.offset.y = box_collider_offset[1];
    }
}

make_camera_editor :: (camera: *Camera) {
    SeparatorText("Camera");

    size := camera.size;
    if DragFloat("Size", *size, 0.1, flags = .NoInput) {
        camera.size = size;
    }

    using camera.color;
    color := float.[x, y, z, w];
    if ColorPicker4("Color", *color, .NoOptions | .NoSmallPreview | .NoInputs) {
        camera.color = .{ color[0], color[1], color[2], color[3] };
    }
}

make_sprite_editor :: (sprite: *Sprite) {
    SeparatorText("Sprite");

    ppu: s32 = xx sprite.pixels_per_unit;
    if DragInt("Pixels Per Unit", *ppu, 1, v_min = 1, flags = .NoInput) {
        sprite.pixels_per_unit = xx ppu;
    };

    origin := float.[sprite.origin.x, sprite.origin.y];
    if DragFloat2("Origin", *origin, 0.1, flags = .NoInput) {
        sprite.origin.x = origin[0];
        sprite.origin.y = origin[1];
    };

    sorting_layer: s32 = xx sprite.sorting_layer;
    if DragInt("Sorting Layer", *sorting_layer, 0.5, flags = .NoInput) {
        sprite.sorting_layer = sorting_layer;
    }

    clip := float.[sprite.clip.x, sprite.clip.y];
    if DragFloat2("Clip", *clip, 0.1, flags = .NoInput) {
        sprite.clip.x = clip[0];
        sprite.clip.y = clip[1];
    };

    offset := float.[sprite.offset.x, sprite.offset.y];
    if DragFloat2("Offset##", *offset, 0.1, flags = .NoInput) {
        sprite.offset.x = offset[0];
        sprite.offset.y = offset[1];
    };

    using sprite.color;
    color := float.[x, y, z, w];
    if ColorPicker4("Color", *color, .NoOptions | .NoSmallPreview | .NoInputs) {
        sprite.color = .{ color[0], color[1], color[2], color[3] };
    }
}

make_rigid_body_editor :: (rigid_body: *Rigid_Body) {
    SeparatorText("Rigid Body");

    static := rigid_body.static;
    if Checkbox("Static", *static) {
        rigid_body.static = static;
    };

    velocity := float.[rigid_body.velocity.x, rigid_body.velocity.y];
    if DragFloat2("Velocity", *velocity, 0.1, flags = .NoInput) {
        rigid_body.velocity.x = velocity[0];
        rigid_body.velocity.y = velocity[1];
    }
}

#scope_module;

init_editor :: () {
    editor = .{
        ctx = CreateContext(),
        io = GetIO(),
    };

    editor.io.ConfigFlags_ |= ConfigFlags.NavEnableKeyboard;
    editor.io.IniFilename = null;

    StyleColorsLight();

    assert(ImplGlfw_InitForOpenGL(cast(*void)get_window(), true));
    assert(ImplOpenGL3_Init("#version 330 core"));
}

update_editor :: () {
    start_frame();

    Begin("Editor");

    if editor.entities.count == 0 || has_world_changed() {
        array_reset(*editor.entities);
        editor.entities = array_copy(get_world_entities());
    }

    Text("Application average % ms/frame (% FPS)", 1000 / editor.io.Framerate, editor.io.Framerate);

    visible: bool = true;
    for entity: editor.entities {
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
            {
                position := float.[
                    entity.transform.position.x,
                    entity.transform.position.y,
                ];

                if DragFloat2("Position", *position, 0.1, flags = .NoInput) {
                    entity.transform.position.x = position[0];
                    entity.transform.position.y = position[1];
                }
            }

            {
                scale := float.[
                    entity.transform.scale.x,
                    entity.transform.scale.y,
                ];

                if DragFloat2("Scale", *scale, 0.1, flags = .NoInput) {
                    entity.transform.scale.x = scale[0];
                    entity.transform.scale.y = scale[1];
                }
            }

            if entity_has_flags(entity, .BOX_COLLIDER) {
                box_collider_size := float.[
                    entity.box_collider.size.x,
                    entity.box_collider.size.y,
                ];
                if DragFloat2("Box Collider Size", *box_collider_size, 0.1, flags = .NoInput) {
                    entity.box_collider.size.x = box_collider_size[0];
                    entity.box_collider.size.y = box_collider_size[1];
                }

                box_collider_offset := float.[
                    entity.box_collider.offset.x,
                    entity.box_collider.offset.y,
                ];
                if DragFloat2("Box Collider Offset", *box_collider_offset, 0.1, flags = .NoInput) {
                    entity.box_collider.offset.x = box_collider_offset[0];
                    entity.box_collider.offset.y = box_collider_offset[1];
                }
            }

            if entity_has_flags(entity, .CAMERA) {
                {
                    size := entity.camera.size;
                    if DragFloat("Camera Size", *size, 0.1, flags = .NoInput) {
                        entity.camera.size = size;
                    }
                }

                {
                    using entity.camera.color;

                    color := float.[x, y, z, w];

                    if ColorPicker4("Camera Color", *color, .NoOptions | .NoSmallPreview | .NoInputs) {
                        entity.camera.color = .{ color[0], color[1], color[2], color[3] };
                    }
                }
            }

            if entity_has_flags(entity, .SPRITE) {
                using entity.sprite.color;

                color := float.[x, y, z, w];
                if ColorPicker4("Sprite Color", *color, .NoOptions | .NoSmallPreview | .NoInputs) {
                    entity.sprite.color = .{ color[0], color[1], color[2], color[3] };
                }
            }
        }

        PopID();
    }

    End();

    finish_frame();
}

deinit_editor :: () {
    array_reset(*editor.entities);

    ImplOpenGL3_Shutdown();
    ImplGlfw_Shutdown();
    DestroyContext();
}

#scope_file;

start_frame :: () {
    ImplOpenGL3_NewFrame();
    ImplGlfw_NewFrame();
    NewFrame();
}

finish_frame :: () {
    Render();
    ImplOpenGL3_RenderDrawData(GetDrawData());
}

Editor :: struct {
    ctx: *ImGuiContext;
    io: *IO;
    entities: []*Entity;
}

editor: Editor = ---;

#import "Dear_ImGui";
#import "Window_Manager";

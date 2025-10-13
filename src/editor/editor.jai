#scope_module;

#load "entity_editor.jai";

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

update_editor :: (camera_position: *Vector2) {
    start_frame();

    SetNextWindowPos(.{ 0, 0 });
    SetNextWindowSize(.{ 400, editor.io.DisplaySize.y });
    Begin("Entity Editor");

    Text(
        "Application average % ms/frame (% FPS)",
        1000 / editor.io.Framerate,
        editor.io.Framerate
    );

    if editor.entities.count == 0
        || has_world_changed()
        || camera_position != editor.prev_camera_position
    {
        array_reset(*editor.entities);

        for entity: get_world_entities() {
            editor_entity: Editor_Entity = .{ entity = entity };
            world_to_imgui(*editor_entity, camera_position);

            array_add(*editor.entities, editor_entity);
        }

        editor.prev_camera_position = camera_position;
    } else {
        for entity: editor.entities {
            world_to_imgui(*entity, camera_position);
        }
    }

    for entity: editor.entities {
        make_entity_editor(
            *entity,
            camera_position,
            editor.io,
            *editor.entities,
        );
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

start_frame :: () {
    ImplOpenGL3_NewFrame();
    ImplGlfw_NewFrame();
    NewFrame();
}

finish_frame :: () {
    Render();
    ImplOpenGL3_RenderDrawData(GetDrawData());
}

Editor_Entity :: struct {
    using entity: *Entity;
    top_left:     Vector2;
    bottom_right: Vector2;
    is_selected:  bool;
}

#scope_file;

Editor :: struct {
    ctx:                  *ImGuiContext;
    io:                   *IO;
    entities:             [..]Editor_Entity;
    prev_camera_position: Vector2;
}

editor: Editor = ---;

world_to_imgui :: (entity: *Editor_Entity, camera_position: Vector2) {
    halved_display_size := editor.io.DisplaySize / 2;
    halved_ppu := entity.sprite.pixels_per_unit / 2;

    x := halved_display_size.x
        + (entity.transform.position.x - camera_position.x)
        * halved_ppu;
    y := halved_display_size.y
        - (entity.transform.position.y - camera_position.y)
        * halved_ppu;

    entity.top_left = Vector2.{
        x - entity.transform.scale.x * halved_ppu / 2,
        y - entity.transform.scale. y * halved_ppu / 2,
    };

    entity.bottom_right = Vector2.{
        x + entity.transform.scale.x * halved_ppu / 2,
        y + entity.transform.scale.y * halved_ppu / 2,
    };
}

#import "Dear_ImGui";
#import "Window_Manager";

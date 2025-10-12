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

update_editor :: () {
    start_frame();

    Begin("Editor");

    Text("Application average % ms/frame (% FPS)", 1000 / editor.io.Framerate, editor.io.Framerate);

    if editor.entities.count == 0 || has_world_changed() {
        array_reset(*editor.entities);
        for entity: get_world_entities() {
            array_add(*editor.entities, .{ entity, false });
        }
    }

    for entity: editor.entities {
        make_entity_editor(*entity);
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

Editor :: struct {
    ctx: *ImGuiContext;
    io: *IO;
    entities: [..]Editor_Entity;
}

Editor_Entity :: struct {
    using entity: *Entity;
    was_hovered:  bool;
}

editor: Editor = ---;

#import "Dear_ImGui";
#import "Window_Manager";

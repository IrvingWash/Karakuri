Scene :: #type () -> []Entity_Params;

#scope_module

DEFAULT_SCENE_LOADER: Scene : () -> [..]Entity_Params {
    result: [..]Entity_Params;

    array_add(
        *result,
        {
            name = "Camera",
            flags = .CAMERA,
        }
    );

    return result;
};

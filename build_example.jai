#import "Basic";
#import "Compiler";
#import "String";
#import "File";

Config :: struct {
    should_show_help: bool;
    example: string;
    optimization_type: Optimization_Type = .DEBUG;
}

BUILD_PATH_BASE :: "build";
ENTRY_POINT_PATH_BASE :: "examples";
MAIN_FILE_PATH :: "src/main.jai";

HELP_TEXT :: #string DONE
Karakuri examples builder

Usage: jai ./build_example.jai - <EXAMPLE_NAME>

Options:
  -h, --help        Print help
  -o, --optimized   Build in VERY_OPTIMIZED mode
  -d, --debug       Build in DEBUG mode
DONE

#run {
    set_build_options_dc(.{
        do_output = false,
        write_added_strings = false,
    });

    build_options_dc := get_build_options();

    args := build_options_dc.compile_time_command_line;
    if args.count == 0 {
        terminate("No arguments provided\n");
    }

    config := make_config_from_args(args);

    if config.should_show_help {
        show_help();

        return;
    }

    if config.example == "" {
        terminate("No example provided\n");
    }

    build(config.example, config.optimization_type, build_options_dc);

    reset_temporary_storage();
}

make_config_from_args :: (args: []string) -> Config {
    config: Config;

    if !begins_with(args[0], "-") {
        config.example = args[0];
    }

    for arg: args {
        if arg == {
            case "--help"; #through;
            case "-h";
                config.should_show_help = true;
            case "--optimized"; #through;
            case "-o";
                config.optimization_type = .VERY_OPTIMIZED;
            case "--debug"; #through;
            case "-d";
                config.optimization_type = .DEBUG;
        }
    }

    return config;
}

show_help :: () {
    print(HELP_TEXT);
}

build :: (
    example_name: string,
    optimization_type: Optimization_Type,
    build_options_dc: Build_Options
) {
    workspace := compiler_create_workspace(example_name);

    print("Building example '%' in % mode\n", example_name, optimization_type);

    build_dir_path := tprint(
        "%/%/%",
        BUILD_PATH_BASE,
        example_name,
        optimization_type,
    );

    build_options := get_build_options(workspace);

    copy_commonly_propagated_fields(build_options_dc, *build_options);
    {
        using build_options;

        output_type = .EXECUTABLE;
        output_executable_name = example_name;
        output_path, intermediate_path = build_dir_path;
        import_path = make_import_paths(import_path);
    }
    set_optimization(*build_options, optimization_type);

    set_build_options(build_options, workspace);

    make_directory_if_it_does_not_exist(build_dir_path, recursive = true);

    add_build_file(
        tprint(
            "%/%/%",
            ENTRY_POINT_PATH_BASE,
            example_name,
            MAIN_FILE_PATH,
        ),
        workspace,
    );
}

terminate :: (format_string: string, args: .. Any) {
    print(format_string, ..args, to_standard_error = true);
    exit(1);
}

make_import_paths :: (import_paths: []string) -> []string {
    result: [..]string;
    result.allocator = temp;

    for path: import_paths {
        array_add(*result, path);
    }

    array_add(*result, "..");

    return result;
}

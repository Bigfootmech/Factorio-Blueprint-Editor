lua_extension = ".lua"
control_class_name = "control"
data_class_name = "data"
keybinds_class_name = "prototypes.keybinds"

def write_to_file(filename, contents):
    f = open(filename, 'w')
    f.write(contents)
    f.close()

def lua_import_simple(long_class_name):
    return "require('" + long_class_name + "')"

def lua_import_assigned(class_name, from_name):
    return "local " + class_name + " = " + lua_import_simple(class_name, from_name)
    
def lua_add_prototype():
    return "data:extend(" + Keybinds.get_registered_key_sequences() + ")"
    
def generate_control(main_class):
    filename = generated_folder + control_class_name + lua_extension
    contents = lua_import_simple(main_class)
    write_to_file(filename, contents)
    
def generate_data(main_class):
    filename = generated_folder + data_class_name + lua_extension
    contents = lua_import_simple(keybinds_class_name)
    write_to_file(filename, contents)

    
generate_control()
generate_data()
#generate_prototypes()
#generate_info()
#generate_locale()
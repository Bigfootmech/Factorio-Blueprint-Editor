from distutils.dir_util import mkpath

prototypes_dirname = "prototypes"
locales_dirname = "locale/en"


control_class_name = "control"
data_class_name = "data"
keybinds_prototype_class_name = "keybinds"
keybinds_locale_filename = "controls.cfg"
keybinds_prototype_class_path = prototypes_dirname + "." + keybinds_prototype_class_name

lua_extension = ".lua"

keybinds_keystrokes_method = "get_registered_key_sequences"
keybinds_locale_method = "get_locale_text"

def write_to_file(filename, contents):
    f = open(filename, 'w')
    f.write(contents)
    f.close()

def lua_import_simple(long_class_name):
    return "require('" + long_class_name + "')"

def lua_import_assigned(class_name, from_name):
    return "local " + class_name + " = " + lua_import_simple(from_name + "." + class_name)
    
def lua_add_prototype(prototype):
    return "data:extend(" + prototype + ")"
    
def keybinds_to_prototype(keybinds_class_name):
    return keybinds_class_name + "." + keybinds_keystrokes_method + "()"
    
def generate_control(generated_folder, main_class):
    filename = generated_folder + control_class_name + lua_extension
    contents = lua_import_simple(main_class)
    write_to_file(filename, contents)
    
def generate_data(generated_folder):
    filename = generated_folder + data_class_name + lua_extension
    contents = lua_import_simple(keybinds_prototype_class_path)
    write_to_file(filename, contents)
    
def generate_keybinds_prototype(prototypes_dir, keybinds_class_name, keybinds_class_location):
    filename = prototypes_dir + keybinds_prototype_class_name + lua_extension
    contents = ""
    contents = contents + lua_import_assigned(keybinds_class_name, keybinds_class_location) + "\n\n"
    contents = contents + lua_add_prototype(keybinds_to_prototype(keybinds_class_name))
    write_to_file(filename, contents)
    
def generate_locale(locale_dir, keybinds_class_name, keybinds_class_location):
    filename = locale_dir + keybinds_locale_filename
    contents = "[controls]\n"
    write_to_file(filename, contents)

def generate_basic(generated_folder, main_class):
    mkpath(generated_folder)
    generate_control(generated_folder, main_class)
    generate_data(generated_folder)
    
def generate_keybinds(generated_folder, keybinds_class_name, keybinds_class_location):
    prototypes_dir = generated_folder + prototypes_dirname + "/"
    mkpath(prototypes_dir)
    generate_keybinds_prototype(prototypes_dir, keybinds_class_name, keybinds_class_location)
    locale_dir = generated_folder + locales_dirname + "/"
    mkpath(locale_dir)
    generate_locale(locale_dir, keybinds_class_name, keybinds_class_location)
    
def generate_info(generated_folder, main_class):
    generate_info()

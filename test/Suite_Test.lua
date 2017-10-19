local function include_tests_for(classname)
    print("Running tests for " .. classname)
    require('test.' .. classname .. '_Test')
end

include_tests_for('lib.blueprint.Blueprint_Entity')
include_tests_for('lib.events.Event')
include_tests_for('lib.events.Direction_Keys')
include_tests_for('lib.lua_enhance.Array')
include_tests_for('lib.lua_enhance.Math')
include_tests_for('lib.lua_enhance.Table')
include_tests_for('lib.spatial.Direction')
include_tests_for('lib.spatial.Vector')
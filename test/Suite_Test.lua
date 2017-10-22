local total_errors = 0

local function is_test_name(var_name)
    if(type(var_name) ~= "string") then
        return false
    end
    return string.lower(string.sub(var_name, 1, 4)) == "test"
end

local function clear_global_space()
    for var_name,v in pairs(_G) do
        if(is_test_name(var_name)) then
            -- print("Test set ran: " .. tostring(var_name)) -- verbose?
            _G[var_name] = nil
        end
    end
end

local function include_tests_for(classname)
    print("Running tests for " .. classname)
    local result_errors = require('test.' .. classname .. '_Test')
    total_errors = total_errors + result_errors
    clear_global_space()
end

include_tests_for('lib.logic.model.blueprint.Blueprint_Entity') -- need better includes :/
include_tests_for('lib.frontend.events.Direction_Keys')
include_tests_for('lib.core.types.Array')
include_tests_for('lib.core.Math')
include_tests_for('lib.core.types.Table')
include_tests_for('lib.logic.model.spatial.Direction')
include_tests_for('lib.logic.model.spatial.Vector')

os.exit( total_errors )
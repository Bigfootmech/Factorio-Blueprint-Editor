local total_errors = 0

local function include_tests_for(classname)
    print("Running tests for " .. classname)
    local result_errors = require(classname)
    total_errors = total_errors + result_errors
end

include_tests_for('bpedit.edit_or_reopen_blueprint_spec')

os.exit( total_errors )
require('steps.steps')
local lu = require('luaunit')

TestEditOrReopenBlueprint = {}
    function TestEditOrReopenBlueprint:setUp()
        Before()
    end

    function TestEditOrReopenBlueprint:testShowsErrorIfNothingEditingOrEditable()
        -- given
        Mod_already_exists_in_save()
        Player_is_editing_nothing()
        Player_hand_contains_nothing()
        Player_mouseover_selection_contains_nothing()
        
        -- when
        Player_presses("N")
        
        -- then
        Player_is_now_editing()
    end

    function TestEditOrReopenBlueprint:testEditBlueprintFromHand()
        -- given
        Mod_already_exists_in_save()
        Player_is_editing_nothing()
        Player_hand_contains(lua_blueprint)
        Player_mouseover_selection_contains_nothing()
        
        -- when
        Player_presses("N")
        
        -- then
        Player_is_now_editing()
    end
    
return lu.LuaUnit.run()
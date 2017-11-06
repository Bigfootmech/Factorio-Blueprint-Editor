require('util.steps')
local lu = require('luaunit')

TestEditOrReopenBlueprint = {}
    function TestEditOrReopenBlueprint:setUp()
        Before()
    end

    function TestEditOrReopenBlueprint:testShowsErrorIfNothingEditingOrEditable()
        -- given
        Mod_already_exists_in_save()
        Player_is_editing(nil)
        Player_hand_contains(nil)
        Player_mouseover_selection_contains(nil)
        
        -- when
        Player_presses("N")
        
        -- then
        Player_receives_text("Error")
    end

    function TestEditOrReopenBlueprint:testEditBlueprintFromHand()
        -- given
        Mod_already_exists_in_save()
        Player_is_editing(nil)
        Player_hand_contains(a_blueprint)
        Player_mouseover_selection_contains(nil)
        
        -- when
        Player_presses("N")
        
        -- then
        Player_is_now_editing(a_blueprint)
    end
    
return lu.LuaUnit.run()
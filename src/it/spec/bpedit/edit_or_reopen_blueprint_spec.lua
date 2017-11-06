require('faketorio_busted')
local lu = require('luaunit')

EditOrReopenBlueprintTest = {}

    function EditOrReopenBlueprintTest:showsErrorIfNothingEditingOrEditable()
        Given("Player is editing " .. "nothing")
        And("Player hand contains " .. "nothing")
        And("Player mouseover selection contains " .. "nothing") 
        
        When("Player presses" .. "N") 
        
        Then("Player receives text " .. "Error")
    end

    function EditOrReopenBlueprintTest:editBlueprintFromHand()
        Given("Player is editing " .. "nothing")
        And("Player mouseover selection contains " .. "nothing") 
        And("Player hand contains " .. "a blueprint")
        
        When("Player presses" .. "N") 
        
        Then("Player is now editing " .. "a blueprint")
    end
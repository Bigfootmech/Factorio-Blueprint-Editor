require("faketorio_busted")
    
Before(function()
    faketorio.initialize_world_busted()
end)

Given("Player is (not)? editing a blueprint", function (boolean)
    print(tostring(boolean))
    Pending(boolean)
end)

Given("Player has (nothing|a blueprint) in his hand", function (player_hand_description)
    Pending("It's not ready yet")
end)

Given("Player has nothing in mouseover selection", function ()
    Pending("It's not ready yet")
end)

When("Player presses (.+)$", function (command_string)
    Pending("It's not ready yet")
end)

Then("Error is returned to player", function ()
    Pending("It's not ready yet")
end)

Then("Player is now editing a blueprint", function ()
    Pending("It's not ready yet")
end)

--Pending("It's not ready yet")

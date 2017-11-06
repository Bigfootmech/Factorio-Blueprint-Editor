require("faketorio_busted")
local Data = require("util.Data")
local Event = require("util.Event")
    
function Before()
    faketorio.initialize_world_busted()
    data = Data.new()
    require("data")
end

function  Mod_already_exists_in_save()
    script.on_init = function() end
    require("control")
end

function Player_is_editing(editing_contents)
    print("not set yet")
end

function Player_hand_contains(hand_contents)
    print("not set yet")
end

function Player_mouseover_selection_contains(mouseover_selection)
    print("not set yet")
end

function Player_presses(key_set)
    Event.keypress(1,key_set)
end

function Player_receives_text(text)
    print("not set yet")
end

function Player_is_now_editing(new_editing_contents)
    print("not set yet")
end

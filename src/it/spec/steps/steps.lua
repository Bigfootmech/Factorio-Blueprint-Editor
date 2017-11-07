local Fakewrapper = require("fakewrapper.fakewrapper")
local Event = require("fakewrapper.Event")
    
function Before()
    Fakewrapper.initialize()
end

function  Mod_already_exists_in_save()
    script.on_init = function() end
    require("control")
end

function Player_is_editing(editing_contents)
    print("not set yet")
end

function Player_hand_contains(hand_contents)
    game.players[1].cursor_stack = hand_contents -- hand is always LuaStack (.__self = userdata)
end

function Player_mouseover_selection_contains(mouseover_selection)
    game.players[1].selected = mouseover_selection -- can actually be "nil"
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

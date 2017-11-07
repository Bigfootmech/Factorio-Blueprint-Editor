local Fakewrapper = require("fakewrapper.fakewrapper")
local Player_Helper = require("fakewrapper.Player_Helper")
local lu = require('luaunit')
    
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

function Player_mouseover_selection_contains_nothing()
    Player_Helper.clear_selection(1)
end

function Player_presses(key_set)
    Player_Helper.presses_key(1,key_set)
end

function Player_receives_text(text)
    lu.assertEquals(Player_Helper.retrieve_msg(1),text)
end

function Player_is_now_editing(new_editing_contents)
    print("not set yet")
end

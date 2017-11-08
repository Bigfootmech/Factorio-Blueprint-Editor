local Fakewrapper = require("fakewrapper.fakewrapper")
local Player_Helper = require("fakewrapper.Player_Helper")
local lu = require('luaunit')
local Global_Dao = require('bpedit.backend.storage.Global_Dao')
local Player_Store_Dao = require('bpedit.backend.storage.Player_Store_Dao')
local Blueprint = require('lib.logic.model.blueprint.Blueprint')

local function clear_subtrees(subtree_name)
    for k,v in pairs(package.loaded)do
        if(string.find(k,subtree_name) == 1)then
            package.loaded[k] = nil 
        end
    end

end

local function clear_modules()
    package.loaded["control"] = nil 
    package.loaded["data"] = nil 
    clear_subtrees("lib")
    clear_subtrees("bpedit")
    clear_subtrees("prototypes")
    --[[ print("modules still loaded") -- log debug?
    for k,v in pairs(package.loaded)do
        print(k)
    end
    ]]
end
    
function  Mod_already_exists_in_save()
    script.on_init = function() end
    require("control") -- from mod
end
    
function Before()
    clear_modules()
    Fakewrapper.initialize()
    a_blueprint = Blueprint.from_table({blueprint_entities={}, blueprint_tiles={}, label="", blueprint_icons={}})
end

function Player_is_editing_nothing()
    Global_Dao.get_player_store(1):clear_editing()
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
    local player_message = Player_Helper.retrieve_msg(1)
    lu.assertEquals(type(player_message),"string")
    lu.assertTrue(string.find(player_message, text))
end

function Player_is_now_editing(new_editing_contents)
    local player_dao = Global_Dao.get_player_store(1)
    lu.assertTrue(player_dao:is_editing())
end

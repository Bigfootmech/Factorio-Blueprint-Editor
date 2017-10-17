local lu = require('luaunit')
local Event = require('lib.events.Event')
    
local function helper_add_fake_player_index(player_index)
    game.players[player_index] = "fake data"
end

TestEvent = {}
    function TestEvent:setUp()
        game = {players = {}}
    end
    
    function TestEvent:testWraps()
        -- given
        local some_table = {player_index = 1}
        
        -- when 
        local result = Event.new(some_table)
        
        -- then
        lu.assertTrue(result)
    end
    
    function TestEvent:testGetPlayerWorks()
        -- given
        local some_index = 509
        helper_add_fake_player_index(some_index)
        local some_table = {player_index = some_index}
        local event = Event.new(some_table)
        
        -- when 
        local result = event:get_player()
        
        -- then
        lu.assertTrue(result)
    end
    
    function TestEvent:testWorksAsStatic()
        -- given
        local some_index = 333
        helper_add_fake_player_index(some_index)
        local some_table = {player_index = some_index}
        local event = Event.new(some_table)
        
        -- when 
        local result = Event.get_player(event)
        
        -- then
        lu.assertTrue(result)
    end
    
lu.LuaUnit.run()
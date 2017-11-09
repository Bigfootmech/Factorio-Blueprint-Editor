local Game_Helper = {}

local function write_file(filename, data, append, for_player)
    if(append == nil)then
        return write_file(filename, data, false)
    end
    if(for_player == nil)then
        return write_file(filename, data, append, 0)
    end
    
    -- io?
end

function Game_Helper.wrap(game)
    game.write_file = write_file
end

return Game_Helper
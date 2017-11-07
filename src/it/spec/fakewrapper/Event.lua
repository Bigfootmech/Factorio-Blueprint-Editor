local Data_Helper = require("fakewrapper.Data_Helper")

local Event = {}

function Event.keypress(player_id, keysequence)
    local element = Data_Helper.get_data_for_keysequence(keysequence)
    if(element == nil)then
        return false
    end
    local event_name = element["name"]
    
    local constructed_event = {}
    
    constructed_event["input_name"] = event_name
    constructed_event["player_index"] = player_id
    
    script.raise_event(event_name, constructed_event)
end

return Event
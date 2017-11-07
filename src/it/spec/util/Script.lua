local global_hidden_event_store = {}

function script.on_event(registering_events, function_to_trigger)
    if(type(registering_events) ~= "table")then
        script.on_event({registering_events}, function_to_trigger)
    end
    global_hidden_event_store[function_to_trigger] = registering_events
end

function script.raise_event(hopefully_registered_event, event_happening)
    for function_to_trigger, registered_events_array in pairs(global_hidden_event_store)do
    print("> " .. tostring(registered_events_array))
        for _, registered_event in ipairs(registered_events_array)do
            if(registered_event == hopefully_registered_event)then
                return function_to_trigger(event_happening)
            end
        end
    end
end
function write_config_file(filename, values_table)
    local f = io.open (filename, "w")
    f:write("[controls]")
    for k,v in pairs(values_table)do
        f:write ("\n" .. tostring(k) .. "=" .. tostring(v))
    end
    f:close ()
end
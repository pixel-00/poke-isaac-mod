function mod:RandomPositive()
    local x = Random()
    if x == 0 then
        return 1
    else
        return x
    end
end
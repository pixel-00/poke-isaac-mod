function mod:RandomPositive()
    local x = Random()
    if x == 0 then
        return 1
    else
        return x
    end
end

function mod:ToTearsPerSecond(maxFireDelay)
	return 30 / (maxFireDelay + 1)
end

function mod:ToMaxFireDelay(tearsPerSecond)
	return (30 / tearsPerSecond) - 1
end
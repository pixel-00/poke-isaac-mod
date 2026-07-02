local leftovers = Isaac.GetItemIdByName("Life Orb")

function mod:ApplyLeftovers()
    local player = Isaac.GetPlayer(0)
    local x = math.random()
    if player:HasCollectible(leftovers) then
        if x < 0.85 then
            player:AddHearts(1)
        else
            player:AddSoulHearts(1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.ApplyLeftovers)
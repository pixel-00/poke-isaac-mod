local leftovers = Isaac.GetItemIdByName("Leftovers")

function mod:ApplyLeftovers(rng, spawnPosition)
    local function f(player)
        local x = rng:RandomFloat()
        if player:HasCollectible(leftovers) then
            if x < 0.85 then
                player:AddHearts(1)
            else
                player:AddSoulHearts(1)
            end
        end
    end

    mod:DoForAllPlayers(f)
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.ApplyLeftovers)
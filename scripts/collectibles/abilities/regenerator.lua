local regenerator = Isaac.GetItemIdByName("Regenerator")

function mod:Regenerate()
    local function f(player)
        if player:HasCollectible(regenerator) then
            player:AddHearts(player:GetMaxHearts())
        end
    end

    mod:DoForAllPlayers(f)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.Regenerate)
local regenerator = Isaac.GetItemIdByName("Regenerator")

function mod:Regenerate()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(regenerator) then
        player:AddHearts(player:GetMaxHearts())
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.Regenerate)
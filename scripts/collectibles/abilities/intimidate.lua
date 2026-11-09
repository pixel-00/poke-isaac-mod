local intimidate = Isaac.GetItemIdByName("Intimidate")

function mod:ApplyFear()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(intimidate) then
        for _, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsActiveEnemy() then
                entity:AddFear(EntityRef(player), 75)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ApplyFear)
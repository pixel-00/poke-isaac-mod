local intimidate = Isaac.GetItemIdByName("Intimidate")

function mod:ApplyFear()
    local function f(player)
        if player:HasCollectible(intimidate) then
            for _, entity in pairs(Isaac.GetRoomEntities()) do
                if entity:IsActiveEnemy() then
                    entity:AddFear(EntityRef(player), 75)
                end
            end
        end
    end

    mod:DoForAllPlayers(f)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ApplyFear)
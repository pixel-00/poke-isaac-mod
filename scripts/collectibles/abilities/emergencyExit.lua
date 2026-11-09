local emergencyExit = Isaac.GetItemIdByName("Emergency Exit")

function mod:EmergencyExit(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(emergencyExit) then
        local player = entity:ToPlayer()
        local health = player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts() + player:GetRottenHearts() + player:GetEternalHearts()
        if health - amount <= 2 then
            player:UseCard(Card.CARD_FOOL, UseFlag.USE_NOANNOUNCER)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.EmergencyExit)
local focusSash = Isaac.GetTrinketIdByName("Focus Sash")

function mod:FocusSash(entity, amount, damageFlags, source, countdownFrames)
    local player = entity:ToPlayer()
    if player then
        local health = player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts() + player:GetRottenHearts() + player:GetEternalHearts()
        print("player hit, amount = " .. amount .. " health = " .. health)
        if player:HasTrinket(focusSash) and health <= amount then
            local trinketMultiplier = player:GetTrinketMultiplier(focusSash)
            player:TryRemoveTrinket(focusSash)
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, true, 1)
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_CAMO_UNDIES, true, trinketMultiplier - 1)
            return false
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.FocusSash)
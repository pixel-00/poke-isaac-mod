local sturdy = Isaac.GetItemIdByName("Sturdy")

function mod:PreventDeath(entity, amount, damageFlags, source, countdownFrames)
    local player = entity:ToPlayer()
    if player then
        local health = player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts() + player:GetRottenHearts() + player:GetEternalHearts()
        if player:HasCollectible(sturdy) and (health <= amount) and not player:GetData().SturdyAbilityActivated then
            player:GetData().SturdyAbilityActivated = true
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, true, 1)
            return false
        end
    end
end

function mod:ResetSturdy()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(sturdy) then
        player:GetData().SturdyAbilityActivated = false
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.PreventDeath)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetSturdy)
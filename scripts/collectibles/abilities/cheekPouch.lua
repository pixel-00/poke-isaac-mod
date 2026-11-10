include("scripts.utilities")

local cheekPouch = Isaac.GetItemIdByName("Cheek Pouch")

function mod:ExtraHealing(pillEffect, player, useFlags)
    if player:HasCollectible(cheekPouch) then
        Game():SpawnParticles(player.Position - Vector(0, 32), EffectVariant.HEART, 1, 1)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_PHD) then
            player:AddHearts(2)
        elseif player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) then
            player:AddRottenHearts(2)
        else
            player:AddHearts(1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.ExtraHealing)
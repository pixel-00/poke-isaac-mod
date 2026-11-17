local stamina = Isaac.GetItemIdByName("Stamina")

function mod:ApplyMantle(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(stamina) then
        local rng = entity:ToPlayer():GetCollectibleRNG(stamina)

        if rng:RandomFloat() < 0.5 + 0.02 * entity:ToPlayer().Luck then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ApplyMantle)
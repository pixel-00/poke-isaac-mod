local stamina = Isaac.GetItemIdByName("Stamina")

function mod:ApplyMantle(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(stamina) then
        if math.random() < math.min(1, 0.5 + 0.02 * entity:ToPlayer().Luck) then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ApplyMantle)
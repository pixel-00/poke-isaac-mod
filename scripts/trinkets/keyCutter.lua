local keyCutter = Isaac.GetTrinketIdByName("Key Cutter")

function mod:KeyCutter(pickup, collider, low)
    local player = collider:ToPlayer()

    if player and pickup.Variant == PickupVariant.PICKUP_KEY and player:HasTrinket(keyCutter) then
        local rng = player:GetTrinketRNG(keyCutter)
        local x = rng:RandomFloat()
        local trinketMultiplier = player:GetTrinketMultiplier(keyCutter)

        if x < trinketMultiplier / 3 then
            local spawnPosition = Game():GetLevel():GetCurrentRoom():FindFreePickupSpawnPosition(pickup.Position)

            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, spawnPosition, Vector(0,0), pickup, Card.CARD_CRACKED_KEY, mod:RandomPositive())
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.KeyCutter)
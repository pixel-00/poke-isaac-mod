local keyCrusher = Isaac.GetTrinketIdByName("Key Crusher")

function mod:KeyCrusher(pickup, collider, low)
    local player = collider:ToPlayer()
    if player and pickup.Variant == PickupVariant.PICKUP_KEY then
        print("picking up key")
        local x = math.random()
        local trinketMultiplier = player:GetTrinketMultiplier(keyCrusher)
        if x < trinketMultiplier / 3 then
            print("attempting cracked key spawn")
            local spawnPosition = Game():GetLevel():GetCurrentRoom():FindFreePickupSpawnPosition(pickup.Position)
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, spawnPosition, Vector(0,0), pickup, Card.CARD_CRACKED_KEY, mod:RandomPositive())
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.KeyCrusher)
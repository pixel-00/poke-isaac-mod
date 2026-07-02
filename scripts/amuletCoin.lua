function mod:RandomNonzero()
    local n = Random()
    if n == 0 then
        return 1
    else
        return n
    end
end

function mod:PreSpawnCleanAward()
    local player = Isaac.GetPlayer(0)
    local amuletCoin = Isaac.GetItemIdByName("Amulet Coin")
    local roomType = Game():GetRoom():GetType()
    if roomType == RoomType.ROOM_BOSS and player:HasCollectible(amuletCoin) then
        local coinAmount = math.random(0, 4)
        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Game():GetRoom():GetCenterPos(), RandomVector():Resized(math.random(8)), nil, CoinSubType.COIN_LUCKYPENNY, Game():GetRoom():GetSpawnSeed())
        while coinAmount > 0 do
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Game():GetRoom():GetCenterPos(), RandomVector():Resized(math.random(8)), nil, 0, mod:RandomNonzero())
            coinAmount = coinAmount - 1
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.PreSpawnCleanAward)
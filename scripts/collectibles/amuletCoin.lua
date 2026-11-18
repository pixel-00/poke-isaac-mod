local amuletCoin = Isaac.GetItemIdByName("Amulet Coin")

function mod:PreSpawnCleanAward(rng, spawnPosition)
    local roomType = Game():GetRoom():GetType()

    local function f(player)
        if roomType == RoomType.ROOM_BOSS and player:HasCollectible(amuletCoin) then
            local coinAmount = rng:RandomInt(5)

            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Game():GetRoom():GetCenterPos(), RandomVector():Resized(math.random(8)), nil, CoinSubType.COIN_LUCKYPENNY, Game():GetRoom():GetSpawnSeed())

            while coinAmount > 0 do
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Game():GetRoom():GetCenterPos(), RandomVector():Resized(math.random(8)), nil, 0, mod:RandomPositive())
                coinAmount = coinAmount - 1
            end
        end
    end

    mod:DoForAllPlayers(f)
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.PreSpawnCleanAward)
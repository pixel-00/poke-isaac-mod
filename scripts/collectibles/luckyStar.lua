local luckyStar = Isaac.GetItemIdByName("Lucky Star")

local canRoll = true

function mod:LuckyPennySpawn(type, variant, subtype, position, velocity, spawner, seed)
    local function f(player)
        if player:HasCollectible(luckyStar) and type == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_COIN then
            local rng = player:GetCollectibleRNG(luckyStar)
            local x = rng:RandomFloat()
            local chance = player.Luck / 50
            if x < chance then
                if subtype == CoinSubType.COIN_PENNY then
                    return {type, variant, CoinSubType.COIN_LUCKYPENNY, seed}
                elseif subtype == CoinSubType.COIN_DOUBLEPACK then
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Game():GetRoom():FindFreePickupSpawnPosition(position), velocity:Rotated(360 * rng:RandomFloat()), nil, CoinSubType.COIN_LUCKYPENNY, seed)
                    return {type, variant, CoinSubType.COIN_LUCKYPENNY, seed}
                elseif CoinSubType.COIN_STICKYNICKEL and x < chance / 2 then
                    return {type, variant, CoinSubType.COIN_LUCKYPENNY, seed}
                end
            end
        end
    end

    mod:DoForAllPlayers(f)
end

function mod:GiveInitialLuckyPenny(player)
    local queued = player.QueuedItem
    local data = player:GetData()
    if queued.Item and queued.Item:IsCollectible() and queued.Item.ID == luckyStar and not queued.Touched then
        data.NUM_LUCKY_STAR = player:GetCollectibleNum(luckyStar)
    end
    if data.NUM_LUCKY_STAR and data.NUM_LUCKY_STAR < player:GetCollectibleNum(luckyStar) then
        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, Game():GetRoom():FindFreePickupSpawnPosition(player.Position), Vector(0, 0), nil, CoinSubType.COIN_LUCKYPENNY, player:GetCollectibleRNG(luckyStar):GetSeed())
        data.NUM_LUCKY_STAR = nil
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, mod.LuckyPennySpawn)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.GiveInitialLuckyPenny)
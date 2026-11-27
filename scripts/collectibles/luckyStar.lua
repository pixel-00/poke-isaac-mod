local luckyStar = Isaac.GetItemIdByName("Lucky Star")

function mod:LuckyUpgrade(type, variant, subtype, position, velocity, spawner, seed)
    local replace = false
    local spawnExtra = false
    local isCoin = (variant == PickupVariant.PICKUP_COIN)
    local isKey = (variant == PickupVariant.PICKUP_KEY)
    local isBomb = (variant == PickupVariant.PICKUP_BOMB)

    local function f(player)
        if player:HasCollectible(luckyStar) and type == EntityType.ENTITY_PICKUP and (isCoin or isKey or isBomb) then
            local rng = player:GetCollectibleRNG(luckyStar)
            local x = rng:RandomFloat()
            local chance = math.min(player.Luck / 50, 1)

            if isKey or isBomb then
                chance = math.min(chance, 0.5)
            end

            if x < chance then
                if isCoin then
                    if subtype == CoinSubType.COIN_PENNY then
                        replace = true
                    elseif subtype == CoinSubType.COIN_DOUBLEPACK then
                        spawnExtra = true
                        replace = true
                    elseif subtype == CoinSubType.COIN_STICKYNICKEL and x < chance / 2 then
                        replace = true
                    end
                elseif isKey then
                    if subtype == KeySubType.KEY_NORMAL then
                        replace = true
                    elseif subtype == KeySubType.KEY_DOUBLEPACK then
                        replace = true
                        spawnExtra = true
                    end
                elseif isBomb then
                    if subtype == BombSubType.BOMB_NORMAL or subtype == BombSubType.BOMB_TROLL or subtype == BombSubType.BOMB_SUPERTROLL then
                        replace = true
                    elseif subtype == BombSubType.BOMB_DOUBLEPACK then
                        replace = true
                        spawnExtra = true
                    end
                end
            end
        end
    end

    mod:DoForAllPlayers(f)

    if replace then
        local newSubType = subtype
        local extraSubType = subtype

        if isCoin then
            newSubType = CoinSubType.COIN_LUCKYPENNY
            extraSubType = CoinSubType.COIN_LUCKYPENNY
        elseif isKey then
            newSubType = KeySubType.KEY_GOLDEN
        elseif isBomb then
            newSubType = BombSubType.BOMB_GOLDEN
        end

        if spawnExtra then
            Game():Spawn(EntityType.ENTITY_PICKUP, variant, Game():GetRoom():FindFreePickupSpawnPosition(position), velocity:Rotated(360 * rng:RandomFloat()), nil, extraSubType, seed)
        end

        return {type, variant, newSubType, seed}
    end
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

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, mod.LuckyUpgrade)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.GiveInitialLuckyPenny)
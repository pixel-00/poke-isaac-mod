local luckyStar = Isaac.GetItemIdByName("Lucky Star")

function mod:LuckyUpgrade(pickup)
    local replace = false
    local spawnExtra = false
    local isCoin = (pickup.Variant == PickupVariant.PICKUP_COIN)
    local isKey = (pickup.Variant == PickupVariant.PICKUP_KEY)
    local isBomb = (pickup.Variant == PickupVariant.PICKUP_BOMB)

    local function f(player)
        if player:HasCollectible(luckyStar) and (isCoin or isKey or isBomb) then
            local rng = player:GetCollectibleRNG(luckyStar)
            local x = rng:RandomFloat()
            local chance = math.min(player.Luck / 50, 1)

            if isKey or isBomb then
                chance = math.min(chance, 0.5)
            end

            if x < chance then
                if isCoin then
                    if pickup.SubType == CoinSubType.COIN_PENNY then
                        replace = true
                    elseif pickup.SubType == CoinSubType.COIN_DOUBLEPACK then
                        spawnExtra = true
                        replace = true
                    elseif pickup.SubType == CoinSubType.COIN_STICKYNICKEL and x < chance / 2 then
                        replace = true
                    end
                elseif isKey then
                    if pickup.SubType == KeySubType.KEY_NORMAL then
                        replace = true
                    elseif pickup.SubType == KeySubType.KEY_DOUBLEPACK then
                        replace = true
                        spawnExtra = true
                    end
                elseif isBomb then
                    if pickup.SubType == BombSubType.BOMB_NORMAL or pickup.SubType == BombSubType.BOMB_TROLL or pickup.SubType == BombSubType.BOMB_SUPERTROLL then
                        replace = true
                    elseif pickup.SubType == BombSubType.BOMB_DOUBLEPACK then
                        replace = true
                        spawnExtra = true
                    end
                end
            end
        end
    end

    mod:DoForAllPlayers(f)

    if replace then
        local extraSubType = pickup.SubType

        if isCoin then
            pickup.SubType = CoinSubType.COIN_LUCKYPENNY
            extraSubType = CoinSubType.COIN_LUCKYPENNY
        elseif isKey then
            pickup.SubType = KeySubType.KEY_GOLDEN
        elseif isBomb then
            pickup.SubType = BombSubType.BOMB_GOLDEN
        end

        if spawnExtra then
            Game():Spawn(EntityType.ENTITY_PICKUP, pickup.Variant, Game():GetRoom():FindFreePickupSpawnPosition(pickup.Position), pickup.Velocity:Rotated(360 * rng:RandomFloat()), nil, extraSubType, Game():GetRoom():GetSpawnSeed())
        end
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

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.LuckyUpgrade)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.GiveInitialLuckyPenny)
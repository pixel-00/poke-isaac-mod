include("scripts.utilities")
local pickup = Isaac.GetItemIdByName("Pickup")

local function IsEarlyStage(stage)
    return stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 or stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 or stage == LevelStage.STAGE3_1 or LevelStage.STAGE3_2
end

local function GetPickupVariant()
    local stage = Game():GetLevel():GetStage()
    local x = math.random()
    if IsEarlyStage(stage) then
        if x < 0.26 then
            return PickupVariant.PICKUP_HEART
        elseif x < 0.32 then
            return PickupVariant.PICKUP_COIN
        elseif x < 0.45 then
            return PickupVariant.PICKUP_KEY
        elseif x < 0.58 then
            return PickupVariant.PICKUP_BOMB
        elseif x < 0.66 then
            return PickupVariant.PICKUP_PILL
        elseif x < 0.72 then
            return PickupVariant.PICKUP_TAROTCARD
        elseif x < 0.77 then
            return PickupVariant.PICKUP_LIL_BATTERY
        elseif x < 0.84 then
            return PickupVariant.PICKUP_GRAB_BAG
        elseif x < 0.91 then
            return PickupVariant.PICKUP_CHEST
        elseif x < 0.96 then
            return PickupVariant.PICKUP_LOCKEDCHEST
        elseif x < 0.98 then
            return PickupVariant.PICKUP_REDCHEST
        elseif x < 0.99 then
            return PickupVariant.PICKUP_OLDCHEST
        else
            return PickupVariant.PICKUP_COLLECTIBLE
        end
    else
        if x < 0.24 then
            return PickupVariant.PICKUP_HEART
        elseif x < 0.34 then
            return PickupVariant.PICKUP_COIN
        elseif x < 0.47 then
            return PickupVariant.PICKUP_BOMB
        elseif x < 0.66 then
            return PickupVariant.PICKUP_TAROTCARD
        elseif x < 0.76 then
            return PickupVariant.PICKUP_LIL_BATTERY
        elseif x < 0.86 then
            return PickupVariant.PICKUP_CHEST
        elseif x < 0.85 then
            return PickupVariant.PICKUP_LOCKEDCHEST
        elseif x < 0.97 then
            return PickupVariant.PICKUP_REDCHEST
        elseif x < 0.99 then
            return PickupVariant.PICKUP_OLDCHEST
        else
            return PickupVariant.PICKUP_COLLECTIBLE
        end
    end
end

local function GetPickupSubType(variant)
    local stage = Game():GetLevel():GetStage()
    local x = math.random()
    if IsEarlyStage(stage) then
        if variant == PickupVariant.PICKUP_HEART then
            if x < 0.50 then
                return HeartSubType.HEART_FULL
            elseif x < 0.60 then
                return HeartSubType.HEART_HALF
            elseif x < 0.70 then
                return HeartSubType.HEART_DOUBLEPACK
            elseif x < 0.8 then
                return HeartSubType.HEART_BLENDED
            elseif x < 0.92 then
                return HeartSubType.HEART_SOUL
            else
                return HeartSubType.HEART_HALF_SOUL
            end
        elseif variant == PickupVariant.PICKUP_COIN then
            if x < 0.5 and Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_RED_KEY):IsAvailable() then
                return CoinSubType.COIN_GOLDEN
            else
                return CoinSubType.COIN_LUCKYPENNY
            end
        elseif variant == PickupVariant.PICKUP_KEY then
            if x < 0.7 then
                return KeySubType.KEY_NORMAL
            elseif x < 0.8 then
                return KeySubType.KEY_CHARGED
            else
                return KeySubType.KEY_GOLDEN
            end
        elseif variant == PickupVariant.PICKUP_BOMB then
            if x < 0.75 then
                return BombSubType.BOMB_NORMAL
            else
                return BombSubType.BOMB_GOLDEN
            end
        elseif variant == PickupVariant.PICKUP_TAROTCARD then
            if x < 0.5 then
                return Game():GetItemPool():GetCard(mod:RandomPositive(), true, false, false)
            elseif x < 0.83 then
                return Game():GetItemPool():GetCard(mod:RandomPositive(), false, true, true)
            else
                return Card.CARD_CRACKED_KEY
            end
        elseif variant == PickupVariant.PICKUP_COLLECTIBLE then
            return Isaac.GetItemIdByName("Leftovers")
        end
    else
        if variant == PickupVariant.PICKUP_HEART then
            if x < 10 then
                return HeartSubType.HEART_ETERNAL
            elseif x < 0.25 then
                return HeartSubType.HEART_FULL
            elseif x < 0.35 then
                return HeartSubType.HEART_HALF
            elseif x < 0.40 then
                return HeartSubType.HEART_DOUBLEPACK
            elseif x < 0.45 then
                return HeartSubType.HEART_BLENDED
            elseif x < 0.75 then
                return HeartSubType.HEART_SOUL
            elseif x < 91 then
                return HeartSubType.HEART_HALF_SOUL
            else
                return HeartSubType.HEART_BLACK
            end
        elseif variant == PickupVariant.PICKUP_COIN then
            if x < 0.5 and Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_RED_KEY):IsAvailable() then
                return CoinSubType.COIN_GOLDEN
            else
                return CoinSubType.COIN_LUCKYPENNY
            end
        elseif variant == PickupVariant.PICKUP_BOMB then
            if x < 0.75 then
                return BombSubType.BOMB_NORMAL
            else
                return BombSubType.BOMB_GOLDEN
            end
        elseif variant == PickupVariant.PICKUP_TAROTCARD then
            if x < 0.5 then
                return Game():GetItemPool():GetCard(mod:RandomPositive(), true, false, false)
            elseif x < 0.80 then
                return Game():GetItemPool():GetCard(mod:RandomPositive(), false, true, true)
            elseif x < 0.95 then
                return Card.CARD_CRACKED_KEY
            else
                return Card.CARD_DICE_SHARD
            end
        elseif variant == PickupVariant.PICKUP_COLLECTIBLE then
            return Isaac.GetItemIdByName("Leftovers")
        end
    end
    return 0
end

function mod:PreSpawnCleanAward()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(pickup) and math.random() < 0.15 + math.min(0.15, 0.01 * player.Luck) then
        local variant = GetPickupVariant()
        local subtype = GetPickupSubType(variant)
        Game():Spawn(EntityType.ENTITY_PICKUP, variant, Game():GetRoom():GetCenterPos(), Vector(0, 0), nil, subtype, Game():GetRoom():GetSpawnSeed())
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.PreSpawnCleanAward)
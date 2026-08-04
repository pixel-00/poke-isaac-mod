include("scripts.utilities")

local promoOffer = Isaac.GetItemIdByName("Promo Offer")

function mod:CanPurchase(player, pickup)
    local result = pickup.Wait <= 0 and player:CanPickupItem() and not player:IsHoldingItem()
    if pickup.Variant == PickupVariant.PICKUP_HEART then
        local subType = pickup.SubType
        if subType == HeartSubType.HEART_FULL or subType == HeartSubType.HEART_HALF or subType == HeartSubType.HEART_DOUBLEPACK or subType == HeartSubType.HEART_SCARED then
            result = result and player:CanPickRedHearts()
        elseif subType == HeartSubType.HEART_SOUL or subType == HeartSubType.HEART_HALF_SOUL then
            result = result and player:CanPickSoulHearts()
        elseif subType == HeartSubType.HEART_ETERNAL then
            -- do nothing
        elseif subType == HeartSubType.HEART_BLACK then
            result = result and player:CanPickBlackHearts()
        elseif subType == HeartSubType.HEART_BONE then
            result = result and player:CanPickBoneHearts()
        elseif subType == HeartSubType.HEART_ROTTEN then
            result = result and player:CanPickRottenHearts()
        elseif subType == HeartSubType.HEART_GOLDEN then
            result = result and player:CanPickGoldenHearts()
        elseif subType == HeartSubType.HEART_BLENDED then
            result = result and (player:CanPickRedHearts() or player:CanPickSoulHearts())
        else -- don't try to duplicate heart subtypes (from mods or future updates), can't check if the player can pick them up
            return false
        end
    elseif pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY then
        result = result and player:NeedsCharge()
    elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
        result = result and player:TryHoldTrinket(TrinketType.TRINKET_NULL)
    end
    return result
end

function mod:GetSoulHeartSubType()
    local x = math.random()
    if x < 0.83 then
        return HeartSubType.HEART_SOUL
    elseif x < 0.93 then
        return HeartSubType.HEART_BLENDED
    else
        return HeartSubType.HEART_BLACK
    end
end

function mod:DuplicatePurchase(pickup, collider, low)
    local player = Isaac.GetPlayer()
    if player:HasCollectible(promoOffer) and pickup:IsShopItem() and not pickup:GetData().Duplicated then
        if pickup.Price <= player:GetNumCoins() and mod:CanPurchase(player, pickup) then
            local spawnPosition = Game():GetLevel():GetCurrentRoom():FindFreePickupSpawnPosition(pickup.Position)
            local subType = 0
            if pickup.SubType == HeartSubType.HEART_SOUL then
                subType = mod:GetSoulHeartSubType()
            elseif pickup.SubType == HeartSubType.HEART_ETERNAL or pickup.SubType == HeartSubType.HEART_BLACK or pickup.SubType == HeartSubType.HEART_BONE or (pickup.SubType == Card.CARD_HOLY and Game():GetLevel():GetCurrentRoom():GetType() == RoomType.ROOM_ANGEL) then
                subType = pickup.SubType
            end
            Game():Spawn(EntityType.ENTITY_PICKUP, pickup.Variant, spawnPosition, Vector(0,0), collider, subType, mod:RandomPositive())
            pickup:GetData().Duplicated = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.DuplicatePurchase)
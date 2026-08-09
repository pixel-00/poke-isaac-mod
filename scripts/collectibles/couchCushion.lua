local couchCushion = Isaac.GetItemIdByName("Couch Cushion")

function mod:GetCushionPickup(roomType)
    local pickupToSpawn = {Variant = 0, SubType = 0}
    local x = math.random()
    if roomType == RoomType.ROOM_SHOP then
        if x < 0.5 then
            pickupToSpawn.Variant = PickupVariant.PICKUP_COIN
            pickupToSpawn.SubType = CoinSubType.COIN_GOLDEN
        else
            pickupToSpawn.Variant = PickupVariant.PICKUP_HEART
            pickupToSpawn.SubType = HeartSubType.HEART_GOLDEN
        end
    elseif roomType == RoomType.ROOM_ERROR then
        errorRoomVariants = {PickupVariant.PICKUP_HEART, PickupVariant.PICKUP_COIN, PickupVariant.PICKUP_KEY, PickupVariant.PICKUP_BOMB, PickupVariant.PICKUP_THROWABLEBOMB, PickupVariant.PICKUP_POOP, PickupVariant.PICKUP_CHEST, PickupVariant.PICKUP_BOMBCHEST, PickupVariant.PICKUP_SPIKEDCHEST, PickupVariant.PICKUP_ETERNALCHEST, PickupVariant.PICKUP_MIMICCHEST, PickupVariant.PICKUP_OLDCHEST, PickupVariant.PICKUP_WOODENCHEST, PickupVariant.PICKUP_MEGACHEST, PickupVariant.PICKUP_HAUNTEDCHEST, PickupVariant.PICKUP_LOCKEDCHEST, PickupVariant.PICKUP_GRAB_BAG, PickupVariant.PICKUP_PILL, PickupVariant.PICKUP_LIL_BATTERY, PickupVariant.PICKUP_COLLECTIBLE, PickupVariant.PICKUP_BROKEN_SHOVEL, PickupVariant.PICKUP_SHOPITEM, PickupVariant.PICKUP_TAROTCARD, PickupVariant.PICKUP_TRINKET, PickupVariant.PICKUP_REDCHEST}
        local randomIndex = math.random(#errorRoomVariants)
        pickupToSpawn.Variant = errorRoomVariants[randomIndex]
        if pickupToSpawn.Variant == PickupVariant.PICKUP_TAROTCARD then
            pickupToSpawn.SubType = Game():GetItemPool():GetCard(mod:RandomPositive(), true, true, false)
        end
    elseif roomType == RoomType.ROOM_TREASURE then
        pickupToSpawn.Variant = PickupVariant.PICKUP_TRINKET
    elseif roomType == RoomType.ROOM_BOSS then
        pickupToSpawn.Variant = PickupVariant.PICKUP_HEART
        pickupToSpawn.SubType = HeartSubType.HEART_HALF_SOUL
    elseif roomType == RoomType.ROOM_MINIBOSS then
        pickupToSpawn.Variant = PickupVariant.PICKUP_HEART
        pickupToSpawn.SubType = HeartSubType.HEART_SCARED
    elseif roomType == RoomType.ROOM_SECRET then
        pickupToSpawn.Variant = PickupVariant.PICKUP_HEART
        pickupToSpawn.SubType = HeartSubType.HEART_BONE
    elseif roomType == RoomType.ROOM_SUPERSECRET then
        pickupToSpawn.Variant = PickupVariant.PICKUP_KEY
        pickupToSpawn.SubType = KeySubType.KEY_GOLDEN
    elseif roomType == RoomType.ROOM_ARCADE then
        pickupToSpawn.Variant = PickupVariant.PICKUP_COIN
        pickupToSpawn.SubType = CoinSubType.COIN_LUCKYPENNY
    elseif roomType == RoomType.ROOM_CURSE then
        pickupToSpawn.Variant = PickupVariant.PICKUP_HEART
        pickupToSpawn.SubType = HeartSubType.HEART_ROTTEN
    elseif roomType == RoomType.ROOM_CHALLENGE then
        if Game():GetLevel():HasBossChallenge() then
            pickupToSpawn.Variant = PickupVariant.PICKUP_HEART
            pickupToSpawn.SubType = HeartSubType.HEART_BLENDED
        else
            pickupToSpawn.Variant = PickupVariant.PICKUP_GRAB_BAG
        end
    elseif roomType == RoomType.ROOM_LIBRARY then
        pickupToSpawn.Variant = PickupVariant.PICKUP_KEY
        pickupToSpawn.SubType = KeySubType.KEY_CHARGED
    elseif roomType == RoomType.ROOM_SACRIFICE then
        pickupToSpawn.Variant = PickupVariant.PICKUP_HEART
        pickupToSpawn.SubType = HeartSubType.HEART_DOUBLEPACK
    elseif roomType == RoomType.ROOM_DEVIL then
        pickupToSpawn.Variant = PickupVariant.PICKUP_HEART
        pickupToSpawn.SubType = HeartSubType.HEART_BLACK
    elseif roomType == RoomType.ROOM_ANGEL then
        pickupToSpawn.Variant = PickupVariant.PICKUP_HEART
        pickupToSpawn.SubType = HeartSubType.HEART_ETERNAL
    elseif roomType == RoomType.ROOM_ISAACS then
        pickupToSpawn.Variant = PickupVariant.PICKUP_WOODENCHEST
    elseif roomType == RoomType.ROOM_BARREN then
        pickupToSpawn.Variant = PickupVariant.PICKUP_OLDCHEST
    elseif roomType == RoomType.ROOM_CHEST then
        pickupToSpawn.Variant = PickupVariant.PICKUP_BOMB
        if x < 0.1 then
            pickupToSpawn.SubType = BombSubType.BOMB_GOLDENTROLL
        else
            pickupToSpawn.SubType = BombSubType.BOMB_GOLDEN
        end
    elseif roomType == RoomType.ROOM_DICE then
        pickupToSpawn.Variant = PickupVariant.PICKUP_TAROTCARD
        pickupToSpawn.SubType = Card.CARD_DICE_SHARD
    elseif roomType == RoomType.ROOM_PLANETARIUM then
        pickupToSpawn.Variant = PickupVariant.PICKUP_TAROTCARD
        pickupToSpawn.SubType = Game():GetItemPool():GetCard(mod:RandomPositive(), false, true, true)
    elseif roomType == RoomType.ROOM_ULTRASECRET then
        pickupToSpawn.Variant = PickupVariant.PICKUP_TAROTCARD
        pickupToSpawn.SubType = Card.CARD_CRACKED_KEY
    end
    return pickupToSpawn
end

function mod:SpawnCushionPickup()
    local room = Game():GetLevel():GetCurrentRoom()
    local roomType = room:GetType()
    local x = math.random()
    local player = Isaac.GetPlayer()
    local spawnChance = math.max(math.min(math.ceil(player.Luck + 4) / 10, 1), 0)
    if room:IsFirstVisit() and player:HasCollectible(couchCushion) and x <= spawnChance and roomType ~= RoomType.ROOM_DEFAULT then
        local pickupToSpawn = mod:GetCushionPickup(roomType)
        local spawnPosition = room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition())
        Game():Spawn(EntityType.ENTITY_PICKUP, pickupToSpawn.Variant, spawnPosition, Vector(0, 0), player, pickupToSpawn.SubType, mod:RandomPositive())
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SpawnCushionPickup)
local dauntlessShield = Isaac.GetItemIdByName("Dauntless Shield")

function mod:DauntlessShield()
    local player = Isaac.GetPlayer()
    local roomType = Game():GetLevel():GetCurrentRoom():GetType()
    local levelStage = Game():GetLevel():GetStage()
    if player:HasCollectible(dauntlessShield) and (roomType == RoomType.ROOM_BOSS or roomType == RoomType.ROOM_MINIBOSS or roomType == RoomType.ROOM_CHALLENGE or levelStage == LevelStage.STAGE8) then
        player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_WAFER, true, 1)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.DauntlessShield)
local redMap = Isaac.GetItemIdByName("Red Map")
local needToDisplayUltraSecret = true

function mod:redMap()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(redMap) and needToDisplayUltraSecret then
        local level = Game():GetLevel()
        local rooms = level:GetRooms()
        local ultraSecretIndex = -1
        for i = 0, rooms.Size - 1 do
            if rooms:Get(i).Data.Type == RoomType.ROOM_ULTRASECRET then
                ultraSecretIndex = rooms:Get(i).GridIndex
            end
        end
        needToDisplayUltraSecret = false
        if ultraSecretIndex >= 0 then
            local ultraSecretRoom = level:GetRoomByIdx(ultraSecretIndex)
            ultraSecretRoom.DisplayFlags = (1 << 0) | (1 << 1) | (1 << 2)
            level:UpdateVisibility()
        end
    end
end

function mod:newLevel()
    needToDisplayUltraSecret = true
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.redMap)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.newLevel)
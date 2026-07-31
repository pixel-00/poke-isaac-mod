local foolsMap = Isaac.GetItemIdByName("Fool's Map")
local roomRNG = RNG()

function mod:RevealRandom()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(foolsMap) then
        local level = Game():GetLevel()
        roomRNG:SetSeed(level:GetCurrentRoom():GetAwardSeed(), 1)
        local rooms = level:GetRooms()
        local index = rooms:Get(roomRNG:RandomInt(rooms.Size)).GridIndex
        local room = level:GetRoomByIdx(index)
        room.DisplayFlags = (1 << 0) | (1 << 1) | (1 << 2)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.RevealRandom)
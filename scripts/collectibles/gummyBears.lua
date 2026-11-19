local gummyBears = Isaac.GetItemIdByName("Gummy Bears")

PLAYER_GUMMY_BEARS = {}

local function AddGummyBear(player)
    return player:AddMinisaac(player.Position)
end

function mod:InitialGummyBears(player)
    local queued = player.QueuedItem
    local data = player:GetData()
    if queued.Item and queued.Item:IsCollectible() and queued.Item.ID == gummyBears and not queued.Touched then
        data.NUM_GUMMY_BEARS = player:GetCollectibleNum(gummyBears)
    end
    if data.NUM_GUMMY_BEARS and data.NUM_GUMMY_BEARS < player:GetCollectibleNum(gummyBears) then
        AddGummyBear(player)
        AddGummyBear(player)
        AddGummyBear(player)
        data.NUM_GUMMY_BEARS = nil
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.InitialGummyBears)
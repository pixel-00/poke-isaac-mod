local emptySet = Isaac.GetItemIdByName("Empty Set")

local function RemoveAllCollectibles(player)
    local numCollectibles = Isaac.GetItemConfig():GetCollectibles().Size
    local i = 0
    while i < numCollectibles do
        while player:HasCollectible(i) do
            player:RemoveCollectible(i, false, ActiveSlot.SLOT_PRIMARY, true)
            player:RemoveCollectible(i, false, ActiveSlot.SLOT_SECONDARY, true)
        end
        i = i + 1
    end
end

local function EmptyHealth(player)
    player:AddMaxHearts(-player:GetMaxHearts(), true)
    player:AddSoulHearts(-player:GetSoulHearts())
    player:AddBrokenHearts(-player:GetBrokenHearts())
    player:AddBoneHearts(1 - player:GetBoneHearts())
end

function mod:EmptySet(player)
    local queued = player.QueuedItem
    local data = player:GetData()
    if queued.Item and queued.Item:IsCollectible() and queued.Item.ID == emptySet and not queued.Touched then
        data.numEmptySet = player:GetCollectibleNum(emptySet)
    end
    if data.numEmptySet and data.numEmptySet < player:GetCollectibleNum(emptySet) then
        if player:GetCollectibleNum(emptySet) == 1 then
            RemoveAllCollectibles(player)
            EmptyHealth(player)
            player:UseActiveItem(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, false, false, true, false, -1, 0)
        end
        data.numEmptySet = nil
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.EmptySet)
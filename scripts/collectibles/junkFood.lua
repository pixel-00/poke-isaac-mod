local junkFood = Isaac.GetItemIdByName("Junk Food")

function mod:GiveRottenHearts(player)
    local queued = player.QueuedItem
    local data = player:GetData()
    if queued.Item and queued.Item:IsCollectible() and queued.Item.ID == junkFood and not queued.Touched then
        data.NUM_JUNK_FOOD = player:GetCollectibleNum(junkFood)
    end
    if data.NUM_JUNK_FOOD and data.NUM_JUNK_FOOD < player:GetCollectibleNum(junkFood) then
        local heartsToAdd = player:GetEffectiveMaxHearts()
        player:AddRottenHearts(heartsToAdd)
        data.NUM_JUNK_FOOD = nil
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.GiveRottenHearts)
local earlyOnset = Isaac.GetItemIdByName("Early Onset")

local timer = 0
local lastUsedStage = nil

function mod:RestartFloor(player)
    if player:HasCollectible(earlyOnset) and lastUsedStage ~= Game():GetLevel():GetStage() and timer < Isaac.GetTime() then
        lastUsedStage = Game():GetLevel():GetStage()
        player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, 0, -1, 0)
    end
end

function mod:SetTimer()
    timer = Isaac.GetTime() + 30 * 1000
end

function mod:ResetTimer(isContinued)
    if not isContinued then
        timer = 0
        lastUsedStage = nil
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.RestartFloor)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.SetTimer)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.ResetTimer)
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

function mod:SaveEarlyOnset(shouldSave)
    if shouldSave then
        local saveData = mod:GetSaveData()

        local function f(player)
            mod:AddPlayerData(player, "Early Onset", timer, saveData)
        end

        mod:DoForAllPlayers(f) -- although the timer is fixed for all players, it is easier to use the existing framework
        mod:EncodeAndSaveData(saveData)
    end
end

function mod:LoadEarlyOnset(continued)
    if continued then
        local function f(player)
            local data = mod:LoadPlayerData(player, "Early Onset")

            if not data then
                data = 0
            end

            timer = data
        end

        mod:DoForAllPlayers(f)
    else
        timer = 0
        lastUsedStage = nil
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.RestartFloor)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.SetTimer)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveEarlyOnset)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadEarlyOnset)
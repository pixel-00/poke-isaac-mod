local sturdy = Isaac.GetItemIdByName("Sturdy")

STURDY_STATUS = {}

function mod:PreventDeath(entity, amount, damageFlags, source, countdownFrames)
    local player = entity:ToPlayer()

    if player then
        local health = player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts() + player:GetRottenHearts() + player:GetEternalHearts()
        local index = mod:GetPlayerIndex(player)

        if player:HasCollectible(sturdy) and (health <= amount) and not STURDY_STATUS[index] then
            STURDY_STATUS[index] = true
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, true, 1)
            return false
        end
    end
end

function mod:ResetSturdy()
    local function f(player)
        if player:HasCollectible(sturdy) then
            local index = mod:GetPlayerIndex(player)

            STURDY_STATUS[index] = false
        end
    end

    mod:DoForAllPlayers(f)
end

function mod:SaveSturdy(shouldSave)
    if shouldSave then
        local saveData = mod:GetSaveData()

        local function f(player)
            local index = mod:GetPlayerIndex(player)

            mod:AddPlayerData(player, "Sturdy", STURDY_STATUS[index], saveData)
        end

        mod:DoForAllPlayers(f)
        mod:EncodeAndSaveData(saveData)
    end
end

function mod:LoadSturdy(continued)
    if continued then
        local function f(player)
            local playerData = mod:LoadPlayerData(player, "Sturdy")
            local index = mod:GetPlayerIndex(player)

            if not playerData then
                playerData = false
            end

            STURDY_STATUS[index] = playerData
        end

        mod:DoForAllPlayers(f)
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.PreventDeath)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetSturdy)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveSturdy)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadSturdy)
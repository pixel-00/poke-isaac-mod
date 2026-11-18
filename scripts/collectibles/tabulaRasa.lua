local tabulaRasa = Isaac.GetItemIdByName("Tabula Rasa")

local tabulaRasaItemPool = false

function mod:UseItem(item, rng, player, useFlags, activeSlot, varData)
    local roomType = Game():GetLevel():GetCurrentRoom():GetType()
    tabulaRasaItemPool = Game():GetItemPool():GetPoolForRoom(roomType, Game():GetSeeds():GetStartSeed())
    return {
        Remove = true,
        ShowAnim = true
    }
end

function mod:EnsureTabulaRasaPool(itemPool, decrease, seed)
    if tabulaRasaItemPool and itemPool ~= tabulaRasaItemPool then
        return Game():GetItemPool():GetCollectible(tabulaRasaItemPool, decrease, seed, CollectibleType.COLLECTIBLE_NULL, tabulaRasaItemPool)
    end
end

function mod:SaveTabulaRasa(shouldSave)
    if shouldSave then
        local saveData = mod:GetSaveData()

        local function f(player)
            mod:AddPlayerData(player, "Tabula Rasa", tabulaRasaItemPool, saveData)
        end

        mod:DoForAllPlayers(f) -- although the pool is fixed for all players, it is easier to use the existing framework
        mod:EncodeAndSaveData(saveData)
    end
end

function mod:LoadTabulaRasa(continued)
    if continued then
        local function f(player)
            local data = mod:LoadPlayerData(player, "Tabula Rasa")

            if not data then
                data = false
            end

            tabulaRasaItemPool = data
        end

        mod:DoForAllPlayers(f)
    else
        tabulaRasaItemPool = false
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseItem, tabulaRasa)
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, mod.EnsureTabulaRasaPool)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveTabulaRasa)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadTabulaRasa)
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

function mod:ResetTabulaRasa(isContinued)
    if not isContinued then
        tabulaRasaItemPool = false
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseItem, tabulaRasa)
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, mod.EnsureTabulaRasaPool)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.ResetTabulaRasa)
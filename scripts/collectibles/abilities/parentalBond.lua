local parentalBond = Isaac.GetItemIdByName("Parental Bond")

local PLAYER_MINISAACS = {}

function mod:UpdateMinisaac(player)
    if player:HasCollectible(parentalBond) then
        local index = mod:GetPlayerIndex(player)
        local mini = PLAYER_MINISAACS[index]

        if not mini then
            PLAYER_MINISAACS[index] = player:AddMinisaac(player.Position)
        end
    end
end

local function IsParentalBondMinisaac(familiar)
    local player = familiar.Player

    if player then
        local index = mod:GetPlayerIndex(player)
        if familiar == PLAYER_MINISAACS[index] then
            return true
        else
            PLAYER_MINISAACS[index] = nil
        end
    end

    return false
end

function mod:MinisaacInvincibility(entity, amount, flags, source)
    if entity:ToFamiliar() and IsParentalBondMinisaac(entity:ToFamiliar()) then
        return false
    end
end

function mod:SaveParentalBond(shouldSave)
    if shouldSave then
        local saveData = mod:GetSaveData()

        local function f(player)
            local index = mod:GetPlayerIndex(player)

            mod:AddPlayerData(player, "Parental Bond", PLAYER_MINISAACS[index], saveData)
        end

        mod:DoForAllPlayers(f)
        mod:EncodeAndSaveData(saveData)
    end
end

function mod:LoadParentalBond(continued)
    if continued then
        local function f(player)
            local index = mod:GetPlayerIndex(player)
            PLAYER_MINISAACS[index] = mod:LoadPlayerData(player, "Parental Bond")
        end

        mod:DoForAllPlayers(f)
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.MinisaacInvincibility)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.UpdateMinisaac)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveParentalBond)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadParentalBond)
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

local function IsPlayerMinisaac(familiar)
    local player = familiar.Player
    if player then
        local index = mod:GetPlayerIndex(player)
        return familiar == PLAYER_MINISAACS[index]
    else
        return false
    end
end

function mod:MinisaacInvincibility(entity, amount, flags, source)
    if entity:ToFamiliar() and IsPlayerMinisaac(entity:ToFamiliar()) then
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.MinisaacInvincibility)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.UpdateMinisaac)
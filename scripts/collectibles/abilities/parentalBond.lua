local parentalBond = Isaac.GetItemIdByName("Parental Bond")

local PLAYER_MINISAACS = {}

function mod:UpdateMinisaac(player)
    if player:HasCollectible(parentalBond) then
        local index = mod:GetPlayerIndex(player)
        local mini = PLAYER_MINISAACS[index]

        if not mini then
            PLAYER_MINISAACS[index] = player:AddMinisaac(player.Position)
            PLAYER_MINISAACS[index]:GetData().ParentalBondInvincibility = true
        end
    end
end

function mod:MinisaacInvincibility(entity, amount, flags, source)
    if entity:ToFamiliar() and entity:GetData().ParentalBondInvincibility then
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.MinisaacInvincibility)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.UpdateMinisaac)
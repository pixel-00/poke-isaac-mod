local parentalBond = Isaac.GetItemIdByName("Parental Bond")

function mod:UpdateMinisaac(player)
    if player:HasCollectible(parentalBond) then
        local mini = player:GetData().ParentalBondMinisaac
        if not mini then
            player:GetData().ParentalBondMinisaac = player:AddMinisaac(player.Position)
            player:GetData().ParentalBondMinisaac:GetData().ParentalBondInvincibility = true
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
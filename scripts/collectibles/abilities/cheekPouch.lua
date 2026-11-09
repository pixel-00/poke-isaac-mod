include("scripts.utilities")

local cheekPouch = Isaac.GetItemIdByName("Cheek Pouch")

function mod:ExtraHealing(pillEffect, player, useFlags)
    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, player.Position, Vector(0, 0), player, 0, mod:RandomPositive())
    player:AddHearts(1)
end

mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.ExtraHealing)
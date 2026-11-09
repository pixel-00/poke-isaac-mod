local effectSpore = Isaac.GetItemIdByName("Effect Spore")

local DEFAULT_FART_RADIUS = 85

function mod:EffectSpore(player, collider, low)
    if player:HasCollectible(effectSpore) and collider:IsVulnerableEnemy() then
        local x = math.random()
        if math.random(2) == 1 then
            if x < 1/3 then
                Game():Fart(player.Position, DEFAULT_FART_RADIUS, player, 1, 0, Color.Default)
            elseif x < 2/3 then
                Game():CharmFart(player.Position, DEFAULT_FART_RADIUS, player)
            elseif x < 0.9 then
                Game():ButterBeanFart(player.Position, DEFAULT_FART_RADIUS, player, true, false)
            else
                Game():ButterBeanFart(player.Position, DEFAULT_FART_RADIUS, player, true, true)
            end
        end
        if math.random(2) == 1 then
            if x < 0.25 then
                collider:AddCharmed(player, 45, true)
            elseif x < 0.5 then
                collider:AddFreeze(player, 45, true)
            elseif x < 0.75 then
                collider:AddPoison(player, 45, player.Damage, false)
            else
                collider:AddSlowing(player, 45, 0.5, Color.Default, true)
            end
        end
        if math.random(2) == 1 then
            if x < 0.25 then
                collider:AddCharmed(player, 45, true)
            elseif x < 0.5 then
                collider:AddFreeze(player, 45, true)
            elseif x < 0.75 then
                collider:AddPoison(player, 45, player.Damage, false)
            else
                collider:AddSlowing(player, 45, 0.5, Color.Default, true)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.EffectSpore)
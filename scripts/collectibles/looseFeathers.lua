local looseFeathers = Isaac.GetItemIdByName("Loose Feathers")

local TEARS_MULTIPLIER = 3/5

function mod:TearEffect(tear)
    local player = Isaac.GetPlayer()
    if player:GetData().looseFeathers then
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING
        tear.Scale = tear.Scale * 1.25
        tear:GetData().isWindTear = true
    end
end

function mod:DragEnemy(tear, enemy, _)
    if tear:GetData().isWindTear and enemy:IsEnemy() then
        if enemy:IsBoss() then
            enemy:AddVelocity(tear.Velocity / 4, false)
        elseif enemy.Type == EntityType.ENTITY_FIREPLACE then
            enemy:Kill()
        else
            enemy:AddVelocity(tear.Velocity / 2, false)
        end
    end
end

function mod:ApplyStats(player, cacheFlags)
    local itemCount = math.max(player:GetCollectibleNum(looseFeathers), player:GetData().looseFeathers and 1 or 0)
	if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY and itemCount > 0 then
	    local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	    tearsPerSecond = tearsPerSecond * TEARS_MULTIPLIER
	    player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
    end
    if (cacheFlags & CacheFlag.CACHE_SHOTSPEED) == CacheFlag.CACHE_SHOTSPEED then
        local shotSpeedToAdd = 0.25 * itemCount
        player.ShotSpeed = player.ShotSpeed + shotSpeedToAdd
    end
end

function mod:UpdateLooseFeathersFlag(player)
    if player:HasCollectible(looseFeathers) then
        player:GetData().looseFeathers = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.TearEffect)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.DragEnemy)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.UpdateLooseFeathersFlag)
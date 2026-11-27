local looseFeathers = Isaac.GetItemIdByName("Loose Feathers")

local TEARS_MULTIPLIER = 3/5
local LOOSE_FEATHERS_INCREMENT = 1/30

function mod:TearEffect(tear)
    local player = tear.SpawnerEntity
    if player and player:ToPlayer() and player:ToPlayer():HasCollectible(looseFeathers) then
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING
        tear.Scale = tear.Scale * 1.25
        tear:GetData().LOOSE_FEATHERS_TEAR = true
    end
end

function mod:DragEnemy(tear, enemy, _)
    if tear:GetData().LOOSE_FEATHERS_TEAR and enemy:IsEnemy() then
        if type(enemy:GetData().LOOSE_FEATHERS_COEFFICIENT) == "number" then
            enemy:GetData().LOOSE_FEATHERS_COEFFICIENT = enemy:GetData().LOOSE_FEATHERS_COEFFICIENT - LOOSE_FEATHERS_INCREMENT
        else
            enemy:GetData().LOOSE_FEATHERS_COEFFICIENT = 1
        end

        if enemy:IsBoss() then
            enemy:AddVelocity((enemy:GetData().LOOSE_FEATHERS_COEFFICIENT / 4) * tear.Velocity, false)
        elseif enemy.Type == EntityType.ENTITY_FIREPLACE then
            enemy:Kill()
        else
            enemy:AddVelocity((enemy:GetData().LOOSE_FEATHERS_COEFFICIENT / 2) * tear.Velocity, false)
        end
    end
end

function mod:ApplyStats(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(looseFeathers)

    if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY and itemCount > 0 then
	    local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)

        tearsPerSecond = tearsPerSecond * TEARS_MULTIPLIER * math.min(itemCount, 1)
	    player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
    end

    if (cacheFlags & CacheFlag.CACHE_SHOTSPEED) == CacheFlag.CACHE_SHOTSPEED then
        local shotSpeedToAdd = 0.25 * itemCount

        player.ShotSpeed = player.ShotSpeed + shotSpeedToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.TearEffect)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.DragEnemy)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)
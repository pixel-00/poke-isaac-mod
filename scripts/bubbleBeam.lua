local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")
local bubbleBeamMultiplier = 0.5
local bubbleBeamShotSpeed = 0.4
local bubbleBeamTearRadius = 30

local function toTearsPerSecond(maxFireDelay)
	return 30 / (maxFireDelay + 1)
end

local function toMaxFireDelay(tearsPerSecond)
	return (30 / tearsPerSecond) - 1
end

function mod:EvaluateCache(player, cacheFlags)
	local itemCount = player:GetCollectibleNum(bubbleBeam)
	if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
	    local tearsPerSecond = toTearsPerSecond(player.MaxFireDelay)
	    tearsPerSecond = tearsPerSecond + (5 * itemCount)
	    player.MaxFireDelay = toMaxFireDelay(tearsPerSecond)
	end
	if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
	    local multiplierToAdd = bubbleBeamMultiplier^itemCount
	    player.Damage = player.Damage * (multiplierToAdd)
	end
	if (cacheFlags & CacheFlag.CACHE_SHOTSPEED) == CacheFlag.CACHE_SHOTSPEED then
		local shotSpeedToRemove = bubbleBeamShotSpeed * itemCount
	    player.ShotSpeed = player.ShotSpeed - shotSpeedToRemove
	end
end

function mod:bubbleTear(tear)
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(bubbleBeam) then
		tear.Velocity = tear.Velocity:Rotated(math.random(-bubbleBeamTearRadius, bubbleBeamTearRadius))
		tear.Scale = tear.Scale * 1.5
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.bubbleTear)
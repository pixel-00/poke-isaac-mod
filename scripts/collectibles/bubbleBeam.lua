local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")

local BB_TEARS_MULTIPLIER = 1.5
local BB_FLAT_TEARS_UP = 0.5
local BB_DAMAGE_MULTIPLIER = 0.35
local BB_SHOT_SPEED_DOWN = 0.4
local BB_TEAR_RADIUS = 30

local canFireExtra = true

function mod:EvaluateCache(player, cacheFlags)
	local itemCount = player:GetCollectibleNum(bubbleBeam)
	if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
	    local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	    tearsPerSecond = BB_TEARS_MULTIPLIER^itemCount * tearsPerSecond + (BB_FLAT_TEARS_UP * itemCount)
	    player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
	end
	if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
	    local multiplierToAdd = BB_DAMAGE_MULTIPLIER^itemCount
	    player.Damage = player.Damage * (multiplierToAdd)
	end
	if (cacheFlags & CacheFlag.CACHE_SHOTSPEED) == CacheFlag.CACHE_SHOTSPEED then
		local shotSpeedToRemove = BB_SHOT_SPEED_DOWN * itemCount
	    player.ShotSpeed = player.ShotSpeed - shotSpeedToRemove
	end
end

function mod:BubbleTear(tear)
	local player = tear.SpawnerEntity
	local tearVelocity = tear.Velocity

    if player and player:ToPlayer() and player:ToPlayer():HasCollectible(bubbleBeam) then
        local sprite = tear:GetSprite()

        if sprite:GetFilename() == "gfx/002.000_Tear.anm2" then
            sprite:ReplaceSpritesheet(0, "gfx/bubble_tears.png")
            sprite:LoadGraphics()
        end

        tear.Velocity = tear.Velocity:Rotated((math.random() - 0.5) * 2 * BB_TEAR_RADIUS)
		tear.Scale = tear.Scale * ((3 * math.random()^2) + 7) / 5

        if canFireExtra then
			local tearAmount = math.random(0,4)

            while tearAmount > 0 do
                canFireExtra = false
                local newLength = tearVelocity:Length() * ((6 * math.random() + 17) / 20)
                local newVelocity = tearVelocity:Resized(newLength)

                player:ToPlayer():FireTear(tear.Position, newVelocity)
                tearAmount = tearAmount - 1
			end
		end

        canFireExtra = true
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.BubbleTear)
local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")

local bubbleBeamMultiplier = 0.35
local bubbleBeamShotSpeed = 0.4
local bubbleBeamTearRadius = 30

local BUBBLE_BEAM_EXTRAS = {}

function mod:EvaluateCache(player, cacheFlags)
	local itemCount = player:GetCollectibleNum(bubbleBeam)
	if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
	    local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	    tearsPerSecond = tearsPerSecond + (2.27 * itemCount)
	    player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
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

function mod:BubbleTear(tear)
	local player = tear.SpawnerEntity
	local tearVelocity = tear.Velocity

    if player and player:ToPlayer() and player:ToPlayer():HasCollectible(bubbleBeam) then
        local sprite = tear:GetSprite()

        print(sprite:GetFilename())
        if sprite:GetFilename() == "gfx/002.000_tear.anm2" then
            sprite:ReplaceSpritesheet(0, "gfx/bubble_tears.png")
            sprite:LoadGraphics()
        end

        tear.Velocity = tear.Velocity:Rotated(math.random(-bubbleBeamTearRadius, bubbleBeamTearRadius))
		tear.Scale = tear.Scale * 1.5

        if not BUBBLE_BEAM_EXTRAS[GetPtrHash(tear)] then
			local tearAmount = math.random(0,4)

            while tearAmount > 0 do
                local newLength = tearVelocity:Length() * ((6 * math.random() + 17) / 20)
                local newVelocity = tearVelocity:Resized(newLength)
                local subTear = player:ToPlayer():FireTear(player.Position, newVelocity)

                BUBBLE_BEAM_EXTRAS[GetPtrHash(subTear)] = true
                tearAmount = tearAmount - 1
			end
		end
	end
end

function mod:BubbleTearPop(tear)
    if tear then
        local effects = Isaac.FindInRadius(tear.Position, 0)
        local n = #effects
        while n > 0 do
            local effect = effects[i]
            local sprite = effect:GetSprite()

            if effect.Type == EntityType.ENTITY_EFFECT then
                print(effect:GetSprite():GetFilename())
                if false and effect.Variant == EffectVariant.TEAR_POOF_A then
                    sprite:ReplaceSpritesheet(0, "gfx/effects/bubble_tears.png")
                    sprite:LoadGraphics()
                elseif false and effect.Variant == EffectVariant.TEAR_POOF_B then
                    sprite:ReplaceSpritesheet(0, "gfx/effects/bubble_tears.png")
                    sprite:LoadGraphics()
                end
            end
            n = n - 1
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.BubbleTear)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.BubbleTearPop)
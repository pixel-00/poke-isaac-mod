local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")

local bubbleBeamMultiplier = 0.35
local bubbleBeamShotSpeed = 0.4
local bubbleBeamTearRadius = 30

local canFireExtra = true

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

        if sprite:GetFilename() == "gfx/002.000_Tear.anm2" then
            sprite:ReplaceSpritesheet(0, "gfx/bubble_tears.png")
            sprite:LoadGraphics()
        end

        tear.Velocity = tear.Velocity:Rotated((math.random() - 0.5) * 2 * bubbleBeamTearRadius)
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

local function LaserCategory(laser)
    if laser.Variant == LaserVariant.THICK_RED
    or laser.Variant == LaserVariant.THIN_RED
    or laser.Variant == LaserVariant.SHOOP
    or laser.Variant == LaserVariant.GIANT_RED
    or laser.Variant == LaserVariant.BRIM_TECH
    or laser.Variant == LaserVariant.THICKER_RED
    or laser.Variant == LaserVariant.THICK_BROWN
    or laser.Variant == LaserVariant.THICKER_BRIM_TECH
    or laser.Variant == LaserVariant.GIANT_BRIM_TECH then
        return "Brimstone"
    elseif laser.Variant == LaserVariant.ELECTRIC then
        if laser.SubType == LaserSubType.LASER_SUBTYPE_LINEAR then
            return "Technology"
        elseif laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE then
            return "Tech X"
        end
    end
end

function mod:BubbleLaser(laser)
    local player = laser.SpawnerEntity

    if player and player:ToPlayer() and player:ToPlayer():HasCollectible(bubbleBeam) then
        laser.Angle = (math.random() - 0.5) * 2 * bubbleBeamTearRadius

        if canFireExtra then
			local extraAmount = math.random(0,4)
            local category = LaserCategory(laser)

            while extraAmount > 0 do
                canFireExtra = false
                local direction = player:ToPlayer():GetAimDirection():Rotated((math.random() - 0.5) * 2 * bubbleBeamTearRadius)
                if category == "Brimstone" then
                    player:ToPlayer():FireBrimstone(direction, player)
                elseif category == "Technology" then
                    player:ToPlayer():FireTechLaser(laser.Position, LaserOffset.LASER_TECH1_OFFSET, direction, false, false, player)
                elseif category == "Tech X" then
                    player:ToPlayer():FireTechXLaser(laser.Position, direction, 30, player)
                end
                extraAmount = extraAmount - 1
			end
		end

        canFireExtra = true

    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.BubbleTear)
mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, mod.BubbleLaser)
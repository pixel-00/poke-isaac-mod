local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")

local BB_TEARS_MULTIPLIER = 1.5
local BB_FLAT_TEARS_UP = 0.5
local BB_DAMAGE_MULTIPLIER = 0.35
local BB_SHOT_SPEED_DOWN = 0.4
local BB_TEAR_RADIUS = 30

local canFireExtra = true

local LAST_FIRING_DIRECTION = {}

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

local function LaserCategory(laser)
    if laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE then
        return "Tech X"
    elseif laser.Variant == LaserVariant.THICK_RED
    or laser.Variant == LaserVariant.GIANT_RED
    or laser.Variant == LaserVariant.BRIM_TECH
    or laser.Variant == LaserVariant.THICKER_RED
    or laser.Variant == LaserVariant.THICKER_BRIM_TECH
    or laser.Variant == LaserVariant.GIANT_BRIM_TECH then
        return "Brimstone"
    elseif laser.Variant == LaserVariant.THIN_RED then
        return "Technology"
    end
end

function mod:BubbleLaser(laser)
    local player = laser.SpawnerEntity

    if player and player:ToPlayer() and player:ToPlayer():HasCollectible(bubbleBeam) then
        if canFireExtra then
			local extraAmount = math.random(0,3)
            local category = LaserCategory(laser)

            while extraAmount > 0 do
                canFireExtra = false
                local index = mod:GetPlayerIndex(player:ToPlayer())
                local lastDirection = LAST_FIRING_DIRECTION[index]
                local direction

                if lastDirection then
                    direction = lastDirection:Rotated((math.random() - 0.5) * 2 * BB_TEAR_RADIUS)
                else
                    direction = Vector(0, 1):Rotated((math.random() - 0.5) * 2 * BB_TEAR_RADIUS)
                end

                if category == "Brimstone" and laser.Parent == player then
                    player:ToPlayer():FireBrimstone(direction, player, 0.5)
                elseif category == "Technology" and laser.Parent == player then
                    player:ToPlayer():FireTechLaser(player.Position, LaserOffset.LASER_TECH1_OFFSET, direction, false, false, player, 0.5)
                elseif category == "Tech X" and laser.Parent == player then
                    local length = 10 * player.ShotSpeed
                    player:ToPlayer():FireTechXLaser(player.Position, direction:Resized(length), 20 * math.random() + 10, player, 0.5)
                end
                print("last direction: " .. direction.X .. ", " .. direction.Y)
                print("spawner type: " .. laser.SpawnerType)

                extraAmount = extraAmount - 1
			end
		end

        canFireExtra = true

    end
end

function mod:UpdateDirection(player)
    if player:HasCollectible(bubbleBeam) then
        local index = mod:GetPlayerIndex(player)
        local direction = player:GetAimDirection()

        if not (direction.X == 0 and direction.Y == 0) then
            LAST_FIRING_DIRECTION[index] = direction
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.BubbleTear)
mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, mod.BubbleLaser)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.UpdateDirection)
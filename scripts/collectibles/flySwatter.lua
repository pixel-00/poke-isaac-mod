local flySwatter = Isaac.GetItemIdByName("Fly Swatter")

function mod:TearEffect(tear)
    local player = Isaac.GetPlayer()
    if player:HasCollectible(flySwatter) then
        tear:GetData().flySwatter = true
    end
end

local function IsBug(enemy)
    if enemy.Type == EntityType.ENTITY_FLY --flies
    or enemy.Type == EntityType.ENTITY_ATTACKFLY
    or enemy.Type == EntityType.ENTITY_RING_OF_FLIES
    or enemy.Type == EntityType.ENTITY_MOTER
    or enemy.Type == EntityType.ENTITY_ETERNALFLY
    or enemy.Type == EntityType.ENTITY_DART_FLY
    or enemy.Type == EntityType.ENTITY_SWARM
    or enemy.Type == EntityType.ENTITY_HUSH_FLY
    or enemy.Type == EntityType.ENTITY_ARMYFLY
    or enemy.Type == EntityType.ENTITY_WILLO
    or (enemy.Type == EntityType.ENTITY_BEAST and (enemy.Variant == 11 or enemy.Variant == 21 or enemy.Variant == 23)) --ultra horseman flies
    or enemy.Type == EntityType.ENTITY_POOTER
    or enemy.Type == EntityType.ENTITY_SUCKER
    or enemy.Type == EntityType.ENTITY_BOOMFLY
    or enemy.Type == EntityType.ENTITY_FLY_L2
    or enemy.Type == EntityType.ENTITY_FULL_FLY
    or enemy.Type == EntityType.ENTITY_WILLO_L2
    or enemy.Type == EntityType.ENTITY_FLY_BOMB
    or enemy.Type == EntityType.ENTITY_BABY_PLUM
    -- spiders
    or enemy.Type == EntityType.ENTITY_SPIDER
    or enemy.Type == EntityType.ENTITY_BIGSPIDER
    or enemy.Type == EntityType.ENTITY_SWARM_SPIDER
    or enemy.Type == EntityType.ENTITY_STRIDER
    or enemy.Type == EntityType.ENTITY_ROCK_SPIDER
    or enemy.Type == EntityType.ENTITY_SPIDER_L2
    or enemy.Type == EntityType.ENTITY_TICKING_SPIDER
    or enemy.Type == EntityType.ENTITY_MIGRAINE
    or (enemy.Type == EntityType.ENTITY_HOPPER and enemy.Variant == 1) --trite
    or enemy.Type == EntityType.ENTITY_RAGLING
    or enemy.Type == EntityType.ENTITY_BLISTER
    or enemy.Type == EntityType.ENTITY_TWITCHY
    or enemy.Type == EntityType.ENTITY_BABY_LONG_LEGS
    or enemy.Type == EntityType.ENTITY_CRAZY_LONG_LEGS
    or enemy.Type == EntityType.ENTITY_WALL_CREEP
    or enemy.Type == EntityType.ENTITY_RAGE_CREEP
    or enemy.Type == EntityType.ENTITY_BLIND_CREEP
    or enemy.Type == EntityType.ENTITY_THE_THING
    or enemy.Type == EntityType.ENTITY_WIDOW
    or enemy.Type == EntityType.ENTITY_DADDYLONGLEGS
    or enemy.Type == EntityType.ENTITY_REAP_CREEP
    then
        return true
    else
        return false
    end
end

local function IsSmallBug(enemy)
    if enemy.Type == EntityType.ENTITY_FLY --flies
    or enemy.Type == EntityType.ENTITY_ATTACKFLY
    or enemy.Type == EntityType.ENTITY_RING_OF_FLIES
    or enemy.Type == EntityType.ENTITY_MOTER
    or enemy.Type == EntityType.ENTITY_ETERNALFLY
    or enemy.Type == EntityType.ENTITY_DART_FLY
    or enemy.Type == EntityType.ENTITY_SWARM
    or enemy.Type == EntityType.ENTITY_HUSH_FLY
    or enemy.Type == EntityType.ENTITY_ARMYFLY
    or enemy.Type == EntityType.ENTITY_WILLO
    or (enemy.Type == EntityType.ENTITY_BEAST and (enemy.Variant == 11 or enemy.Variant == 21)) --ultra horseman flies
    or enemy.Type == EntityType.ENTITY_FLY_BOMB
    -- spiders
    or enemy.Type == EntityType.ENTITY_SPIDER
    or enemy.Type == EntityType.ENTITY_SWARM_SPIDER
    or enemy.Type == EntityType.ENTITY_STRIDER
    or enemy.Type == EntityType.ENTITY_ROCK_SPIDER
    then
        return true
    else
        return false
    end
end

function mod:KillBugs(tear, enemy, _)
    if tear:GetData().flySwatter and enemy:IsEnemy() then
        local damage = tear.BaseDamage
        if IsSmallBug(enemy) then
            enemy:Die()
        elseif IsBug(enemy) then
            enemy:TakeDamage(damage, 0, EntityRef(tear.SpawnerEntity), 0)
        end
    end
end

function mod:KillFamiliars(tear)
    if tear:GetData().flySwatter then
        entities = Isaac.FindInRadius(tear.Position, tear.Size, EntityPartition.FAMILIAR)
        for _, e in pairs(entities) do
            if e.Type == EntityType.ENTITY_FAMILIAR and (e.Variant == FamiliarVariant.BLUE_FLY or e.Variant == FamiliarVariant.BLUE_SPIDER) then
                if e.Variant == FamiliarVariant.BLUE_FLY then
                    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FLY_EXPLOSION, e.Position, Vector(0,0), e, 0, mod:RandomPositive())
                elseif e.Variant == FamiliarVariant.BLUE_SPIDER then
                    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPIDER_EXPLOSION, e.Position, Vector(0,0), e, 0, mod:RandomPositive())
                end
                e:Remove()
            end
        end
    end
end

function mod:ApplyStats(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(flySwatter)
    if (cacheFlags & CacheFlag.CACHE_SHOTSPEED) == CacheFlag.CACHE_SHOTSPEED then
        local shotSpeedToAdd = 0.6 * itemCount
        player.ShotSpeed = player.ShotSpeed + shotSpeedToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.TearEffect)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.KillBugs)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.KillFamiliars)
local plantasia = Isaac.GetItemIdByName("Plantasia")
local vines = Isaac.GetEntityVariantByName("Plantasia Vines")

local SLOWDOWN_DURATION = 30
local IMMOBILE_DURATION = 100
local EFFECT_DURATION = SLOWDOWN_DURATION + IMMOBILE_DURATION

function mod:ApplyEffect(tear)
    local spawner = tear.SpawnerEntity
    if spawner then
        local player = spawner:ToPlayer()
        if player and player:HasCollectible(plantasia) then
            local x = math.random()
            local effectChance = math.max(math.min(math.ceil(player.Luck + 1) / 20, 0.3), 0.05)
            if x < effectChance then
                tear:GetData().isSeedTear = true
                tear:ChangeVariant(TearVariant.SPORE)
            end
        end
    end
end

function mod:AddVines(tear, enemy, _)
    if tear:GetData().isSeedTear and enemy:IsActiveEnemy(false) then
        if not enemy:GetData().PlantasiaTimer or enemy:GetData().PlantasiaTimer == 0 then
            enemy:GetData().PlantasiaTimer = EFFECT_DURATION
        end
    end
end

function mod:VineEffect(enemy)
    if enemy:GetData().PlantasiaTimer then
        local t = enemy:GetData().PlantasiaTimer
        if t > 0 then
            if t > IMMOBILE_DURATION then
                local s = (t - IMMOBILE_DURATION) / SLOWDOWN_DURATION
                enemy.Velocity = enemy.Velocity * s
            else
                enemy.Velocity = Vector(0, 0)
                if t == IMMOBILE_DURATION then
                    enemy:AddSlowing(EntityRef(Isaac.GetPlayer()), IMMOBILE_DURATION, 0, Color(1, 1, 1, 1, 0, 0, 0), false)
                    enemy:GetData().PlantasiaVines = Game():Spawn(EntityType.ENTITY_EFFECT, vines, enemy.Position, Vector(0,0), enemy, 0, mod:RandomPositive())
                end
            end
            enemy:GetData().PlantasiaTimer = t - 1
        elseif enemy:GetData().PlantasiaVines then
            enemy:GetData().PlantasiaVines:Die()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.ApplyEffect)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.AddVines)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.VineEffect)
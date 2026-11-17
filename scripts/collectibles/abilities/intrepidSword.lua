local intrepidSword = Isaac.GetItemIdByName("Intrepid Sword")

local activeToggle = 0

function mod:IntrepidSword()
    local roomType = Game():GetLevel():GetCurrentRoom():GetType()
    local levelStage = Game():GetLevel():GetStage()

    local function f(player)
        if player:HasCollectible(intrepidSword) then
            if roomType == RoomType.ROOM_BOSS
            or roomType == RoomType.ROOM_MINIBOSS
            or roomType == RoomType.ROOM_CHALLENGE
            or levelStage == LevelStage.STAGE8 then
                activeToggle = 1
            else
                activeToggle = 0
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    end
    mod:DoForAllPlayers(f)
end

function mod:ApplyDamage(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(intrepidSword)
        local damageMultiplier = 1.5^(itemCount * activeToggle)
        player.Damage = player.Damage * damageMultiplier
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyDamage)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.IntrepidSword)
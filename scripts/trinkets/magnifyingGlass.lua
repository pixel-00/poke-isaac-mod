local magnifyingGlass = Isaac.GetTrinketIdByName("Magnifying Glass")

function mod:MakeTiny()
    --local function f(player)
        --if player:HasTrinket(magnifyingGlass) then
            --local rng = player:GetTrinketRNG(magnifyingGlass)
            for _, entity in pairs(Isaac.GetRoomEntities()) do
                --local x = rng:RandomFloat()
                --local trinketMultiplier = player:GetTrinketMultiplier(magnifyingGlass)
                --local chance = trinketMultiplier / 3
                if entity:IsActiveEnemy() then
                    entity:ToNPC():MakeChampion(Game():GetRoom():GetSpawnSeed(), ChampionColor.TINY, false)
                    print("made tiny")
                end
            end
        --end
    --end

    --mod:DoForAllPlayers(f)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.MakeTiny)
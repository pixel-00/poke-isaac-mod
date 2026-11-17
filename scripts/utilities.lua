local json = require("json")

function mod:RandomPositive()
    local x = Random()

    if x == 0 then
        return 1
    else
        return x
    end
end

function mod:ToTearsPerSecond(maxFireDelay)
	return 30 / (maxFireDelay + 1)
end

function mod:ToMaxFireDelay(tearsPerSecond)
	return (30 / tearsPerSecond) - 1
end

function mod:GetAllPlayers()
    local numPlayers = Game():GetNumPlayers()
    local players = {}

    for i = 1, numPlayers do
        table.insert(players, Isaac.GetPlayer(i))
    end

    return players
end

function mod:GetPlayerIndex(player)
    return player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SAD_ONION):GetSeed()
end

function mod:GetPlayerFromIndex(index)
    local players = mod:GetAllPlayers()
    local player

    for i = 0, #players - 1 do
        local currentPlayer = Isaac.GetPlayer(i)
        if mod:GetPlayerIndex(currentPlayer) == index then
            player = currentPlayer
        end
    end

    return player
end

function mod:DoForAllPlayers(f)
    local numPlayers = Game():GetNumPlayers()

    for i = 1, numPlayers - 1 do
        f(Isaac.GetPlayer(i))
    end
end

function mod:SavePlayerData(player, key, value)
    local saveData = {}
    local index = mod:GetPlayerIndex(player)
    local playerTable = {}

    if mod:HasData() then
        local success, loadedData = pcall(json.decode, mod:LoadData())
        if success and type(loadedData) == "table" then
            saveData = loadedData
        end
    end

    if type(saveData[index]) == "table" then
        playerTable = saveData[index]
    end

    playerTable[key] = value
    saveData[index] = playerTable
    mod:SaveData(json.encode(saveData))
end

function mod:LoadPlayerData(player, key)
    local value

    if mod:HasData() then
        local success, loadedData = pcall(json.decode, mod:LoadData())
        local saveData = {}
        local playerTable = {}
        local index = mod:GetPlayerIndex(player)

        if success and type(loadedData) == "table" then
            saveData = loadedData
        end

        if type(saveData[index]) == "table" then
            playerTable = saveData[index]
        end

        value = playerTable[key]
    end
    
    return value
end
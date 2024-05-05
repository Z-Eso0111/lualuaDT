local DataStoreService = game:GetService("DataStoreService")
local moneyDataStore = DataStoreService:GetDataStore("LPData")
local name = game.ReplicatedStorage.VALUE.NAME.Value

local function loadData(player)
	local success, data = pcall(function()
		return moneyDataStore:GetAsync(tostring(player.UserId))
	end)

	if success then
		return data or 0
	else
		warn("Oyuncu verileri yüklenirken bir hata oluştu:", data)
		return 0
	end
end

local function saveData(player, money)
	local success, error = pcall(function()
		moneyDataStore:SetAsync(tostring(player.UserId), money)
	end)

	if success then
	else
		warn("Oyuncu verileri kaydedilirken bir hata oluştu:", error)
	end
end

local function onPlayerAdded(player)
	local leaderstats = nil
	repeat
		leaderstats = player:FindFirstChild("leaderstats")
		wait()
	until leaderstats

	local money = leaderstats:FindFirstChild("LP")
	if not money then
		money = Instance.new("NumberValue")
		money.Name = name
		local previousMoney = loadData(player)
		money.Value = previousMoney
		money.Parent = leaderstats
	end
end

local function onPlayerRemoving(player)
	local moneyValue = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("LP")
	if moneyValue then
		local money = moneyValue.Value
		saveData(player, money)
	end
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

game.Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in ipairs(game.Players:GetPlayers()) do
	onPlayerAdded(player)
end

while true do
	wait(10)
	for _, player in ipairs(game.Players:GetPlayers()) do
		local moneyValue = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("LP")
		if moneyValue then
			local money = moneyValue.Value
			saveData(player, money)
		end
	end
end

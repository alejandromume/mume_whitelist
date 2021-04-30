ESX, WhiteList = nil, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("mume_whitelist:fetchUserRank", function(source, cb)
	local player = ESX.GetPlayerFromId(source)

	if player ~= nil then
		local playerGroup = player.getGroup()

		if playerGroup ~= nil then 
			cb(playerGroup)
		else
			cb("user")
		end
	else
		cb("user")
	end
end)

function loadWhiteList(cb)
	Whitelist = {}

	MySQL.Async.fetchAll('SELECT identifier FROM whitelist', {}, function(result)
		for k,v in ipairs(result) do
			WhiteList[v.identifier] = true
			print(WhiteList[v.identifier])
		end
		if cb then
			cb()
		end
	end)
end

MySQL.ready(function()
	loadWhiteList()
end)

RegisterCommand("whreload", function(source, args)
    loadWhiteList()
end)

AddEventHandler('playerConnecting', function(name, setReason, deferrals)
	ExecuteCommand("whreload")
	local xPlayers = ESX.GetPlayers()
	deferrals.defer()
	local playerId, kickReason, identifier = source
	print(WhiteList[identifier])
	deferrals.update("Checking Player Name. Please Wait.")
	Citizen.Wait(100)

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			identifier = string.sub(v, 7)
			break
		end
	end
	if ESX.Table.SizeOf(WhiteList) == 0 then
		kickReason = "Whitelist without players"
	elseif not identifier then
		kickReason = "No steam detected!"
	elseif not WhiteList[identifier] then
		kickReason = Config.KickMessage
	end

	if #xPlayers < 0 then
		deferrals.done()
	else
		if kickReason then
			deferrals.done(kickReason)
		else
			deferrals.done()
		end
	end

end)
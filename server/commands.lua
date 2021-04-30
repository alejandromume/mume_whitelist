RegisterServerEvent('mume_whitelist:wrefresh')
AddEventHandler('mume_whitelist:wrefresh', function()
    loadWhiteList(function()
		print('Whitelist reloaded')
	end)
end)

RegisterServerEvent('mume_whitelist:wadd')
AddEventHandler('mume_whitelist:wadd', function(steamhex) 
    steamhexcode = steamhex:lower()

	if string.len(steamhexcode) <= 16 then
		if WhiteList[steamhexcode] then
			print('The player is already whitelisted on this server!')
		else
			MySQL.Async.execute('INSERT INTO whitelist (identifier) VALUES (@identifier)', {
				['@identifier'] = steamhexcode
			}, function(rowsChanged)
				WhiteList[steamhexcode] = true
				print('The player has been whitelisted!')
			end)
		end
	else
		print('Invalid license ID length!')
	end
end)

RegisterServerEvent('mume_whitelist:wremove')
AddEventHandler('mume_whitelist:wremove', function(steamhex) 
    steamhexcode = steamhex:lower()

	if string.len(steamhexcode) <= 16 then
		if WhiteList[steamhexcode] then
            MySQL.Async.execute('DELETE FROM whitelist WHERE whitelist.identifier = (@identifier)', {
				['@identifier'] = steamhexcode
			}, function(rowsChanged)
				WhiteList[steamhexcode] = true
				print('The player has been removed from whitelist!')
			end)
		else
            print('The player is already removed')
		end
	else
		print('Invalid license ID length!')
	end
end)
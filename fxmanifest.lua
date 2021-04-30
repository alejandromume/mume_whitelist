fx_version 'adamant'
game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/server.lua',
	'server/commands.lua',
	'config.lua',
}
client_scripts {
	'client/client.lua',
	'config.lua',
}

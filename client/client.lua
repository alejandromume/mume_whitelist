ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('chat:addSuggestion', '/whmenu', 'Export IP from players')

  function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
  end

RegisterCommand("whmenu", function(source, args)

    ESX.TriggerServerCallback("mume_whitelist:fetchUserRank", function(playerRank)
  
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then

            local elements = {}                     

            table.insert(elements, { label = "Add user to whitelist"})
            table.insert(elements, { label = "Remove user from whitelist"})
            table.insert(elements, { label = "Refresh whitelist"})

                --ESX.UI.Menu.CloseAll()

                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'tpmenu',
                        {
                            title    = 'Whitelist Menu',
                            align    = 'bottom-right',
                            elements = elements

                        },        function(data, menu)						--on data selection
                            if data.current.label == "Add user to whitelist" then

                                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
                                    title = "Steam Hex (ex. 110000114abde1d)"
                                }, function(data3, menu3)
                                    menu3.close()
                        
                                    TriggerServerEvent("mume_whitelist:wadd", data3.value)
                                    TriggerServerEvent("mume_whitelist:wrefresh")
                        
                                end, function(data3, menu3)
                                    menu3.close()
                                end)

                            elseif data.current.label == "Remove user from whitelist" then
                            
                                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
                                    title = "Steam Hex (ex. 110000114abde1d)"
                                }, function(data3, menu3)
                                    menu3.close()
                        
                                    TriggerServerEvent("mume_whitelist:wremove", data3.value)
                                    TriggerServerEvent("mume_whitelist:wrefresh")

                        
                                end, function(data3, menu3)
                                    menu3.close()
                                end)

                            elseif data.current.label == "Refresh whitelist" then

                                TriggerServerEvent("mume_whitelist:wrefresh")

                            end
                            menu.close()							--close menu after selection
                        end,
                        function(data, menu)
                            menu.close()
                        end
                        )
        else
            ShowNotification("~r~No Permissions")
        end
     end)
end)

RegisterCommand("whreload", function(source, args)
    TriggerServerEvent("mume_whitelist:wrefresh")
end)

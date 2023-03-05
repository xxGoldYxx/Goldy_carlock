local lockDistance = 15 

saved = false

Citizen.CreateThread(function()
    local dict = "anim@mp_player_intmenu@key_fob@"
	RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
end
	
RegisterNetEvent('lockLights')
AddEventHandler('lockLights',function()
local vehicle = saveVehicle
	SetVehicleLights(vehicle, 2)
	Wait (200)
	SetVehicleLights(vehicle, 0)
	Wait (200)
	SetVehicleLights(vehicle, 2)
	Wait (400)
	SetVehicleLights(vehicle, 0)
end)

RegisterKeyMapping('lock', '<font face="Fire Sans">(~o~VOZIDLO~w~) Zamknout vozidlo', 'keyboard', 'u') 
RegisterCommand("lock", function()
    local vehicle = saveVehicle
	local vehcoords = GetEntityCoords(vehicle)
	local coords = GetEntityCoords(PlayerPedId())
	local isLocked = GetVehicleDoorLockStatus(vehicle)
		if DoesEntityExist(vehicle) then
			if #(vehcoords - coords) < lockDistance then
				if (isLocked == 1) then
				PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SetVehicleDoorsLocked(vehicle, 2)
				exports['mythic_notify']:SendAlert('error', 'Vozidlo Zamčeno')
				TriggerEvent('lockLights')
				else
				PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SetVehicleDoorsLocked(vehicle,1)
				exports['mythic_notify']:SendAlert('success', 'Vozidlo Odemčeno')
				TriggerEvent('lockLights')
				end
			else
				exports['mythic_notify']:SendAlert('error', 'Jste příliš daleko od vozidla')
			end
		else
			exports['mythic_notify']:SendAlert('error', "Nemáte uložené žádné vozidlo")
		end
	end)
end) 

RegisterKeyMapping('ulozit', '<font face="Fire Sans">(~o~VOZIDLO~w~) Uložit vozidlo', 'keyboard', 'delete') 
RegisterCommand("ulozit",function()
	local player = PlayerPedId()
	  if (IsPedSittingInAnyVehicle(player)) then
			if saved == true then
			saveVehicle = nil
			exports['mythic_notify']:SendAlert('error', "Vozidlo odstraněno z uložených")
			saved = false
		else
			saveVehicle = GetVehiclePedIsIn(player,true)
			local vehicle = saveVehicle
			exports['mythic_notify']:SendAlert('success', "Vozidlo Uloženo")
			saved = true
		end
	end
end)

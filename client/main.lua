ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Licenses                = {}
local cJ = false
local IsPlayerUnjailed = false


Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx_ubezpieczenie:loadLicenses')
AddEventHandler('esx_ubezpieczenie:loadLicenses', function (licenses)
  for i = 1, #licenses, 1 do
    Licenses[licenses[i].type] = true
  end
end)

function OpenBuyLicenseMenu (zone)
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop_license',
    {
      title = _U('buy_license'),
      elements = {
        { label = ('Kup ubezpieczenie na 3 dni') .. ' ($' .. Config.LicensePrice1 .. ')', value = 'yes1' },
        { label = ('Kup ubezpieczenie na 7 dni') .. ' ($' .. Config.LicensePrice2 .. ')', value = 'yes2' },
        { label = ('Kup ubezpieczenie na 14 dni') .. ' ($' .. Config.LicensePrice3 .. ')', value = 'yes3' },
        { label = ('Cofnij'), value = 'no' },
      }
    },
    function (data, menu)
      if data.current.value == 'yes1' then
        TriggerServerEvent('esx_ubezpieczenie:buyLicense1')		
      end 
	  if data.current.value == 'yes2' then
        TriggerServerEvent('esx_ubezpieczenie:buyLicense2')	
      end 
	  if data.current.value == 'yes3' then
        TriggerServerEvent('esx_ubezpieczenie:buyLicense3')		
      end

      menu.close()
    end,
    function (data, menu)
      menu.close()
    end
  )
end



local Locations = {
	["~h~~b~[E] ~s~~g~ aby zobaczyć ubezpieczenia"] = {
        ["x"] = 308.24,
        ["y"] = -592.0,
        ["z"] = 43.28
    }
}

Citizen.CreateThread(function()

		while true do

			local sleepThread = 500

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			for locationId, v in pairs(Locations) do
				local distanceCheck = GetDistanceBetweenCoords(pedCoords, v["x"], v["y"], v["z"], true)

				if distanceCheck <= 5.0 then
					sleepThread = 5

					ESX.Game.Utils.DrawText3D(v, "" .. locationId, 0.5)

					if distanceCheck <= 2.0 then
                        if IsControlJustPressed(0, 38) then
                            OpenBuyLicenseMenu()
						end
					end					
				end
			end
			Citizen.Wait(sleepThread)
		end
	end)

--[[ Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	
	
      if IsControlJustReleased(0, 38) then
	  
          if Config.EnableLicense == true then
              OpenBuyLicenseMenu()
          end
      end


    end
end)]]

------------------- DODAWANIE UBEZPIECZENIA ----------------------


RegisterNetEvent("Ubezpieczenie1")
AddEventHandler("Ubezpieczenie1", function()
	local player = GetPlayerServerId(PlayerId())
	TriggerServerEvent('esx_ubezpieczenie:dodajubezpieczenie', player, 259200)
end)

RegisterNetEvent("Ubezpieczenie2")
AddEventHandler("Ubezpieczenie2", function()
	local player = GetPlayerServerId(PlayerId())
	TriggerServerEvent('esx_ubezpieczenie:dodajubezpieczenie', player, 604800)	
end)

RegisterNetEvent("Ubezpieczenie3")
AddEventHandler("Ubezpieczenie3", function()
	local player = GetPlayerServerId(PlayerId())
	TriggerServerEvent('esx_ubezpieczenie:dodajubezpieczenie', player, 1209600)
end)

------------------------ CZAS -------------------------

RegisterNetEvent("esx_ubezpieczenie:czasubezpieczenia")
AddEventHandler("esx_ubezpieczenie:czasubezpieczenia", function(JailTime)
	jailing(JailTime)
end)

function jailing(JailTime)
	if cJ == true then
		return
	end
	local PlayerPed = GetPlayerPed(-1)
	if DoesEntityExist(PlayerPed) then		
		Citizen.CreateThread(function()
			cJ = true
			IsPlayerUnjailed = false
			while JailTime > 0 do
				local remainingjailseconds = JailTime/ 60
				local jailseconds =  math.floor(JailTime) % 60 
				local remainingjailminutes = remainingjailseconds / 60
				local jailminutes =  math.floor(remainingjailseconds) % 60
				local remainingjailhours = remainingjailminutes / 24
				local jailhours =  math.floor(remainingjailminutes) % 24
				local remainingjaildays = remainingjailhours / 365 
				local jaildays =  math.floor(remainingjailhours) % 365
				Citizen.Wait(1000)
				JailTime = JailTime - 1.0
				if JailTime == 0 then
				local player = GetPlayerServerId(PlayerId())
				TriggerServerEvent('usunubezpieczenie', player)
				end
				end
			end)
			--
			cJ = false
		end
	end
RegisterNetEvent("usuwamubezpieczenie")
AddEventHandler("usuwamubezpieczenie", function()
	IsPlayerUnjailed = true
	TriggerServerEvent('esx_ubezpieczenie:removeLicense')
end)
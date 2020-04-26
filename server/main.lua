ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function LoadLicenses (source)
  TriggerEvent('esx_license:getLicenses', source, function (licenses)
    TriggerClientEvent('esx_weashop:loadLicenses', source, licenses)
  end)
end

if Config.EnableLicense == true then
  AddEventHandler('esx:playerLoaded', function (source)
    LoadLicenses(source)
  end)
end


------------------------UBEZPIECZENIE 3 DNI-----------------------------------

RegisterServerEvent('esx_ubezpieczenie:buyLicense1')
AddEventHandler('esx_ubezpieczenie:buyLicense1', function ()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.get('money') >= Config.LicensePrice1 then
    xPlayer.removeMoney(Config.LicensePrice1)
	
	
	TriggerClientEvent('Ubezpieczenie1', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kupiłeś ubezpieczenie', length = 6500})
    TriggerEvent('esx_license:addLicense', _source, 'ubezpieczenie', function ()
      LoadLicenses(_source)
    end)
  else
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Nie masz wystarczająco pieniędzy'})
  end
end)


------------------------UBEZPIECZENIE 7 DNI-----------------------------------


RegisterServerEvent('esx_ubezpieczenie:buyLicense2')
AddEventHandler('esx_ubezpieczenie:buyLicense2', function ()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.get('money') >= Config.LicensePrice2 then
    xPlayer.removeMoney(Config.LicensePrice2)

	TriggerClientEvent('Ubezpieczenie2', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kupiłeś ubezpieczenie', length = 6500})
    TriggerEvent('esx_license:addLicense', _source, 'ubezpieczenie', function ()
      LoadLicenses(_source)
    end)
  else
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Nie masz wystarczająco pieniędzy', length = 6500})
  end
end)


------------------------UBEZPIECZENIE 14 DNI-----------------------------------


RegisterServerEvent('esx_ubezpieczenie:buyLicense3')
AddEventHandler('esx_ubezpieczenie:buyLicense3', function ()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.get('money') >= Config.LicensePrice3 then
    xPlayer.removeMoney(Config.LicensePrice3)
	
	
	TriggerClientEvent('Ubezpieczenie3', source)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kupiłeś ubezpieczenie', length = 6500})
    TriggerEvent('esx_license:addLicense', _source, 'ubezpieczenie', function ()
      LoadLicenses(_source)
    end)
  else
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Nie masz wystarczająco pieniędzy', length = 6500})
  end
end)



------------------------------------USUWANIE UBEZPIECZENIA----------------------------

RegisterServerEvent('esx_ubezpieczenie:removeLicense')
AddEventHandler('esx_ubezpieczenie:removeLicense', function ()
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerEvent('esx_license:removeLicense', source, 'ubezpieczenie')
end)


----------------------CZAS --------------------
AddEventHandler('es:playerLoaded', function(source) 
  SetTimeout(20000, function()
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll('SELECT TIMESTAMPDIFF(SECOND, CURRENT_TIMESTAMP,czas) as timeleft, posiada as posiada from insurance where identifier =@id', {['@id'] = identifier}, function(result)
		if result[1] ~= nil then
					TriggerClientEvent("esx_ubezpieczenie:czasubezpieczenia", source, result[1].timeleft)
		end
	end)
  end)
end)

function round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

RegisterServerEvent("esx_ubezpieczenie:dodajubezpieczenie")
AddEventHandler("esx_ubezpieczenie:dodajubezpieczenie", function(playerid, jailtime)
	--calculate jailtime
	local remainingjailseconds = jailtime/ 60
	local jailseconds =  math.floor(jailtime) % 60 
	local remainingjailminutes = remainingjailseconds / 60
	local jailminutes =  math.floor(remainingjailseconds) % 60
	local remainingjailhours = remainingjailminutes / 24
	local jailhours =  math.floor(remainingjailminutes) % 24
	local remainingjaildays = remainingjailhours / 365 
	local jaildays =  math.floor(remainingjailhours) % 365
	
	--end calculate jailtime
	local identifier = GetPlayerIdentifiers(playerid)[1]
	local name = GetPlayerName(source)
	local id = GetPlayerIdentifiers(source)[1]
	local year = round(os.date('%Y'),0)
	local month = round(os.date('%m'),0)
	local day = round(os.date('%d')+jaildays,0)
	local hour = round(os.date('%H')+jailhours,0)
	local minutes =round(os.date('%M')+jailminutes,0)
	local seconds =round(os.date('%S')+jailseconds,0)
	if hour >= 24 then
		hour = hour - 24
		day = day +1
	end
	if ((month == 1 or month == 2 or month == 5 or month == 7 or month == 8 or month == 10 or month == 12) and day > 31) then
		month = month +1
		day = day -31
	elseif (month == 3 and day > 28) then
		month = month +1
		day = day -28
	elseif ((month == 4 or month == 6 or month == 9 or month == 11) and day > 30) then
		month = month +1
		day = day -30
	end
	
MySQL.Async.execute("INSERT INTO insurance (identifier,posiada,czas,nick,steamhex) VALUES (@identifier,@posiada,@czas,@nick,@JID) ON DUPLICATE KEY UPDATE identifier=@identifier,posiada=@posiada,czas=@czas, nick=@nick, steamhex=@JID", {['@identifier'] = identifier,['@posiada'] = true, ['@czas'] = year..'-'..month..'-'..day..' '..hour..':'..minutes..':'..seconds, ['@nick'] = name, ['@JID'] = id})			
TriggerClientEvent("esx_ubezpieczenie:czasubezpieczenia", playerid,jailtime)
end)

RegisterServerEvent("usunubezpieczenie")
AddEventHandler("usunubezpieczenie", function(playerid)
	local identifier = GetPlayerIdentifiers(playerid)[1]
	if GetPlayerName(playerid) ~= nil then
		TriggerClientEvent("usuwamubezpieczenie", playerid)
		MySQL.Async.execute("DELETE FROM insurance WHERE identifier=identifier", {['@identifier'] = identifier})
	end
end)

RegisterServerEvent("esx_jb_jailer:UnJailplayer2")
AddEventHandler("esx_jb_jailer:UnJailplayer2", function()
	local identifier = GetPlayerIdentifiers(source)[1]
	if GetPlayerName(source) ~= nil then
		TriggerClientEvent("usuwamubezpieczenie", source)
		MySQL.Async.execute("DELETE FROM insurance WHERE identifier=identifier", {['@identifier'] = identifier})
	end
end)

function dump(o, nb)
  if nb == nil then
    nb = 0
  end
   if type(o) == 'table' then
      local s = ''
      for i = 1, nb + 1, 1 do
        s = s .. "    "
      end
      s = '{\n'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
          for i = 1, nb, 1 do
            s = s .. "    "
          end
         s = s .. '['..k..'] = ' .. dump(v, nb + 1) .. ',\n'
      end
      for i = 1, nb, 1 do
        s = s .. "    "
      end
      return s .. '}'
   else
      return tostring(o)
   end
end


local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_jardineiro")
local servico = false
local locais = 0
local processo = false
local tempo = 0
local animacao = false
local capinar = {
	vector3(242.05116271973,-1281.8792724609,29.464897155762),
	vector3(242.61901855469,-1270.6221923828,29.466564178467),
	vector3(243.86114501953,-1257.9859619141,29.476234436035),
	vector3(93.392127990723,-1388.4722900391,29.467138290405),
	vector3(105.17505645752,-1392.1765136719,29.40966796875),
	vector3(110.65293884277,-1408.3483886719,29.391103744507),
	vector3(-57.515148162842,-1369.8317871094,29.53639793396),
	vector3(-44.153602600098,-1369.9793701172,29.537927627563),
	vector3(-31.075157165527,-1369.6086425781,29.527935028076),
	vector3(29.602684020996,-983.13073730469,29.587390899658),
	vector3(19.626079559326,-1520.8165283203,29.357860565186),
	vector3(23.445377349854,-1515.83203125,29.396953582764),
	vector3(31.587312698364,-1506.0467529297,29.407461166382),
	vector3(286.51794433594,-580.77911376953,43.378688812256),
	vector3(283.15939331055,-587.47467041016,43.378932952881),
	vector3( 280.91525268555,-593.61572265625,43.378932952881),
	vector3(373.77572631836,-221.16151428223,56.049724578857),
	vector3(375.75936889648,-212.33009338379,57.165630340576),
	vector3(382.77569580078,-189.48712158203,60.53279876709 )
}
local flor = {
	"prop_plant_fern_01b",
	"prop_cs_plant_01",
	"prop_plant_fern_01a",
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMPREGO ------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	blipmapa()
	while true do
		local ped = PlayerPedId()
		local trava = 1000
		local cordent = vector3(426.875,-400.84,47.88)
		local cordped = GetEntityCoords(ped)
		local distance = #(cordent-cordped)
		if not servico then
			if distance < 5 then
				trava = 1
				texto3d(426.875,-400.84,47.88+1.0,4,0.3,0.3,0,0,0,255,"~w~PRESSIONE ~g~[E] ~w~PARA PEGAR O SERVIÇO")
				if IsControlJustPressed(0, 38) then
					Fade(1000)
					spawntransporte()
					TriggerEvent("Notify","sucesso","Você acabou de pegar o emprego de JARDINEIRO")
					Wait(2000)
					TriggerEvent("Notify","sucesso","Agora pegue o veículo para trabalhar")
					locais = 1
					CriandoBlip(capinar,locais)
					cancelar()
					servico = true
				end
			end
		elseif servico then
			local car = GetHashKey("caddy")
			local vehicle = GetPlayersLastVehicle(ped, car)
			local veh = IsVehicleModel(vehicle, car)
			local usando = GetVehiclePedIsUsing(ped)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local cordcap = vector3(capinar[locais].x,capinar[locais].y,capinar[locais].z)
			local dista = #(cordcap-cordped)
			if dista < 10 then
				if veh and usando == 0 then
					if dista < 2 then
						trava = 1
						texto3d(x,y,z+1.0,4,0.3,0.3,0,0,0,255,"~w~PRESSIONE ~g~[E] ~w~PARA ~g~CAPINAR O LOCAL")
						if IsControlJustPressed(0, 38) then
							RemoveBlip(blips)
							animacao = true
							if animacao then
								florrw = math.random(#flor)
								vRP._playAnim(false,{{"amb@world_human_gardener_plant@female@idle_a","idle_a_female"}},true)
								vRP._CarregarObjeto("amb@world_human_gardener_plant@female@idle_a","idle_a_female",flor[florrw],50,28422, 0.0, 0, 0, 180.0, 0.0, 0.0)
								Desabilitar()
								Wait(7000)
								vRP.stopAnim(false)
								vRP._DeletarObjeto()
								emP.checkPayment()
								animacao = false
								if locais == #capinar then
									locais = 1
								else
									locais = math.random(#capinar)
								end
								CriandoBlip(capinar,locais)
							end
						end	
					end
				end
			end
		end
	Wait(trava)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
function cancelar()
	CreateThread(function()
		while true do
			Wait(5)
			if servico then
				if IsControlJustPressed(0,168) then
					RemoveBlip(blips)
					deleteCar(nveh)
					servico = false
				end
			else
				break
			end
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlip(capinar,locais)
	blips = AddBlipForCoord(capinar[locais].x,capinar[locais].y,capinar[locais].z)
	SetBlipSprite(blips,237)
	SetBlipColour(blips,31)
	SetBlipScale(blips,0.7)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Capine o local")
	EndTextCommandSetBlipName(blips)
end
function blipmapa()
  map = AddBlipForCoord(425.94, -399.24, 47.89)
  SetBlipSprite(map, 409)
  SetBlipColour(map, 60)
  SetBlipScale(map, 0.80)
  SetBlipAsShortRange(map, true)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentString('Central | Jardineiro')
  EndTextCommandSetBlipName(map)
end
function texto3d(x,y,z,font,e1,e2,r,g,b,a,texto)
  local screen,xt,yt = GetScreenCoordFromWorldCoord(x,y,z)
  if screen then
    SetTextFont(font)
    SetTextScale(e1,e2)
    SetTextColour(r,g,b,a)
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(texto)
    DrawText(xt,yt)
  end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR TECLAS -------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function Desabilitar()
	CreateThread(function()
		while true do
			Wait(1)
			if animacao then
				BlockWeaponWheelThisFrame()
				DisableControlAction(0,16,true)
				DisableControlAction(0,17,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,29,true)
				DisableControlAction(0,56,true)
				DisableControlAction(0,57,true)
				DisableControlAction(0,73,true)
				DisableControlAction(0,166,true)
				DisableControlAction(0,167,true)
				DisableControlAction(0,170,true)				
				DisableControlAction(0,182,true)	
				DisableControlAction(0,187,true)
				DisableControlAction(0,188,true)
				DisableControlAction(0,189,true)
				DisableControlAction(0,190,true)
				DisableControlAction(0,243,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,288,true)
				DisableControlAction(0,289,true)
				DisableControlAction(0,344,true)		
			end	
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PISCAR TELA --------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNAR CARRO ------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function spawntransporte()
	local mhash = "caddy"
	while not HasModelLoaded(mhash) do
			RequestModel(mhash)
			Wait(10)
	end
	local ped = PlayerPedId()
	local x,y,z = vRP.getPosition()
	nveh = CreateVehicle(mhash,413.41,-409.46,47.56+0.5,38.68,true,false)
	SetVehicleIsStolen(nveh,false)
	SetVehicleOnGroundProperly(nveh)
	SetEntityInvincible(nveh,false)
	SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
	SetVehicleHasBeenOwnedByPlayer(nveh,true)
	SetVehicleDirtLevel(nveh,0.0)
	SetVehRadioStation(nveh,"OFF")
	SetVehicleEngineOn(GetVehiclePedIsIn(ped,false),true)
	SetModelAsNoLongerNeeded(mhash)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETAR CARRO ------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function deleteCar( entity )
	Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NPC ----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local pedlist = {
	{ ['x'] = 426.875, ['y'] = -400.84, ['z'] = 47.88, ['h'] = 28.54, ['hash'] = 0x0DE9A30A, ['hash2'] = "s_m_m_ammucountry" },

}

CreateThread(function()
	for k,v in pairs(pedlist) do
		RequestModel(GetHashKey(v.hash2))

		while not HasModelLoaded(GetHashKey(v.hash2)) do
			Wait(100)
		end

		local ped = CreatePed(4,v.hash,v.x,v.y,v.z-1,v.h,false,true)
		FreezeEntityPosition(ped,true)
		SetEntityInvincible(ped,true)
		SetBlockingOfNonTemporaryEvents(ped,true)
	end
end)
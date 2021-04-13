local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_jardineiro",emP)

function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
        randmoney = (math.random(10,200))
	    vRP.giveMoney(user_id,parseInt(randmoney))
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b> pelo serviço.")
	end
end
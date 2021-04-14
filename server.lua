local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local terremoto = false
local tempo = nil

RegisterCommand('terremoto',function(source,args,rawCommand)
    local source = source 
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ceo.permissao") and terremoto == false then
	    if parseInt(args[1]) >= 1 then
	        terremoto = true
			tempo = parseInt(args[1])
			
			vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(15,15,15,0.8); border-bottom: 3px solid#3c9981; font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 5%; right: 10%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }","<bold>Terremoto em "..args[1].." minutos , prepare-se!!!!!</bold><br><br>Mensagem enviado(a) por: Poderoso_Castiga")
		    SetTimeout(10000,function()
			vRPclient.removeDiv(-1,"anuncio")
		    end)
			
			local users = vRP.getUsers()
            for k,v in pairs(users) do
                local id = vRP.getUserSource(parseInt(k))
                if id then
                    TriggerClientEvent("vrp_sound:source",id,'alert',0.5)
                end
            end
	    end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
        if terremoto then
		    if tempo then 
                tempo = parseInt(tempo - 1)
				
				vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(15,15,15,0.8); border-bottom: 3px solid#3c9981; font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 5%; right: 10%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }","<bold>Terremoto em "..tempo.." minutos , prepare-se!!!!!</bold><br><br>Mensagem enviado(a) por: Poderoso_Castiga")
		        SetTimeout(5000,function()
			    vRPclient.removeDiv(-1,"anuncio")
		        end)
				
				if tempo == 1 then 
				
				    local users = vRP.getUsers()
                    for k,v in pairs(users) do
                        local id = vRP.getUserSource(parseInt(k))
                        if id then
                            TriggerClientEvent("vrp_sound:source",id,'alert',0.5)
                        end
                    end
				end

			    if tempo == 0 then 
			        tempo = nil
					terremoto = false
                    local users = vRP.getUsers()
                    for k,v in pairs(users) do
                        local id = vRP.getUserSource(parseInt(k))
                        if id then
                            vRP.kick(id,"Você foi vitima do terremoto.")
                        end
					end
                end
			end
		end
	end
end)
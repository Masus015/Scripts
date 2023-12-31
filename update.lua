require "lib.moonloader"
local dlstatus = require("moonloader").downoload_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'

update_state = false

local script_vers = 1
local script_vers_text = "1"
local script_path = thisScript().path
local script_url = "https://raw.githubusercontent.com/Masus015/Scripts/main/update.lua"
local update_path = getWorkingDirectory() .. "/update.ini"
local update_url = "https://raw.githubusercontent.com/Masus015/Scripts/main/update.ini"


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand("update", cmd_update)

    downloadUrlToFile(update_url,update_path,function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateini = inicfg.load(nil, update_path)
            if tonumber(updateini.info.vers) > script_vers then 
                sampAddChatMessage("Íàéäåíî îáíîâëåíèå. Èäåò çàãðóçêà.",-1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)

    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url,script_path,function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Ñêðèïò óñïåøíî îáíîâëåí! Âåðñèÿ:" .. updateini.info.vers_text, -1)
                    thisScript():reload()
                end
            end)
            break
        end

    end
end



function cmd_update(arg)
    sampShowDialog(1000,"Ïðèâåòñòâèå v2.0","Ïðèâåòèê","Çàêðûòü","",0)
end

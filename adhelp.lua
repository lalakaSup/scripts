script_name("AHELP")
script_author("wlovem")
script_version_number(1)
script_dependencies("SAMPFUNCS, SAMP")

local q = require "samp.events"
require("lib.moonloader")
local tag = '{53a3a3}[AHelp]: {FFFFFF}'
local main_color = 0xFFFFFF
local inicfg = require 'inicfg'
local dlstatus = require('moonloader').download_status
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
require "lib.sampfuncs"
local fa = require 'faIcons'
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
local themes = import 'resource/imgui_themes.lua'
local notify = import 'resource/lib_imgui_notf.lua'
local keys = require 'vkeys'
local main_window_state = imgui.ImBool(false)
local second_window_state = imgui.ImBool(false)
local jailwind = imgui.ImBool(false)
local mousewind = imgui.ImBool(false)
local specwind2 = imgui.ImBool(false)
local banwind = imgui.ImBool(false)
local nakazwind = imgui.ImBool(false)
local chlogwind = imgui.ImBool(false)
local mutetime = imgui.ImBool(false)
local main2 = imgui.ImBool(false)
local reportwind = imgui.ImBool(false)
local descwind = imgui.ImBool(false)
local skinc = imgui.ImBool(false)
local sprav = imgui.ImBool(false)
local deadwind = imgui.ImBool(false)
local speccheckwind = imgui.ImBool(false)
local information = imgui.ImBool(false)
local arr_fractls = {'1 PD', '2 ARMY', '3 EMS', '4 NEWS', '6 TAxI', '7 FBI'}
local arr_fractsf = {'8 PD', '9 ARMY', '10 EMS', '11 NEWS', '13 TAxI', '14 FBI'}
local arr_fractlv = {'15 PD', '16 ARMY', '17 EMS', '18 NEWS', '20 TAxI', '21 FBI'}
local fractlscombo  = imgui.ImInt(0)
local fractsfcombo  = imgui.ImInt(0)
local fractlvcombo  = imgui.ImInt(0)
local skinpng = {}
local MODEL = 0
local settingsi = imgui.ImBool(false)
frall = false
avinfon = false

local Config = inicfg.load({
	Settings = {
		amessini = false,
		achatini = false,
		AdmInvis = false,
		AutoGodMod = false,
        ChlogHelp = false,
        DescHelp = false,
        JailHelp = true,
        AutoGhost = false,
        IdKillList = false,
        ServerCarHeal = false,
        AutoUnd = false,
        ServerFlipCar = true,
        GM1 = false,
        SpecPlayerCheck = true,
        NotifyRep = false,
        RepColor = 'c46caa',
        ACHColor = '1f9137',
        Colors = false,
        Theme = 1,
	}
}, 'ahelp.ini')
inicfg.save(Config, 'ahelp.ini')
update_state = false

local script_vers = 23
local script_vers_text = "11.00"

local update_url = "https://raw.githubusercontent.com/lalakaSup/scripts/main/update.ini" 
local update_path = getWorkingDirectory() .. "/update.ini" 

local script_url = "https://github.com/lalakaSup/scripts/blob/main/adhelp.luac?raw=true" 
local script_path = thisScript().path

local tbuffer = imgui.ImBuffer(256)

local inv = imgui.ImBool(Config.Settings.AdmInvis)
local specstat = false
local check1 = imgui.ImBool(Config.Settings.achatini)
local check2 = imgui.ImBool(Config.Settings.amessini)
local agm = imgui.ImBool(Config.Settings.AutoGodMod)
local desch = imgui.ImBool(Config.Settings.DescHelp)
local chlogh = imgui.ImBool(Config.Settings.ChlogHelp)
local jailh = imgui.ImBool(Config.Settings.JailHelp)
local ghost = imgui.ImBool(Config.Settings.AutoGhost)
local idkl = imgui.ImBool(Config.Settings.IdKillList)
local cheal = imgui.ImBool(Config.Settings.ServerCarHeal)
local autou = imgui.ImBool(Config.Settings.AutoUnd)
local GMped = imgui.ImBool(Config.Settings.GM1)
local speccheck = imgui.ImBool(Config.Settings.SpecPlayerCheck)
local nrep = imgui.ImBool(Config.Settings.NotifyRep)

local ffi = require 'ffi'
local memory = require 'memory'

ffi.cdef[[
struct stKillEntry
{
	char					szKiller[25];
	char					szVictim[25];
	uint32_t				clKillerColor; // D3DCOLOR
	uint32_t				clVictimColor; // D3DCOLOR
	uint8_t					byteType;
} __attribute__ ((packed));

struct stKillInfo
{
	int						iEnabled;
	struct stKillEntry		killEntry[5];
	int 					iLongestNickLength;
  	int 					iOffsetX;
  	int 					iOffsetY;
	void			    	*pD3DFont; // ID3DXFont
	void		    		*pWeaponFont1; // ID3DXFont
	void		   	    	*pWeaponFont2; // ID3DXFont
	void					*pSprite;
	void					*pD3DDevice;
	int 					iAuxFontInited;
    void 		    		*pAuxFont1; // ID3DXFont
    void 			    	*pAuxFont2; // ID3DXFont
} __attribute__ ((packed));
]]

function imgui.BeforeDrawFrame()
  if fa_font == nil then
    local font_config = imgui.ImFontConfig()
    font_config.MergeMode = true
    fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
  end
end

function main()
  repeat wait(0) until isSampAvailable()

  kill = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())


  sampRegisterChatCommand('user', userinfo)
  sampRegisterChatCommand('getinf', getinfo)
  sampRegisterChatCommand('setinf', setinfo)
  sampRegisterChatCommand('newa', newa)
  sampRegisterChatCommand('ah', imgcmd)
  sampRegisterChatCommand('adh', adcmdhelp)
  sampRegisterChatCommand('ahelp', cmdhelp)
  sampRegisterChatCommand('g', gotocmd)
  sampRegisterChatCommand('avinfo', avinfo)

  if not doesDirectoryExist("moonloader\\config\\peds") then
        createDirectory("moonloader\\config\\peds")
  end
  for i = 0, 311, 1 do
        if not doesFileExist("moonloader\\config\\peds\\skin_" .. i .. ".png") then
            downloadUrlToFile("https://kak-tak.info/wp-content/uploads/2020/05/skin_" .. i .. ".png", "moonloader\\config\\peds\\skin_" .. i .. ".png", function (id, status, p1, p2)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    print("[Skinc] {FFFFFF}Загружен файл Skin_" ..i.. ".png")
                end
            end)
        end
        skinpng[i] = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\config\\peds\\skin_" .. i .. ".png")
  end

  downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                update_state = true
            end
            os.remove(update_path)
        end
  end)

  result, my1id = sampGetPlayerIdByCharHandle(PLAYER_PED)
  clientName = sampGetPlayerNickname(my1id)
  if clientName == not Bertram_Barlome then
    sampAddChatMessage('Для ника '..clientName..' доступа нет, пишите vk.com/wlovem')
    thisScript():unload()
  end

  while true do
    wait(0)
   
    
   
    if Config.Settings.GM1 then
        setCharProofs(PLAYER_PED, true, true, true, true, true)
    else
        setCharProofs(PLAYER_PED, false, false, false, false, false)
    end

    MYX1, MYY1, MYZ1 = getCharCoordinates(PLAYER_PED)
    if avinfon then 
        local vy = MYZ1
        local vy = vy+7
        sampSendChat('/vinfo')
        setCharCoordinates(PLAYER_PED, MYX1, MYY1, vy)
        wait(300)
    end

    if povodstat then
        boolffff, IX, IY, IZ = sampGetStreamedOutPlayerPos(IID)
        if IX > MYX1+10 or IY > MYY1+10 or IZ > MYZ1+10 then 
            sampSendChat('/gethere '..IID)
            wait(1000)
            sampAddChatMessage(IX..' '..IY..' '..IZ, -1)
        end
    end

    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid and isKeyJustPressed(VK_1) then
	    local result, idT = sampGetPlayerIdByCharHandle(ped)
		if result and not sampIsPlayerPaused(idT) then
			sampSendChat('/slap '..idT)
		end
	end

    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid and isKeyJustPressed(VK_4) then
	    local result, idT = sampGetPlayerIdByCharHandle(ped)
		if result and not sampIsPlayerPaused(idT) then
			sampSendChat('/freeze '..idT)
		end
	end

    if valid and isKeyJustPressed(VK_2) then
	    local result, idT = sampGetPlayerIdByCharHandle(ped)
		if result and not sampIsPlayerPaused(idT) then
			sampSendChat('/re '..idT)
            specstat = true
		end
	end

    if valid and isKeyJustPressed(VK_3) then
	    local result, idT = sampGetPlayerIdByCharHandle(ped)
		if result and not sampIsPlayerPaused(idT) then
			sampSendChat('/sethp '..idT..' 100')
		end
	end

    if valid and isKeyJustPressed(VK_F) and minepizd then
	    local result, idT = sampGetPlayerIdByCharHandle(ped)
		if result and not sampIsPlayerPaused(idT) then
			sampSendChat('/mine '..idT)
		end
	end

    if sampIsDialogActive() then
			activation = true 
    end
	

    if valid and isKeyJustPressed(VK_LBUTTON) and minepizd then
	    local result, idT = sampGetPlayerIdByCharHandle(ped)
		if result and not sampIsPlayerPaused(idT) then
			sampSendChat('/gethere '..idT)
		end
	end

    if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
    end

    if not sampIsChatInputActive() then
      if isKeyDown(VK_MENU) and isKeyJustPressed(VK_0) then
        if specstat then
          sampSendChat('/slap '..idspec)
        end
      end
      if not specstat then
            if isKeyJustPressed(VK_ESCAPE) then
                if chlog then
                    chlogwind.v = false 
                    mutetime.v = false
                    imgui.Process = false
                    chlog = false
                end
                if desc then 
                    descwind.v = false 
                    imgui.Process = false 
                    desc = false
                end
            end
      end

      if Config.Settings.ServerCarHeal then
        local car, hpcar
        if isCharInAnyCar(playerPed) then
            car = storeCarCharIsInNoSave(playerPed)
            hpcar = getCarHealth(car) 
            if hpcar < 500 then
                sampSendChat('/rpc')
                wait(1000)
            end
        end
      end

      if Config.Settings.ServerFlipCar then
        if isCharInAnyCar(playerPed) then
            if isKeyJustPressed(VK_C) then
                local result, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                sampSendChat('/flip '..myid)
            end
        end
      end

      if isKeyJustPressed(VK_RETURN) then 
        wait(1000)
        if lsinvitestat then
            sampSendChat('/infract '..lsfract)
            lsinvitestat = false
        end
        if sfinvitestat then
            sampSendChat('/infract '..sffract)
            sfinvitestat = false
        end
        if lvinvitestat then
            sampSendChat('/infract '..lvfract)
            lvinvitestat = false
        end
      end

      if isKeyJustPressed(VK_N) then
        if specstat then
          sampSendChat('/reoff')
          specstat = false
        end
      end
      if isKeyDown(VK_MENU) and isKeyJustPressed(VK_B) then
        if inv.v then
          Onfoot_Invis1 = not Onfoot_Invis1
          if Onfoot_Invis1 then
            notify.addNotify('Невидимка', '{00FF00}Включено', 2, 1, 3)
            Onfoot_Invis = true
          else
            mycordinv()
            Onfoot_Invis = false
            wait(200)
            sampSendChat('/re 15')
            wait(50)
            sampSendChat('/reoff')
            notify.addNotify('Невидимка', '{FF0000}Выключено', 2, 1, 3)
          end
        end
      end
      if Config.Settings.JailHelp then
          if isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
            if idk and nickj1 and nickk then
              if sampIsPlayerConnected(idk) then
                sampSendChat('/dhist '..nickk)
                wait(1000)
                makeScreenshot()
              end
            else
              sampAddChatMessage(tag..'Репортов не было.')
            end
          end

          if isKeyDown(VK_MENU) and isKeyJustPressed(VK_U) then
            if idk and nickj1 and nickk then
              if sampIsPlayerConnected(idk) then
                sampSendChat('/chlog '..nickk)
                wait(500)
                makeScreenshot()
                rabota = true
              end
            else
              sampAddChatMessage(tag..'Репортов не было.')
            end
          end
      

          if isKeyDown(VK_MENU) and isKeyJustPressed(VK_I) then
            if rabota then
                reportofj = not reportofj
                if reportofj then
                    autojnickk = nickk
                    notify.addNotify('Автовыдача наказаний', '{00FF00}Включено', 2, 1, 3)
                else
                    notify.addNotify('Автовыдача наказаний', '{FF0000}Выключено', 2, 1, 3)
                end
            end
          end

          if isKeyJustPressed(VK_Y) then
            if aviajail then
                    sampSendChat('/jail '..nickaviaj..' 11')
                    avifjail = false
            end
            if rabota and reportotj then
                sampSendChat('/jail '..nickk..' 1')
                wait(1000)
                makeScreenshot()
                if not jailed then
                    sampSendChat('/ames '..nickj1..' jail')
                end
                rabota = false
                jailed = false
                reportotj = false
            end
          end
      end

      if isKeyDown(VK_MENU) and isKeyJustPressed(VK_X) then
        main2.v = not main2.v
        imgui.Process = main2.v
        mainwindow = not mainwindow
      end

      if specstat then

        if isKeyJustPressed(VK_RBUTTON) then
          second_window_state.v = not second_window_state.v
          imgui.Process = not imgui.Process
          nakazwind.v = not nakazwind.v
        end
      end
    end
  end
end

function userinfo()
    sampAddChatMessage(clientName, -1)
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if updateIni.users.user1 == clientName then 
            sampAddChatMessage('1', -1)
            end
        end
    end)
end

sampRegisterChatCommand('mycord', function()
    MYX, MYY, MYZ = getCharCoordinates(playerPed)
    sampAddChatMessage(MYX..' '..MYY..' '..MYZ, -1)
end)

sampRegisterChatCommand('amodel', function(arg)
    arg1, arg2 = arg:match('(.+) (.+)')
    MYX, MYY, MYZ = getCharCoordinates(playerPed)
    if arg1 == '1' then
        setCharCoordinates(PLAYER_PED, 1113.6, 1333.7, 10.8) 
    elseif arg1 == '2' then
        setCharCoordinates(PLAYER_PED, 1115.8, 1321.8, 10.8) 
    elseif arg1 == '3' then 
        setCharCoordinates(PLAYER_PED, 1114.5, 1311.6, 10.8) 
    elseif arg1 == '4' then
        setCharCoordinates(PLAYER_PED, 1114.5, 1311.6, 10.8) 
    elseif arg1 == '5' then
        setCharCoordinates(PLAYER_PED, 1114.2, 1296.8, 10.8) 
    elseif arg1 == '6' then
        setCharCoordinates(PLAYER_PED, 1113.0, 1282.1, 10.8) 
    elseif arg1 == '7' then
        setCharCoordinates(PLAYER_PED, 1111.1, 1267.1, 10.8)
    end
    lua_thread.create(function()          
        wait(1000)
        sampSendChat('/model '..arg2)
        wait(2000)
        sampSendChat('/ic')
        wait(1000)
        setCharCoordinates(PLAYER_PED, MYX, MYY, MYZ)
    end)
end)

function imgui.ButtonActivated(activated, ...)
	if activated then
		imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.ButtonActive])
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.ButtonActive])
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.ButtonActive])
		
			imgui.Button(...)
			
		imgui.PopStyleColor()
		imgui.PopStyleColor()
		imgui.PopStyleColor()
		
	else
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
		
			local result = imgui.Button(...)
			
		imgui.PopStyleColor()
		imgui.PopStyleColor()
		imgui.PopStyleColor()
		
		return result
	end
end

function apply_custom_style()
   imgui.SwitchContext()
   local style = imgui.GetStyle()
   local colors = style.Colors
   local clr = imgui.Col
   local ImVec4 = imgui.ImVec4
   local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 15.0
    style.FramePadding = ImVec2(5, 5)
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 15.0
    style.GrabMinSize = 15.0
    style.GrabRounding = 7.0
    style.ChildWindowRounding = 8.0
    style.FrameRounding = 6.0
  

            colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 0.78)
            colors[clr.TextDisabled]         = ImVec4(1.00, 1.00, 1.00, 1.00)
            colors[clr.WindowBg]             = ImVec4(0.11, 0.15, 0.17, 1.00)
            colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
            colors[clr.Border]               = ImVec4(0.43, 0.43, 0.50, 0.50)
            colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.FrameBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
            colors[clr.FrameBgHovered]       = ImVec4(0.12, 0.20, 0.28, 1.00)
            colors[clr.FrameBgActive]        = ImVec4(0.09, 0.12, 0.14, 1.00)
            colors[clr.TitleBg]              = ImVec4(0.53, 0.20, 0.16, 0.65)
            colors[clr.TitleBgActive]        = ImVec4(0.56, 0.14, 0.14, 1.00)
            colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.00, 0.00, 0.51)
            colors[clr.MenuBarBg]            = ImVec4(0.15, 0.18, 0.22, 1.00)
            colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.39)
            colors[clr.ScrollbarGrab]        = ImVec4(0.20, 0.25, 0.29, 1.00)
            colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
            colors[clr.ScrollbarGrabActive]  = ImVec4(0.09, 0.21, 0.31, 1.00)
            colors[clr.ComboBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
            colors[clr.CheckMark]            = ImVec4(1.00, 0.28, 0.28, 1.00)
            colors[clr.SliderGrab]           = ImVec4(0.64, 0.14, 0.14, 1.00)
            colors[clr.SliderGrabActive]     = ImVec4(1.00, 0.37, 0.37, 1.00)
            colors[clr.Button]               = ImVec4(0.20, 0.25, 0.29, 1.00)
            colors[clr.ButtonHovered]        = ImVec4(0.69, 0.15, 0.15, 1.00)
            colors[clr.ButtonActive]         = ImVec4(0.67, 0.13, 0.07, 1.00)
            colors[clr.Header]               = ImVec4(0.20, 0.25, 0.29, 0.55)
            colors[clr.HeaderHovered]        = ImVec4(0.98, 0.38, 0.26, 0.80)
            colors[clr.HeaderActive]         = ImVec4(0.98, 0.26, 0.26, 1.00)
            colors[clr.Separator]            = ImVec4(0.50, 0.50, 0.50, 1.00)
            colors[clr.SeparatorHovered]     = ImVec4(0.60, 0.60, 0.70, 1.00)
            colors[clr.SeparatorActive]      = ImVec4(0.70, 0.70, 0.90, 1.00)
            colors[clr.ResizeGrip]           = ImVec4(0.26, 0.59, 0.98, 0.25)
            colors[clr.ResizeGripHovered]    = ImVec4(0.26, 0.59, 0.98, 0.67)
            colors[clr.ResizeGripActive]     = ImVec4(0.06, 0.05, 0.07, 1.00)
            colors[clr.CloseButton]          = ImVec4(0.40, 0.39, 0.38, 0.16)
            colors[clr.CloseButtonHovered]   = ImVec4(0.40, 0.39, 0.38, 0.39)
            colors[clr.CloseButtonActive]    = ImVec4(0.40, 0.39, 0.38, 1.00)
            colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
            colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
            colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
            colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
            colors[clr.TextSelectedBg]       = ImVec4(0.25, 1.00, 0.00, 0.43)
            colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

function apply_custom_style2()
	-- dark v0.1
 
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

 
	--style.WindowPadding = ImVec2(10, 10)
	--style.FramePadding = ImVec2(0, 0) -- размеры елементов
	style.WindowRounding = 6.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 4.0
	style.ItemSpacing = imgui.ImVec2(10.0, 10.0)
	--style.ItemInnerSpacing = ImVec2(8, 6)
	--style.IndentSpacing = 25.0
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0
	
	-- Кнопки
	colors[clr.Button] = ImVec4(0.07, 0.07, 0.07, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.11, 0.11, 0.11, 1.00)
	colors[clr.ButtonActive] = colors[clr.ButtonHovered]

	-- Галочка, tooltip
	colors[clr.CheckMark] = ImVec4(0.50, 0.10, 0.00, 1.00)
	
	-- Selectable
	colors[clr.HeaderHovered] = colors[clr.ButtonHovered]
	colors[clr.HeaderActive] = colors[clr.ButtonActive]
	colors[clr.Header] = colors[clr.Button] -- Выделенный
	
	-- Текст
	colors[clr.Text] = ImVec4(0.80, 0.80, 0.80, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.40, 0.40, 0.40, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.20, 0.07, 0.00, 1.00)
	
	-- Фон заголовока
	colors[clr.TitleBgActive] = ImVec4(0.00, 0.00, 0.00, 0.96) -- сравнимо с прозрачностью чата
	colors[clr.TitleBg] = colors[clr.TitleBgActive]
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	
	-- Фон меню
	colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	
	-- Фон окна
	colors[clr.WindowBg] = colors[clr.TitleBgActive]
	colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.PopupBg] = ImVec4(0.00, 0.00, 0.00, 1.00)
	
	

	colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	
	
	colors[clr.Separator] = colors[clr.Border]
	colors[clr.SeparatorHovered] = colors[clr.Border]
	colors[clr.SeparatorActive] = colors[clr.Border]


	

	colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)

	

	colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab] = colors[clr.Button]
	colors[clr.ScrollbarGrabHovered] = colors[clr.ButtonHovered]
	colors[clr.ScrollbarGrabActive] = colors[clr.ButtonActive]

	colors[clr.FrameBg] = colors[clr.Button]
	colors[clr.FrameBgHovered] = colors[clr.ButtonHovered]
	colors[clr.FrameBgActive] = colors[clr.ButtonActive]

	colors[clr.ComboBg] = ImVec4(0.35, 0.35, 0.35, 1.00)

	

	colors[clr.ResizeGrip] = colors[clr.Button]
	colors[clr.ResizeGripHovered] = colors[clr.ButtonActive]
	colors[clr.ResizeGripActive] = colors[clr.ButtonActive]

	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = imgui.ImVec4(0.50, 0.25, 0.00, 1.00)
	colors[clr.CloseButtonActive] = colors[clr.CloseButtonHovered]

	colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)

	colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)

	

	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

if Config.Settings.Theme == 1 then
    apply_custom_style()
elseif Config.Settings.Theme == 2 then
    apply_custom_style2()
end

sampRegisterChatCommand('osk', function(arg)
	sampSendChat('/ban R '..arg..' osk')
end)



function makeScreenshot(disable) -- если передать true, интерфейс и чат будут скрыты
    if disable then displayHud(false) sampSetChatDisplayMode(0) end
    require('memory').setuint8(sampGetBase() + 0x119CBC, 1)
    if disable then displayHud(true) sampSetChatDisplayMode(2) end
end

function q.onSendCommand(command)
  if command == '/reoff' then
    second_window_state.v = false
    imgui.Process = second_window_state.v
    specstat = false
  end
  if command == '/uoff' then
    second_window_state.v = false
    imgui.Process = second_window_state.v
    specstat = false
  end
end

function q.onServerMessage(color, text)
  
  if fractspec then
    if text:find('Члены (.+) онлайн, всего (.+) человек:') then
        fractspecname, fractspeconline = text:match('Члены (.+) онлайн, всего (.+) человек:')
        sampAddChatMessage('онлайн - '..fractspeconline, -1)
    end
  end

  if lsinvitestat or lvinvitestat or sfinvitestat then
    if text:find('Вы уже состоите во фракции.') then 
        main2.v = false
        imgui.Process = false
        mainwindow = false
        sampSendChat('/leave')
    end
  end

  if checkinf then
    if text:find('С Т А Т И С Т И К А  И Г Р О К А') then
        return false
    end
    if text:find('*** (.+) ***') then
        return false
    end
    if text:find('Уровень: %[(%d+)%] Пол: %[(.+)%] Сумма на руках: %[(.+)%] Счет в банке: %[(.+)%] Телефон: %[(.+)%]') then
        speclvl1, specpol, specmoney, specbmoney, specphone = text:match('Уровень: %[(.+)%] Пол: %[(.+)%] Сумма на руках: %[(.+)%] Счет в банке: %[(.+)%] Телефон: %[(.+)%]')
        return false
    end
    if text:find('Время в игре: %[(.+)%] Рабочая лицензия: %[(.+)%] Стиль боя: %[(.+)%] UID: %[(.+)%]') then
        spectimeingame, speclic, specfightstyle, specuid = text:match('Время в игре: %[(.+)%] Рабочая лицензия: %[(.+)%] Стиль боя: %[(.+)%] UID: %[(.+)%]')
        return false
    end
    if text:find('Преступления: %[(.+)%] Сроки в тюрьме: %[(.+)%] Смерти при задержании: %[(.+)%] Розыск: %[(.+)%] Предупреждения: %[(.+)%]') then
        speccrime, speczjail, speczkill, specwanted, specwarns = text:match('Преступления: %[(.+)%] Сроки в тюрьме: %[(.+)%] Смерти при задержании: %[(.+)%] Розыск: %[(.+)%] Предупреждения: %[(.+)%]')
        return false
    end
    if text:find('Убийства: %[(.+)%] Смерти: %[(.+)%] Очки опыта: %[(.+)%] Квестпоинты: %[(.+)%] Тип аккаунта: %[(.+)%]') then
        speckills, specdead, specpoints, specqpoints, specacc = text:match('Убийства: %[(.+)%] Смерти: %[(.+)%] Очки опыта: %[(.+)%] Квестпоинты: %[(.+)%] Тип аккаунта: %[(.+)%]')
        return false
    end
    if text:find('Организация: %[(.+)%] Ранг: %[(.+)%]') then
        specfract, specfractrank = text:match('Организация: %[(.+)%] Ранг: %[(.+)%]')
        return false
    end
    if text:find('Место жительства: %[(.+)%]') then
        speclive = text:match('Место жительства: %[(.+)%]')
        return false
    end
  end
  
  if amess or check2.v then
    if string.find(text, "W: ", 1, true) then return false end
    if string.find(text, "A:", 1, true) then return false end
    if string.find(text, "Жалоба от ", 1, true) then return false end
    if string.find(text, "[Новая заявка]", 1, true) then return false end
    if string.find(text, "AM: ", 1, true) then return false end
    if string.find(text, "AA: ", 1, true) then return false end
    if string.find(text, "RQ:", 1, true) then return false end
    if string.find(text, "А:", 1, true) then return false end
    if string.find(text, "AA:", 1, true) then return false end
    if string.find(text, "[Новая", 1, true) then return false end
    if string.find(text, "[IP", 1, true) then return false end
    if string.find(text, "A offline:", 1, true) then return false end
  end

  if not Onfoot_Invis1 then
    if string.find(text, 'Режим наблюдения ', 1, true) then return false end
  end

  if achat or check1.v then
    if string.find(text, "[A] ", 1, true) then return false end
  end

  if descwind.v then
    if text:find('Для этого персонажа не установлено описания.') then 
        if nextd then
            sampSendChat('/gd '..idd+1)
            idd = idd+1
        end
        if prewd then
            sampSendChat('/gd '..idd-1)
            idd = idd-1
        end
    end
  end
  
  if string.find(text, "[Радио ", 1, true) then return false end

  if rangg then
    if text:find('Указанный вами номер ранга выше максимально допустимого в этой фракции.') then
        rang = rang-1
        sampSendChat('/fractrank '..rang)
    end
  end

  if text:find('Игрок .+ покинул сервер, режим наблюдения автоматически выключен.') then
    second_window_state.v = false
    imgui.Process = second_window_state.v
    specstat = false
  end

  if Config.Settings.AutoGodMod then 
    if text:find('С возвращением, вы успешно вошли в свой аккаунт.') then
        sampSendChat('/agm')
    end
  end

  if Config.Settings.AutoGhost then 
    if text:find('С возвращением, вы успешно вошли в свой аккаунт.') then
        sampSendChat('/ghost')
    end
  end

  if text:find('Указанный вами игрок уже отбывает наказание в админ тюрьме.') then 
    jailed = true
  end

  if text:find('W: (.+) %[ID (.+)%] по заявлению (.+) обвинен в: Умышленное убийство.') then
      if Config.Settings.JailHelp then
        nickk, idk, nickj1 = text:match('W: (.+) %[ID (%d+)%] по заявлению (.+) обвинен в: Умышленное убийство.')
        sampAddChatMessage(tag..''..nickk..' ID '..idk..' убил '..nickj1..' Дхист - ALT + Y, Чатлог - ALT + U')
      end
  end

  if avinfon then
    if text:find('Поблизости нет транспортных средств.') then return false end
    if text:find('Последний водитель: (.+).') then
        nickaviaj = text:match('Последний водитель: (.+).')
        avinfon = false
        aviajail = true
        if aviajail then
            lua_thread.create(function() 
                wait(5000)
                aviajail = false
            end)
        end
    end
  end

  if Config.Settings.Colors then
      if text:find("Жалоба ") then
        text = '{'..Config.Settings.RepColor..'}'..text
      end

      if text:find("А: От ") then
        text = '{'..Config.Settings.RepColor..'}'..text
      end

      if text:find("%[A%] (.+)") then
        text = '{'..Config.Settings.ACHColor..'}'..text
      end
  end

  if text:find("Жалоба от (.+) %[ID (%d+)%]: (.+)") then
    nickj2, idj2, report = text:match("Жалоба от (.+) %[ID (%d+)%]: (.+)")
    if Config.Settings.JailHelp then
        if nickj2 == nickj1 then
          if reportofj then
            sampAddChatMessage(tag..'Автоматически посажен')
            reportofj = false
          else
            text = '{fa3249}[J - '..idk..'] '..text..'{fa3249} - РЕПОРТ ОТ ЖЕРТВЫ'
            reportotj = true
            lua_thread.create(function()          
                wait(5000)
                reportotj = false
            end)
          end
        end
    end
  end

  return {color, text}
end

sampRegisterChatCommand('pizdamine', function()
    minepizd = not minepizd
    if minepizd then
        sampAddChatMessage(tag..'Убица включена')
    else
         sampAddChatMessage(tag..'Убица выключена')
    end
end)

function gotocmd(arg)
  sampSendChat('/goto ' .. arg)
end

sampRegisterChatCommand('gh', function(arg)
	sampSendChat('/gethere '..arg)
end)

sampRegisterChatCommand('ad', function(id)
  if tonumber(id) then
    if sampIsPlayerConnected(id) then
      nickname = sampGetPlayerNickname(tonumber(id))
      idad = tonumber(id)
    else
      sampAddChatMessage(tag .. 'Игрока не обнаружено на сервере', -1)
    end
  else
    sampAddChatMessage(tag .. 'Введите /ad [ID]', -1)
  end
end)

sampRegisterChatCommand('dh', function()
      if nickname then
          sampSendChat('/dhist '..nickname)
      else
    if bNotf then
        notf.addNotification('Вы не указали игрока', 5.0, 3)
    end
      end
  end)
  sampRegisterChatCommand('uu', function()
      if nickname then
          nicknamespec = nickname
          idspec = idad
          sampSendChat('/re '..idspec)
          specstat = true
      end
  end)
sampRegisterChatCommand('chl', function()
      if nickname then
          sampSendChat('/chlog '..nickname)
    if bNotf then
        notf.addNotification('Вы закончили погоню за '..nickname, 5.0, 2)
    end
      else
          if bNotf then
        notf.addNotification('Вы не указали игрока', 5.0, 3)
    end
      end
  end)
  sampRegisterChatCommand('nrpkill', function()
      if nickname then
          sampSendChat('/jail '..nickname..' 1')
    if bNotf then
        notf.addNotification('Вы повесили розыск '..nickname, 5.0, 2)
    end
      else
          if bNotf then
        notf.addNotification('Вы не указали игрока', 5.0, 3)
    end
      end
  end)
sampRegisterChatCommand('dmjail', function()
      if nickname then
          sampSendChat('/jail '..nickname..' 5')
    if bNotf then
        notf.addNotification('Вы повесили розыск '..nickname, 5.0, 2)
    end
      else
          if bNotf then
        notf.addNotification('Вы не указали игрока', 5.0, 3)
    end
      end
  end)

sampRegisterChatCommand('adj', function(idj1)
  if tonumber(idj1) then
    if sampIsPlayerConnected(idj1) then
      nicknamej1 = sampGetPlayerNickname(tonumber(idj1))
    else
      sampAddChatMessage(tag .. 'Игрока не обнаружено на сервере', -1)
    end
  else
    sampAddChatMessage(tag .. 'Введите /adj [ID]', -1)
  end
end)

function q.onSendPlayerSync(data)
  if Onfoot_Invis then
		local sync = samp_create_sync_data('spectator')
		sync.position = data.position
		sync.send()
		return false
	end
end

function q.onSendSpecatorSync(data)
  if Onfoot_Invis then
    for i = 0,3 do
    data.position[i] = 0e+1000
    end
  end
end

function onSendPacket(id, bitStream, priority, reliability, orderingChannel)
	if Onfoot_Invis and id == 207 then return false end
end

function mycordinv()
	MYX2, MYY2, MYZ2 = getCharCoordinates(playerPed)
end


function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    -- from SAMP.Lua
    local raknet = require 'samp.raknet'
    --require 'samp.synchronization'

    copy_from_player = copy_from_player or true
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    -- copy player's sync data to the allocated memory
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    -- function to send packet
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    -- metatable to access sync data and 'send' function
    local mt = {
        __index = function(t, index)
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
end

sampRegisterChatCommand('gd', function(iddesc)
      if tonumber(iddesc) then
        if sampIsPlayerConnected(iddesc) then
          nickd = sampGetPlayerNickname(tonumber(iddesc))
          idd = tonumber(iddesc)
          sampSendChat('/gd '..idd)
        end
      end
end)

sampRegisterChatCommand('re', function(idspec1)
  if specstat then
    uidspec = idspec
  end
  if idspec1 == '' then
    sampSendChat('/re '..idspec)
    specstat = true
  end
  if tonumber(idspec1) then
    if sampIsPlayerConnected(idspec1) then
      nicknamespec = sampGetPlayerNickname(tonumber(idspec1))
      idspec = tonumber(idspec1)
      sampSendChat('/re '..idspec)
      specstat = true
    end
  end
end)

sampRegisterChatCommand('ree', function()
  if tonumber(uidspec) then
    if sampIsPlayerConnected(uidspec) then
      nicknamespec = sampGetPlayerNickname(tonumber(uidspec))
      idspec = tonumber(uidspec)
      sampSendChat('/re '..idspec)
      specstat = true
    end
  end
end)

sampRegisterChatCommand('u', function(idspec1)
  if tonumber(idspec1) then
    if sampIsPlayerConnected(idspec1) then
      nicknamespec = sampGetPlayerNickname(tonumber(idspec1))
      idspec = tonumber(idspec1)
      sampSendChat('/re '..idspec)
      specstat = true
    end
  end
end)

function imgui.OnDrawFrame()
    
  if deadwind.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 1.7), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 50), imgui.Cond.FirstUseEver)
        imgui.Begin('ded inside', imgui.ImVec2(1, 1), imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
        if imgui.Button(u8'Возродить себя', imgui.ImVec2(270, 25)) then 
           local result, my2id = sampGetPlayerIdByCharHandle(PLAYER_PED)
           sampSendChat('/und '..my2id)
        end
        imgui.End()
  end

  if desc and not specstat and not main2.v then
    if descwind.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 16, sh / 1.75), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 160), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Desc ID - '..idd)
        if imgui.Button(u8'Удалить описание DESC', imgui.ImVec2(260, 30)) then
            sampSendChat('/cdesc '..idd)
            makeScreenshot()
        end
        if imgui.Button(u8'Посадить за НРП описание в /desc', imgui.ImVec2(260, 30)) then 
            sampSendChat('/jail '..idd..' 2')
            makeScreenshot()
        end
        if imgui.Button(u8'<', imgui.ImVec2(125, 30)) then 
            sampSendChat('/gd '..idd-1)
            idd = idd-1
            prewd = true
            nextd = false
        end
        imgui.SameLine()
        if imgui.Button(u8'>', imgui.ImVec2(125, 30)) then 
            sampSendChat('/gd '..idd+1)
            idd = idd+1
            nextd = true
            prewd = false
        end
        imgui.End()
    end
  end

  if chlog and not specstat and not desc then
      if mutetime.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 16, sh / 1.75), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 120), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Время мута')
         if imgui.Button(u8'Вернуться назад', imgui.ImVec2(270, 25)) then
              mutetime.v = false
              chlogwind.v = true
         end
        if imgui.Button(u8'5 мин') then
            sampSendChat('/mute '..idch..' 5 '..prich)
            makeScreenshot()
        end
        imgui.SameLine()
        if imgui.Button(u8'10 мин') then
            sampSendChat('/mute '..idch..' 10 '..prich)
            makeScreenshot()
        end
        imgui.SameLine()
        if imgui.Button(u8'15 мин') then
            sampSendChat('/mute '..idch..' 15 '..prich)
            makeScreenshot()
        end
        imgui.End()
      end
  
      if chlogwind.v then
            local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw / 16, sh / 1.75), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(300, 250), imgui.Cond.FirstUseEver)
            imgui.Begin(u8'Наказания чата, ID - '..idch, chlogwind.v)
            if imgui.Button(u8'OOC оскорбление', imgui.ImVec2(130, 20)) then
              mutetime.v = true
              chlogwind.v = false
              prich = 'ooc osk'
            end
            imgui.SameLine()
            if imgui.Button(u8'MG', imgui.ImVec2(130, 20)) then
              mutetime.v = true
              chlogwind.v = false
              prich = 'MG'
            end
            if imgui.Button(u8'Злоуп. чатами', imgui.ImVec2(130, 20)) then
              sampSendChat('/jail '..idch..' 3')
              makeScreenshot()
            end
            imgui.SameLine()
            if imgui.Button(u8'Ooc osk rod', imgui.ImVec2(130, 20)) then
              sampSendChat('/ban '..idch..' R osk rod')
              makeScreenshot()
            end
            if imgui.Button(u8'WARN многоч. оск', imgui.ImVec2(130, 20)) then
              sampSendChat('/warn '..idch..' Многоч. оски')
              makeScreenshot()
            end
            imgui.SameLine()
            if imgui.Button(u8'RBAN многоч оск', imgui.ImVec2(130, 20)) then
              sampSendChat('/ban '..idch..' R Многоч. оски')
              makeScreenshot()
            end
            if imgui.Button(u8'НРП провокация ПО', imgui.ImVec2(130, 20)) then
              sampSendChat('/jail '..idch..' 8')
              makeScreenshot()
            end
            imgui.SameLine()
            if imgui.Button(u8'Флуд', imgui.ImVec2(130, 20)) then
              mutetime.v = true
              chlogwind.v = false
              prich = 'flood'
            end
            if imgui.Button(u8'Update', imgui.ImVec2(270, 20)) then
              sampSendChat('/chlog '..idch)
            end
            imgui.End()
      end
  end

  if specstat then
  
      if nakazwind.v then 
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 16, sh / 1.75), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 50), imgui.Cond.FirstUseEver)
        imgui.Begin('1', imgui.ImVec2(1, 1), imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
        if imgui.Button(u8'Джайлы', imgui.ImVec2(130, 25)) then
          jailwind.v = true
          nakazwind.v = false
        end
        imgui.SameLine()
        if imgui.Button(u8'Баны', imgui.ImVec2(130, 25)) then
            banwind.v = true
            nakazwind.v = false
        end
        imgui.End()
      end

      if speccheckwind.v then 
          local sw, sh = getScreenResolution()
          imgui.SetNextWindowPos(imgui.ImVec2(sw / 16, sh / 1.15), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
          imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver)
          imgui.Begin(u8'Статистика')
          imgui.Text(u8'Никнейм - '..nicknamespec..'        ID - '..idspec)
          imgui.Text(u8'Пинг - '..sampGetPlayerPing(idspec)..u8'           Уровень - '..sampGetPlayerScore(idspec))
          imgui.End()
      end

      if banwind.v then 
      local sw, sh = getScreenResolution()
      imgui.SetNextWindowPos(imgui.ImVec2(sw / 16, sh / 1.75), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver)
      imgui.Begin(u8'Баны ID - '..idspec)
      if imgui.Button(u8'Вернуться назад', imgui.ImVec2(260, 20)) then
        banwind.v = false 
        nakazwind.v = true
      end
      if imgui.Button(u8'C - SH', imgui.ImVec2(130, 20)) then
        sampSendChat('/ban '..idspec..' C sh')
      end
        imgui.SameLine()
      if imgui.Button(u8'C - Airbrake', imgui.ImVec2(130, 20)) then
        sampSendChat('/ban '..idspec..' C Airbrake')
      end
      if imgui.Button(u8'C - GMcar', imgui.ImVec2(130, 20)) then
        sampSendChat('/ban '..idspec..' C GMcar')
      end
        imgui.SameLine()
      if imgui.Button(u8'C - fly', imgui.ImVec2(130, 20)) then
        sampSendChat('/ban '..idspec..' C fly')
      end
      if imgui.Button(u8'Коллизия', imgui.ImVec2(130, 20)) then
        sampSendChat('/ban '..idspec..' C коллизия')
      end
      imgui.Text(u8'ОБЯЗАТЕЛЬНО СВЕРЬТЕСЬ C ID')
      imgui.End()
      end

      if jailwind.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 16, sh / 1.75), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 250), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Джайлы')
        if imgui.Button(u8'Вернуться назад', imgui.ImVec2(260, 20)) then
          jailwind.v = false 
          nakazwind.v = true
        end
        if imgui.Button(u8'НРП нападение', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 0')
        end
        imgui.SameLine()
        if imgui.Button(u8'НРП килл', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 1')
        end
        if imgui.Button(u8'НРП описание', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 2')
        end
        imgui.SameLine()
        if imgui.Button(u8'Злоуп. чатами', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 3')
        end
        if imgui.Button(u8'НРП конвой', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 14')
        end
        imgui.SameLine()
        if imgui.Button(u8'ДМ', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 5')
        end
        if imgui.Button(u8'НРП лекция', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 6')
        end
        imgui.SameLine()
        if imgui.Button(u8'НРП вождение', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 7')
        end
        if imgui.Button(u8'Провокация ПО', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 8')
        end
        imgui.SameLine()
        if imgui.Button(u8'Помеха рп', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 9')
        end
        if imgui.Button(u8'Помеха работе', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 10')
        end
        imgui.SameLine()
        if imgui.Button(u8'НРП авиа', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 11')
        end
        if imgui.Button(u8'ДБ', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 12')
        end
        imgui.SameLine()
        if imgui.Button(u8'Злоупотребление объектов', imgui.ImVec2(130, 20)) then
          sampSendChat('/jail '..idspec..' 13')
        end
        imgui.End()
      end
  end
  if mainwindow then
      if main2.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 4.5, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(130, 400), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'2', imgui.ImVec2(1, 1), imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
        if imgui.ButtonActivated(main_window_state.v, u8'Основное', imgui.ImVec2(100, 40)) then
         skinc.v = false
         settingsi.v = false
         sprav.v = false
         reportwind.v = false
         main_window_state.v = true
        end
        if imgui.ButtonActivated(skinc.v, u8'Скины', imgui.ImVec2(100, 40)) then
            main_window_state.v = false 
            settingsi.v = false
            sprav.v = false
            reportwind.v = false
            skinc.v = true
        end
        if imgui.ButtonActivated(reportwind.v, u8'Фракции', imgui.ImVec2(100, 40)) then 
            skinc.v = false
            sprav.v = false
            settingsi.v = false
            main_window_state.v = false 
            reportwind.v = true 
        end
        if imgui.ButtonActivated(sprav.v, u8'Справка', imgui.ImVec2(100, 40)) then 
            skinc.v = false
            settingsi.v = false
            main_window_state.v = false 
            reportwind.v = false
            sprav.v = true
        end
        if imgui.ButtonActivated(settingsi.v, u8'Настройка', imgui.ImVec2(100, 40)) then
            skinc.v = false
            sprav.v = false
            main_window_state.v = false
            reportwind.v = false
            settingsi.v = true
        end
        imgui.End()
      end

      if reportwind.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600, 400), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Ahelp', imgui.ImVec2(1, 1), imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
        if imgui.CollapsingHeader(u8'LS') then
            imgui.Combo(u8'Фракция LS', fractlscombo, arr_fractls, #arr_fractls)
            if imgui.Button('Invite') then 
                lsfract = arr_fractls[fractlscombo.v+1]
                sampSendChat('/infract '..lsfract)
                lsinvitestat = true
            end
        end
        if imgui.CollapsingHeader(u8'SF') then
            imgui.Combo(u8'Фракция SF', fractsfcombo, arr_fractsf, #arr_fractsf)
            if imgui.Button('Invite') then 
                sffract = arr_fractsf[fractsfcombo.v+1]
                sampSendChat('/infract '..sffract)
                sfinvitestat = true
            end
            if imgui.Button('Spec') then 
                sffract = arr_fractsf[fractsfcombo.v+1]
                fractspec = true
                sampSendChat('/fract '..sffract)
            end
        end
        if imgui.CollapsingHeader(u8'LV') then
            imgui.Combo(u8'Фракция LV', fractlvcombo, arr_fractlv, #arr_fractlv)
            if imgui.Button('Invite') then 
                lvfract = arr_fractlv[fractlvcombo.v+1]
                sampSendChat('/infract '..lvfract)
                lvinvitestat = true
            end
        end
        if imgui.Button(u8'Статистика фракций по наборам', imgui.ImVec2(570, 25)) then
            sampSendChat('/invstat')
            main2.v = false
            imgui.Process = false
            mainwindow = false
        end
        if imgui.Button(u8'Статистика фракций по онлайну', imgui.ImVec2(570, 25)) then
            sampSendChat('/fstat')
            main2.v = false
            imgui.Process = false
            mainwindow = false
        end
        if imgui.Button(u8'Выдать самый высокий ранг в фракции', imgui.ImVec2(570, 25)) then
            rang = 15
            rangg = true
            sampSendChat('/fractrank '..rang)
        end
        if imgui.Button(u8'Уволиться', imgui.ImVec2(570, 25)) then
            local result, my3id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            sampSendChat('/fkick '..my3id)
        end
        imgui.End()
      end

      if skinc.v then 
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600, 400), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Skinc', imgui.ImVec2(1, 1), imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
            kl = 0
            posvehx = 5
            posvehy = 95
            postextx = 10
            postexty = 95
            for i = 0, 311, 1 do
                imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
                imgui.BeginChild("##12dsgpokd" .. i, imgui.ImVec2(80, 95))
                imgui.EndChild()    

                if imgui.IsItemClicked() then
                    MODEL = i
                    sampSendChat('/giveskin '..MODEL)
                end

                imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
                imgui.Image(skinpng[i], imgui.ImVec2(80, 95))

                postextx = postextx + 100
                posvehx = posvehx + 100
                kl = kl + 1
                if kl > 5 then
                    kl = 0
                    posvehx = 5
                    postextx = 10
                    posvehy = posvehy + 120
                    postexty = posvehy + 90
                end
            end
        imgui.End()
      end

      if sprav.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600, 400), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'sprav', imgui.ImVec2(1, 1), imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
        if imgui.Button(u8'Справка по джайлам') then
            ssprav = 1 
        end
        imgui.SameLine()
        imgui.Button(u8'Справка по банам')
        imgui.SameLine()
        imgui.Button(u8'Справка по РПВ')
        imgui.SameLine()
        imgui.Button(u8'Справка по варнам')
        if ssprav == 1 then
            imgui.BeginChild('testdddd', imgui.ImVec2(600, 300), false)
            if imgui.CollapsingHeader(u8'Нрп килл/DM') then
            imgui.Text(u8'1. Входим в слежку за игроком на которого поступила жалоба.')
            imgui.Text(u8'2. Смотрим /dhist - убеждаемся, что убийство было не по самообороне.')
            imgui.Text(u8'3. Смотрим /chatlog - убеждаемся, что у убийцы не было IC предпосылок к убийству в чате.')
            imgui.Text(u8'4. Выдаём наказание.')
            imgui.Text(u8'Если 3 убийства в дхисте без пометок, джайл по 5му коду.')
            end
            if imgui.CollapsingHeader(u8'Нрп нападение') then
            imgui.Text(u8'1. Входим в слежку за игроком на которого поступила жалоба.')
            imgui.Text(u8'2. Отписываем в /tvs или /as о прекращении ДМ.')
            imgui.Text(u8'3. Если игрок не успокаивается или продолжает нападение, то наказываем.')
            imgui.Text(u8'4. Если игроки успокоились после /tvs "Успокоились", выдаём ХП обоим игрокам')
            imgui.Text(u8' и немного следим, вдруг если начинается драка снова без IC предпосылок, ')
            imgui.Text(u8' то наказываем того, кто начал вторичную драку.')
            end
            if imgui.CollapsingHeader(u8'Нон рп деск') then
            imgui.Text(u8'1. Проверяем /gd (демонстрируется действующий /desc игрока).')
            imgui.Text(u8'2. Если /desc нонРП и вы уверены в этом, то удаляем desc игроку командой - /cleadesc .')
            imgui.Text(u8'3. При вторичной жалобе, то есть если после вашего удаления игрок')
            imgui.Text(u8'снова поставил себе подобный /desc, выдаём джаил.')
            end
            if imgui.CollapsingHeader(u8'Флуд в ис чат') then
            imgui.Text(u8'1. Проверяем чатлог игрока через /chlog')
            imgui.Text(u8'2. Смотрим что бы не было интервала между 1м и 3м сообщением 5 сек')
            imgui.Text(u8'3. Джайлим по 3му коду')
            end
            if imgui.CollapsingHeader(u8'Нрп вождение') then
            imgui.Text(u8'НонРП вождением или ездой считается умышенное сбитие столбов, игроков,')
            imgui.Text(u8'причинение умышленных аварий, умышленное нанесение вреда')
            imgui.Text(u8'чужому ТС и т.п. Также разрешается выдавать джейл, когда игрок')
            imgui.Text(u8'подъезжает на всей скорости в казино, врезается во всё что можно')
            imgui.Text(u8'и выпрыгивает из машины, после чего спокойно идёт себе в казино.')
            end
            if imgui.CollapsingHeader(u8'ДБ') then
            imgui.Text(u8'ДБ наказывается только в нескольких случаях: когда игрок умышленно')
            imgui.Text(u8'пытается задавить того или иного игрока своим т/с. ')
            imgui.Text(u8'Джайлим только если есть жалоба в репорт.')
            end
            if imgui.CollapsingHeader(u8'Помеха рп процессу') then
            imgui.Text(u8'1. Входим в слежку за игроком на которого поступила жалоба.')
            imgui.Text(u8'2. Смотрим /chatlog участников РП и нарушителя по мнению участников РП.')
            imgui.Text(u8'3. Если игрок действительно создаёт помеху, то в /ames отписываем чтобы ушёл,')
            imgui.Text(u8'вторично отсылаем если продолжает мешать на /spawn.')
            imgui.Text(u8'4. Если игрок после отправки на /spawn вернулся вновь туда и стал мешать снова,')
            imgui.Text(u8'то наказываем уже без всяких предупреждений.')
            end
            if imgui.CollapsingHeader(u8'Помеха в работе') then
            imgui.Text(u8'Помехой в работе считается задержание того или иного вида деятельности,')
            imgui.Text(u8'повреждение транспорта, препятственно выкидывать из т/')
            imgui.Text(u8'с, не давая завершить смену, ДБ, ДМ.')
            imgui.Text(u8'Джайлим исключительно по репортам игроков.')
            end
            if imgui.CollapsingHeader(u8'Нрп церковь') then
            imgui.Text(u8'Выдаем это наказание всем тем, кто в /mic на лекциях несет всяческую ерунду,')
            imgui.Text(u8'которая бы не могла прозвучать на реальной лекции')
            imgui.Text(u8'или проповеди. Основное назначение этого пункта - наказать всех,')
            imgui.Text(u8'кто будет тупо писать рандом в /mic.')
            end
            if imgui.CollapsingHeader(u8'Нрп провокация ПО') then
            imgui.Text(u8'Под этот пункт попадает любая нонРП провокация ПО на выдачу звезд,')
            imgui.Text(u8'примеры: «копы лохи», «дайте зв, мусора» и тп. (/call 911')
            imgui.Text(u8'тоже учитывается). Критерием не нонРП провокации должна быть хоть')
            imgui.Text(u8'какая-то грамотность или более менее вменяемая IC причина в')
            imgui.Text(u8'этой провокации.')
            end
            if imgui.CollapsingHeader(u8'Злоупотребление установкой объектов') then
            imgui.Text(u8'Сама система расстановки объектов предназначена для оформления')
            imgui.Text(u8'мероприятий, блокпостов, проведения задержаний или других')
            imgui.Text(u8'ситуаций со стороны сотрудников ПО. Использование данной системы для')
            imgui.Text(u8'создания постоянного маппинга, установки дорожных знаков')
            imgui.Text(u8'на дорогах, перекрытие дорог без проведения там каких-либо действий')
            imgui.Text(u8'по досмотру или задержанию - считается злоупотреблением, и наказывается джайлом.')
            imgui.Text(u8'Так-же установка объектов в неестественные для них положения считается злоупотреблением. ')
            end
            if imgui.CollapsingHeader(u8'НРП авиатранспорт') then
            imgui.Text(u8'Данный код распространен в основном на ловлеров которые при слете')
            imgui.Text(u8'покидают свои самолеты в надежде купить слетевший дом. В')
            imgui.Text(u8'случае когда их корыта были брошены ими вблизи жилых - выдается')
            imgui.Text(u8'соответствующее наказание. При рецидивах выдается блокировка')
            imgui.Text(u8'категориями R и HR. Рецидивом для блокировки R считается 3 выданных джайла,')
            imgui.Text(u8'при последующем нарушении в виде тех-же самых 3-х')
            imgui.Text(u8'джейлов после разблокировки выдается бан категории HR.')
            end
            imgui.EndChild()
        end
        imgui.End()
      end

      if settingsi.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600, 400), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'setting', imgui.ImVec2(1, 1), imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
        if imgui.Checkbox(u8'Chlog помощник', chlogh) then 
            Config.Settings.ChlogHelp = chlogh.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Desc помощник', desch) then 
            Config.Settings.DescHelp = desch.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Помощник по джайлам за нрп килл', jailh) then
            Config.Settings.JailHelp = jailh.v 
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Статистика игрока в реконе', speccheck) then
            Config.Settings.SpecPlayerCheck = speccheck.v 
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Репорты в уведах', nrep) then
            Config.Settings.NotifyRep = nrep.v 
            inicfg.save(Config, 'ahelp.ini')
        end
        imgui.End()
      end

      if main_window_state.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600, 400), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Ahelp', imgui.ImVec2(1, 1), imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
        if imgui.Checkbox(u8'Выключение [A] чата', check1) then 
            Config.Settings.achatini = check1.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Выключение сообщений для администрации', check2) then 
            Config.Settings.amessini = check2.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'ID в килл листе', idkl) then 
            Config.Settings.IdKillList = idkl.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Невидимка (Активация - Alt + B)', inv) then 
            Config.Settings.AdmInvis = inv.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Агм автоматически', agm) then 
            Config.Settings.AutoGodMod = agm.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Ghost автоматически', ghost) then 
            Config.Settings.AutoGhost = ghost.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Серверный КАРХИЛ', cheal) then 
            Config.Settings.ServerCarHeal = cheal.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'Автоматическое поднятие с стадии', autou) then 
            Config.Settings.AutoUnd = autou.v
            inicfg.save(Config, 'ahelp.ini')
        end
        if imgui.Checkbox(u8'GM', GMped) then 
            Config.Settings.GM1 = GMped.v
            inicfg.save(Config, 'ahelp.ini')
        end
        imgui.End()
      end
  end

  if information.v then
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(400, 420), imgui.Cond.FirstUseEver)
    imgui.Begin('1232323')
    imgui.Text(u8'LVL: '..speclvl1..u8' Пол: '..u8(specpol)..u8' Деньги: '..specmoney)
    imgui.End()
  end

  if second_window_state.v then
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 1.16, sh / 1.36), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(400, 420), imgui.Cond.FirstUseEver)
    imgui.Begin(fa.ICON_EYE .. u8' Режим наблюдения - '..nicknamespec..'['..idspec..'] PING '..sampGetPlayerPing(idspec), second_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
    if imgui.Button(fa.ICON_ADDRESS_CARD .. u8' Статистика', imgui.ImVec2(175, 30)) then
      sampSendChat('/check '..idspec)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_CHEVRON_UP .. u8' Слапнуть', imgui.ImVec2(175, 30)) then
      sampSendChat('/slap '..idspec)
    end
    if imgui.Button(fa.ICON_EJECT .. u8' Телепортировать', imgui.ImVec2(175, 30)) then
      sampSendChat('/gethere '..idspec)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_PAUSE .. u8' Зафризить', imgui.ImVec2(95, 30)) then
      sampSendChat('/freeze '..idspec)
    end
    imgui.SameLine()
    if imgui.Button(u8' ALL', imgui.ImVec2(69, 30)) then 
        frall = not frall
        if frall then
            sampSendChat('/frall 50')
        else
            sampSendChat('/unfrall 70')
        end
    end
    if imgui.Button(fa.ICON_USERS .. u8' Информация', imgui.ImVec2(175, 30)) then
       sampSendChat('/checkex '..idspec)
       checkinf = true
       lua_thread.create(function()
          if not information.v then
            wait(1000)
            information.v = not information.v 
          else
            information.v = not information.v 
          end
       end)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_FIRE .. u8' Шот/кей инфо', imgui.ImVec2(175, 30)) then
      sampSendChat('/shotinfo')
      sampSendChat('/keyinfo')
    end
    if imgui.Button(fa.ICON_COMMENTS .. u8' Чатлог', imgui.ImVec2(175, 30)) then
      sampSendChat('/chlog '..idspec)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_BOMB .. u8' Дхист', imgui.ImVec2(175, 30)) then
      sampSendChat('/dhist '..idspec)
    end
    if imgui.Button(fa.ICON_CHEVRON_RIGHT .. u8' Телепортироваться', imgui.ImVec2(175, 30)) then
      lua_thread.create(function()
                sampSendChat("/reoff")
                wait(1000)
                sampSendChat("/goto "..idspec)
            end)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_CHEVRON_LEFT .. u8' Тп к себе', imgui.ImVec2(175, 30)) then
      lua_thread.create(function()
                sampSendChat("/reoff")
                wait(1000)
                sampSendChat("/gethere "..idspec)
            end)
    end
    if imgui.Button(fa.ICON_USER_TIMES .. u8' Убить', imgui.ImVec2(175, 30)) then
      sampSendChat('/kill '..idspec)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_COG .. u8' Проколоть колеса', imgui.ImVec2(175, 30)) then
      sampSendChat('/popt '..idspec)
    end
    if imgui.Button(fa.ICON_SIGN_OUT .. u8' Реент', imgui.ImVec2(175, 30)) then
      sampSendChat('/reent '..idspec)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_STREET_VIEW .. u8' Спавн', imgui.ImVec2(175, 30)) then
      sampSendChat('/spawn '..idspec)
    end
    if imgui.Button(fa.ICON_CAR .. u8' Удалить авто', imgui.ImVec2(175, 30)) then
      local result1, spech = sampGetCharHandleBySampPlayerId(idspec)
      local car, huita = storeClosestEntities(spech)
      local result, idcar = sampGetVehicleIdByCarHandle(car)
      sampSendChat('/respawnid '..idcar)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_HEART .. u8' Вылечить', imgui.ImVec2(175, 30)) then
      sampSendChat('/sethp '..idspec..' 100')
    end
    if imgui.Button(fa.ICON_BICYCLE .. u8' Раскрутить', imgui.ImVec2(175, 30)) then
      sampSendChat('/roll '..idspec)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_CARET_SQUARE_O_LEFT .. u8'', imgui.ImVec2(80, 30)) then
      sampSendChat('/re '..idspec-1)
      idspec = idspec-1
      nicknamespec = sampGetPlayerNickname(idspec)
    end
    imgui.SameLine()
    if imgui.Button(fa.ICON_CARET_SQUARE_O_RIGHT .. u8'', imgui.ImVec2(80, 30)) then
      sampSendChat('/re '..idspec+1)
      idspec= idspec+1
      nicknamespec = sampGetPlayerNickname(idspec)
    end
    if imgui.Button(u8'Dm') then
        sampSendChat('/ames '..idspec..' dm off')
    end
    imgui.SameLine()
    if imgui.Button(u8'Dm(tvs)') then
        sampSendChat('/tvs dm off')
    end
    imgui.SameLine()
    if imgui.Button(u8'Db') then
        sampSendChat('/ames '..idspec..' db off')
    end
    imgui.SameLine()
    if imgui.Button(u8'ПРП') then
        sampSendChat('/ames '..idspec..' не мешайте рп')
    end
    imgui.SameLine()
    if imgui.Button(u8'вы тут?') then
        sampSendChat('/ames '..idspec..' вы тут? + в /b чат')
    end
    imgui.SameLine()
    imgui.End()
  end
end

sampRegisterChatCommand('povod', function(arg)
    povodstat = true
    IID = arg
    sampAddChatMessage('Поводок повешан на ID '..arg, -1)
end)

sampRegisterChatCommand('myco', function()
    sampAddChatMessage(MYX..' '..MYY..' '..MYZ, -1)
end)

function chlogcheck(arg)
   chlogwind.v = not chlogwind.v
   imgui.Process = chlogwind.v
   chlog = true
end

function q.onPlayerDeathNotification(killerId, killedId, reason)
    if Config.Settings.IdKillList then
	    local kill = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())
	    local _, myid = sampGetPlayerIdByCharHandle(playerPed)

	    local n_killer = ( sampIsPlayerConnected(killerId) or killerId == myid ) and sampGetPlayerNickname(killerId) or nil
	    local n_killed = ( sampIsPlayerConnected(killedId) or killedId == myid ) and sampGetPlayerNickname(killedId) or nil
	    lua_thread.create(function()
		    wait(0)
		    if n_killer then kill.killEntry[4].szKiller = ffi.new('char[25]', ( n_killer .. '[' .. killerId .. ']' ):sub(1, 24) ) end
		    if n_killed then kill.killEntry[4].szVictim = ffi.new('char[25]', ( n_killed .. '[' .. killedId .. ']' ):sub(1, 24) ) end
	    end)
    end
end

function q.onShowDialog(dialogId, style, title, button1, button2, text)
    sampRegisterChatCommand('dia', function()
        sampAddChatMessage(dialogId, -1)
    end)
    lua_thread.create(function() 
        while true do
            wait(0)
            if sampIsDialogActive() then
                if string.find(title, 'Получены ', 1, true) then
                    if Config.Settings.AutoUnd then
                        local result, my2id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                        sampSendChat('/und '..my2id)
                        break
                    else
                        deadwind.v = true
                        descwind.v = false
                        chlogwind.v = false
                        imgui.Process = deadwind.v
                        ded = true
                        chlog = false
                        desc = false
                        break
                    end
                end
                if not specstat then 
                    if title:find('chatlog (.+) ID {(.+)}(%d+)') then
                        nickch, idch = title:match('chatlog (.+) ID {.+}(%d+)')
                        chlogwind.v = true
                        deadwind.v = false
                        descwind.v = false
                        imgui.Process = chlogwind.v
                        chlog = true
                        ded = false
                        desc = false
                        break
                    end
                end
                if string.find(title, 'Текст описания', 1, true) then
                    if not specstat and Config.Settings.DescHelp then
                        descwind.v = true
                        deadwind.v = false
                        chlogwind.v = false
                        imgui.Process = descwind.v
                        desc = true
                        chlog = false
                        ded = false
                        break
                    end
                end
            elseif not sampIsDialogActive() and not specstat then
                if ded then
                    deadwind.v = false
                    imgui.Process = deadwind.v
                    ded = false
                    break
                end
                if chlog then 
                    chlogwind.v = false
                    imgui.Process = chlogwind.v
                    chlog = false
                    break
                end
                if desc then
                    descwind.v = false
                    imgui.Process = descwind.v
                    desc = false
                    break
                end
            end
        end
    end)
end

sampRegisterChatCommand('reofban', function(arg)
    sampSendChat('/ofban '..nicknamespec..' '..arg)
end)

sampRegisterChatCommand('repcolor', function(arg)
    Config.Settings.RepColor = arg
    inicfg.save(Config, 'ahelp.ini')
    sampAddChatMessage('{'..Config.Settings.RepColor..'}test')
end)

sampRegisterChatCommand('acolor', function(arg)
    Config.Settings.ACHColor = arg
    inicfg.save(Config, 'ahelp.ini')
    sampAddChatMessage('{'..Config.Settings.ACHColor..'}test')
end)

sampRegisterChatCommand('colors', function()
    Config.Settings.Colors = not Config.Settings.Colors
    inicfg.save(Config, 'ahelp.ini')
    if Config.Settings.Colors then
        sampAddChatMessage('ON', -1)
    else
        sampAddChatMessage('OFF', -1)
    end
end)

function avinfo()
    avinfon = not avinfon
end

sampRegisterChatCommand('myname', function()
    sampAddChatMessage(clientName, -1)
end)

sampRegisterChatCommand('changetheme', function()
    if Config.Settings.Theme == 1 then
       Config.Settings.Theme = 2 
       inicfg.save(Config, 'ahelp.ini')
       apply_custom_style2()
       sampAddChatMessage('Темная', -1)
    elseif Config.Settings.Theme == 2 then
       Config.Settings.Theme = 1
       inicfg.save(Config, 'ahelp.ini')
       apply_custom_style()
       sampAddChatMessage('Классик', -1)
    end
end)
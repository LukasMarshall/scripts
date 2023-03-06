--sampAddChatMessage('{FF0000}[Imgui] {FFFFFF}Скрипт', 0xFFFFFF)

script_name("Imgui Script")

require "lib.moonloader" -- подключаем библиотеку
local keys = require "vkeys"
local sampev = require "lib.events"
local imgui = require "imgui" -- imgui
local encoding = require "encoding" -- imgui
encoding.default = "CP1251" -- imgui
u8 = encoding.UTF8 -- imgui

-- [автообновление
local dlstatus = require('moonloader').download_status -- статус загрузки скрипта -- автообновление
local inicfg = require 'inicfg'  -- автообновление

update_state = true -- автообновление

local script_vers = 2 -- версия
local script_vers_text = "2.00" -- текстовая версия 

local update_url = "https://raw.githubusercontent.com/LukasMarshall/scripts/main/update.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "/update.ini" -- и тут свою ссылку

local script_url = "https://raw.githubusercontent.com/LukasMarshall/scripts/main/lesson_13.lua" -- тут свою ссылку
local script_path = thisScript().path
-- автообновление] 

local themes = import "resource/imgui_themes.lua" -- стили

local fa = require 'faIcons'
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

----- COLORS -----
local label = 0
local main_color = 0x5A90CE
local main_color_text = "{5A90CE}"
local white_color = "{FFFFFF}"
local arr_str = {u8"привет",u8"привет 2",u8"привет 3"}

local main_window_state = imgui.ImBool(false)-- imgui // состояние окна
local secondary_window_state = imgui.ImBool(false)
local stil_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256) -- imgui // размер 
arrSelectable = {false, false}
-- for CHECKBOX
	local checked_test = imgui.ImBool(false)
	local checked_test_2 = imgui.ImBool(false)
--

-- for RADIO
	local checked_radio = imgui.ImInt(1)
--

--for COMBO
	local combo_select = imgui.ImInt(0)
--

local sw, sh = getScreenResolution() -- деления єкрана для позиция посреди

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

function imgui.TextColoredRGB(text, render_text)
    local max_float = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end

            local length = imgui.CalcTextSize(w)
            if render_text == 2 then
                imgui.NewLine()
                imgui.SameLine(max_float / 2 - ( length.x / 2 ))
            elseif render_text == 3 then
                imgui.NewLine()
                imgui.SameLine(max_float - length.x - 5 )
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], text[i])
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(w) end


        end
    end

    render_text(text)
end

function SetStyle()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.ChildWindowRounding = 4.0
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)-- (0.1, 0.9, 0.1, 1.0)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
end

SetStyle()

function main() 

	if not isSampLoaded() or not isSampfuncsLoaded() then return end while not isSampAvailable() do wait(100) end -- запускается скрипт при запуске игры
	sampAddChatMessage('{FF0000}[Imgui] {FFFFFF}Скрипт', 0xFFFFFF)

	sampRegisterChatCommand("imgui", cmd_imgui) 
	sampRegisterChatCommand("check", cmd_check)
	sampRegisterChatCommand("imgui2", cmd_imgui2)  -- второе окно
	sampRegisterChatCommand("themes", cmd_themes) -- стиль
	sampRegisterChatCommand("update", cmd_update) -- версия
	
	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)
	score = sampGetPlayerScore(id)
	
	downloadUrlToFile(update_url, update_path, function(id, status) -- версия
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
                update_state = true
            end 
            os.remove(update_path)
        end
    end)
	
	imgui.Process = false 

    imgui.SwitchContext() -- стиль, будет измена стиля
    themes.SwitchColorTheme() -- стиль, из resource берет инфу

	while true do
		wait(0)
		
		if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
        end
		
		--[[
		if main_window_state.v == false then  -- imgui // закрытие окошка
			imgui.Process = false
		end -- если у нас 2 окна то это удаляем
		--]]
		
	 end
end

function cmd_update(arg)
    sampShowDialog(1000, "Автообновление v2.0", "{FFFFFF}Это урок по обновлению\n{FFF000}Новая версия", "Закрыть", "", 0)
end

function cmd_imgui(arg)
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end

function cmd_imgui2(arg) -- второе окно
	secondary_window_state.v = not secondary_window_state.v
	imgui.Process = secondary_window_state.v
end

function cmd_themes(arg) -- третье окно
	stil_window_state.v = not stil_window_state.v
	imgui.Process = stil_window_state.v
end

function cmd_check(arg)
	sampAddChatMessage(checked_radio.v, -1)
	
	if checked_test.v then 
		sampAddChatMessage("Галочка стоит", -1)
	end
	
	sampAddChatMessage(u8:decode(arr_str[combo_select.v + 1]), -1) -- декодировка чтобы небыло иероглифов
end

function imgui.OnDrawFrame() -- будет мигать соответственно фпс
	
	if not main_window_state.v and not secondary_window_state.v and not stil_window_state.v then -- после закрытия прячет курсор
		imgui.Process = false
	end
	
	if main_window_state.v then 
		imgui.SetNextWindowSize(imgui.ImVec2(500, 600), imgui.Cond.FirstUseEver) -- размер окна
		imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) -- позиция посреди
		
		imgui.Begin(fa.ICON_PENCIL ..u8" Вспомогательный скрипт от Lukas Marshall", main_window_state,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.PushItemWidth(300) -- размер строки
		imgui.InputText(fa.ICON_PENCIL .. u8" Вводите текст сюда", text_buffer)
		imgui.Text(text_buffer.v)
		
		x, y, z = getCharCoordinates(PLAYER_PED)
		imgui.Text(fa.ICON_ARROWS .. (u8" Позиция игрока: X:" .. math.floor(x) .. " | Y: " .. math.floor(y) .. " | Z: " .. math.floor(z)))
		
		imgui.RadioButton( fa.ICON_TAXI .. " Radio 1", checked_radio, 4)
		imgui.SameLine() -- выводит кнопки в 1 строку
		imgui.RadioButton("Radio 2", checked_radio, 5)
		imgui.SameLine() -- выводит кнопки в 1 строку
		imgui.RadioButton("Radio 3", checked_radio, 6)
		imgui.TextColoredRGB("{FFFF00}" .. fa.ICON_TAXI .. u8"{FFFFFF} Привет", 2)
		
		
		
		imgui.Separator() -- разделительная линия
		
		imgui.Checkbox("Checkbox 1", checked_test)
		imgui.SameLine() -- выводит кнопки в 1 строку
		--imgui.SetCursorPos(imgui.ImVec2(200, 150)) позиция кнопки в окне
		imgui.Checkbox("Checkbox 2", checked_test_2)
		imgui.Separator() -- разделительная линия
		
		imgui.PushItemWidth(120) -- размер combobox
		--[[
		imgui.SetCursorPosY(250) позиция в окне
		imgui.SetCursorPosX(200)
		-- Вместо этого можно использовать imgui.SetCursorPos(imgui.ImVec2(X, Y)
		--]]
		
		imgui.Combo("Combo 1", combo_select, arr_str, #arr_str)
		---------------
		imgui.BeginChild("ChildWindow", imgui.ImVec2(200, 100), true) -- ОКНО В ОКНЕ ИМГУИ, есои прсиавмит false, границы не будет
			imgui.Text("test")
		imgui.EndChild()
		
		imgui.SameLine() -- выводит кнопки в 1 строку
		
		imgui.BeginChild("ChildWindow2", imgui.ImVec2(200, 100), true) -- ОКНО В ОКНЕ ИМГУИ
			imgui.Columns(3, "Columns", true) -- кол-во колонок, имя, граница
			
			imgui.Text("Text 1 ")
			imgui.NextColumn() -- передвигает текст на след. столбик таблицы
			imgui.Text("Text 2")
			imgui.NextColumn() -- передвигает текст на след. столбик таблицы
			imgui.Text("Text 3")
			imgui.Separator() -- делает подчеркивание строки в таблице
			imgui.NextColumn() -- передвигает текст на след. столбик таблицы
			imgui.Text("Text 4")
			imgui.NextColumn() -- передвигает текст на след. столбик таблицы
			--imgui.Text("Text 5")
			if imgui.Selectable(u8"Нажми1", arrSelectable[1], imgui.SelectableFlags.AllowDoubleClick) then -- в таблице кнопка нажатия
				if (imgui.IsMouseDoubleClicked(0)) then -- флаг, если нажали дважды
					arrSelectable[1] = not arrSelectable[1] -- При true кнопки в таблице она светится
					sampAddChatMessage("Нажали1", -1)
				end
			end
			imgui.NextColumn() -- передвигает текст на след. столбик таблицы
			--imgui.Text("Text 6")
			if imgui.Selectable(u8"Нажми2", arrSelectable[2]) then -- в таблице кнопка нажатия
				arrSelectable[2] = not arrSelectable[2] -- При true кнопки в таблице она светится
				sampAddChatMessage("Нажали2", -1)
			end
			imgui.Columns(1) -- завершаем работу с колонками
			imgui.Separator() -- делает подчеркивание строки в таблице
			imgui.Button("Button") -- кнопка
			
			-- флаги пишутся в Begin
			-- imgui.WindowFlags.NoResize -- убрать ресайз полоску, в углу увеличение окна
			-- imgui.WindowFlags.NoCollapse -- не разрешать сворачивать окно
			-- imgui.WindowFlags.NoMove -- нельзя двигать имгуи окно
			-- imgui.WindowFlags.NoScrollbar -- убирает скролл
			-- imgui.WindowFlags.NoTitleBar -- убирает тайтл у окон, сверху заголовок

			-- imgui.SelectableFlags.AllowDoubleClick -- разрешение дабл клика на пункт

			-- несколько флагов прописываются через "+"
			
		
		imgui.EndChild()
		
		----------------
		imgui.End()
	end
	
	if secondary_window_state.v then -- 2 окно
		imgui.Begin(u8"Заголовок 2", secondary_window_state)
		imgui.Text(u8"Привет")
		imgui.End()
	end
	
	if stil_window_state.v then -- 3 окно
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(510, 600), imgui.Cond.FirstUseEver)

        imgui.Begin('Imgui Themes', stil_window_state, imgui.WindowFlags.NoCollapse)

        if imgui.Button(u8'Кнопка') then
            themes.SwitchColorTheme(2)
        end

        --img = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\images\\fon_temnyj_pelen.jpg")
        --imgui.Image(img, imgui.ImVec2(500, 347))

        imgui.BeginChild("ChildWindow2", imgui.ImVec2(200, 175), true)
            for i, value in ipairs(themes.colorThemes) do
                if imgui.RadioButton(value, checked_radio, i) then 
                    themes.SwitchColorTheme(i) 
                end
            end
        imgui.EndChild()


        imgui.End()
    end
end
















--[[

local imgui = require 'imgui'
local key = require 'vkeys'

-- одно из основных отличий от оригинального апи
-- все переменные, значения которых записываются в ImGui по указателю, могут использоваться только через специальные типы
local main_window_state = imgui.ImBool(false)
function imgui.OnDrawFrame()
  if main_window_state.v then -- чтение и запись значения такой переменной осуществляется через поле v (или Value)
    imgui.SetNextWindowSize(imgui.ImVec2(150, 200), imgui.Cond.FirstUseEver) -- меняем размер
    -- но для передачи значения по указателю - обязательно напрямую
    -- тут main_window_state передаётся функции imgui.Begin, чтобы можно было отследить закрытие окна нажатием на крестик
    imgui.Begin('My window', main_window_state)
    imgui.Text('Hello world')
    if imgui.Button('Press me') then -- а вот и кнопка с действием
      -- условие будет выполнено при нажатии на неё
      printStringNow('Button pressed!', 1000)
    end
    imgui.End()
  end
end

function main()
sampAddChatMessage('{FF0000}[Imgui] {FFFFFF}Скрипт', 0xFFFFFF)
  while true do
    wait(0)
    if wasKeyPressed(key.VK_X) then -- активация по нажатию клавиши X
        main_window_state.v = not main_window_state.v -- переключаем статус активности окна, не забываем про .v
    end
    imgui.Process = main_window_state.v -- теперь значение imgui.Process всегда будет задаваться в зависимости от активности основного окна
  end
end

--]]
--[[
local imgui = require 'imgui';
local pie = require 'piemenu';
local key = require 'vkeys';

local piemenu  = imgui.ImBool(false);

function main()
sampAddChatMessage('{FF0000}[Imgui] {FFFFFF}Скрипт', 0xFFFFFF)
    if not isSampLoaded() or not isSampfuncsLoaded() then return end;
    while not isSampAvailable() do wait(100) end;
    while true do
        wait(0)
        imgui.Process = piemenu.v
        if wasKeyPressed(key.VK_K) then
            piemenu.v = not piemenu.v
        end
    end
end

function imgui.OnDrawFrame()
    if piemenu.v then
        imgui.OpenPopup('PieMenu')
        if pie.BeginPiePopup('PieMenu', 1) then
        if pie.PieMenuItem('Test1') then end
        if pie.PieMenuItem('Test2') then end
        --if pie.PieMenuItem('Test5') then end
        if pie.PieMenuItem('Test3', false) then end
        if pie.BeginPieMenu('Sub') then
            if pie.BeginPieMenu('Sub sub\nmenu') then
            if pie.PieMenuItem('SubSub') then end
            if pie.PieMenuItem('SubSub2') then end
            pie.EndPieMenu()
            end
            if pie.PieMenuItem('TestSub') then end
            if pie.PieMenuItem('TestSub2') then end
        pie.EndPieMenu()
        end
        pie.EndPiePopup()
        end
    end
end 
--]]
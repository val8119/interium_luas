Menu.Spacing()
Menu.Separator()
Menu.Spacing()
Menu.Text("Watermark V4")
Menu.Spacing()
Menu.Checkbox("Enable watermark", "bWatermark", true)
Menu.Spacing()
Menu.Checkbox("Enable rainbow gradient", "bRainbowGradient", true)
Menu.Spacing()
Menu.ColorPicker("Watermark bar left", "RenderWatermark_BarLeft", 255, 0, 0, 255)
Menu.Spacing()
Menu.ColorPicker("Watermark bar right", "RenderWatermark_BarRight", 0, 0, 255, 255)
Menu.Spacing()
Menu.ColorPicker("Watermark text color", "RenderWatermark_Text", 255, 255, 255, 255)
Menu.Spacing()
Menu.ColorPicker("Watermark background color", "RenderWatermark_Background", 0, 0, 0, 100)
Menu.Spacing()
Menu.Text("Text style")
Menu.Combo( "", "iWatermarkText", { "TEXT | TEXT", "text | text", "TEXT   TEXT", "text   text" }, 0);

-- RGB vars
local Height = 0
local Type = { 0, 0, 0, 0 }
local R = { 255, 0, 0, 0 }
local G = { 0, 255, 0, 0 }
local B = { 0, 0, 255, 0 }

-- credit to @extra for rainbow
local function Rainbow(Strong,Type, r, g, b) 
	local NewStrong = Strong * (120.0 / Utils:GetFps())

	if (Type == 0) then
		if (g < 255) then
			if (g + NewStrong > 255) then
				g = 255
			else
				g = g + NewStrong
			end
		else
			Type = Type + 1
		end
	elseif (Type == 1) then
		if (r > 0) then
			if (r - NewStrong < 0) then
				r = 0
			else
				r = r - NewStrong
			end
		else
			Type = Type + 1
		end
	elseif (Type == 2) then
		if (b < 255) then
			if (b + NewStrong > 255) then
				b = 255
			else
				b = b + NewStrong
			end
		else
			Type = Type + 1
		end
	elseif (Type == 3) then
		if (g > 0) then
			if (g - NewStrong < 0) then
				g = 0
			else
				g = g - NewStrong
			end
		else
			Type = Type + 1
		end
	elseif (Type == 4) then
		if (r < 255) then
			if (r + NewStrong > 255) then
				r = 255
			else
				r = r + NewStrong
			end
		else
			Type = Type + 1
		end
	elseif (Type == 5) then
		if (b > 0) then
			if (b - NewStrong < 0) then
				b = 0
			else
				b = b - NewStrong
			end
		else
			Type = 0
		end
	end

	return Strong,Type, r, g, b
end

local function RenderWatermark()

	if (not Menu.GetBool("bWatermark")) then return end

	local WatermarkTextColor = Menu.GetColor("RenderWatermark_Text")
	local WatermarkBackgroundColor = Menu.GetColor("RenderWatermark_Background")
	local WatermarkBarColorLeft = Menu.GetColor("RenderWatermark_BarLeft")
	local WatermarkBarColorRight = Menu.GetColor("RenderWatermark_BarRight")
	local TextSize = Render.CalcTextSize_1(WatermarkText, 14)
	local fpsString = 0

	if (Utils.GetFps() <= 99) then
		fpsString = "0" .. Utils.GetFps()
	else
		fpsString = Utils.GetFps()
	end

	local WatermarkText1 = "INTERIUM | FPS: " .. fpsString .. " | USER: " .. Hack.GetUserName()
	local WatermarkText2 = "interium | fps: " .. fpsString .. " | user: " .. Hack.GetUserName()
	local WatermarkText3 = "INTERIUM   FPS: " .. fpsString .. "   USER: " .. Hack.GetUserName()
	local WatermarkText4 = "interium   fps: " .. fpsString .. "   user: " .. Hack.GetUserName()

	if (Menu.GetInt("iWatermarkText") == 0) then
		WatermarkText = WatermarkText1
	end

	if (Menu.GetInt("iWatermarkText") == 1) then
		WatermarkText = WatermarkText2
	end

	if (Menu.GetInt("iWatermarkText") == 2) then
		WatermarkText = WatermarkText3
	end

	if (Menu.GetInt("iWatermarkText") == 3) then
		WatermarkText = WatermarkText4
	end

	local Strong = 4
	Strong,Type[1], R[1], G[1], B[1] = Rainbow(Strong,Type[1], R[1], G[1], B[1])
	Strong,Type[4], R[4], G[4], B[4] = Rainbow(Strong,Type[4], R[4], G[4], B[4])

	Render.RectFilled(9, 10, TextSize.x + 19, 29, WatermarkBackgroundColor, 4)

	if (Menu.GetBool("bRainbowGradient")) then
		Render.RectFilledMultiColor(9, 10, TextSize.x + 19, 12, Color.new(R[4], G[4], B[4], 255), Color.new(R[1], G[1], B[1], 255), Color.new(R[1], G[1], B[1], 255), Color.new(R[4], G[4], B[4], 255))
	else
		Render.RectFilledMultiColor(9, 10, TextSize.x + 19, 12, WatermarkBarColorLeft, WatermarkBarColorRight, WatermarkBarColorRight, WatermarkBarColorLeft)
	end

	Render.Text_1(WatermarkText, 13, 13, 14, WatermarkTextColor, false, true)

end

Hack.RegisterCallback("PaintTraverse", RenderWatermark)
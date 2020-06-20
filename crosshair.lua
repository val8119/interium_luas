Menu.Spacing()
Menu.Separator()
Menu.Spacing()
Menu.Text("Custom crosshair (whole numbers work best)")
Menu.Spacing()
Menu.Checkbox("Enable custom crosshairs", "bEnableCrosshair", false)
Menu.Spacing()
Menu.ColorPicker("Crosshair Color", "cCrosshairColor", 255, 255, 255, 255)
Menu.Spacing()
Menu.Text("Crosshair dot")
Menu.Combo("Dot type", "iDotType", {"None", "Square", "Circle"}, 0)
Menu.Spacing()
Menu.SliderFloat("Dot size", "fDotSize", 0, 25, "%.1f", 1)
Menu.Spacing()
Menu.Checkbox("Crosshair", "bEnableCrosshairLines", false)
Menu.Spacing()
Menu.SliderFloat("Crosshair size", "fCrosshairSize", 0, 30, "%.1f", 1)
Menu.Spacing()
Menu.SliderFloat("Crosshair gap", "fCrosshairGap", 0, 30, "%.1f", 1)
Menu.Spacing()
Menu.SliderFloat("Crosshair thickness", "fCrosshairThickness", 0, 30, "%.1f", 1)
Menu.Spacing()


function Crosshair()
    TestColorRed = Color.new(255, 0, 0, 255)

    ScreenX = Globals.ScreenWidth() / 2
    ScreenY = Globals.ScreenHeight() / 2

    DotSize = Menu.GetFloat("fDotSize")
    CrosshairColor = Menu.GetColor("cCrosshairColor")
    CrosshairSize = Menu.GetFloat("fCrosshairSize")
    CrosshairGap = Menu.GetFloat("fCrosshairGap")
    CrosshairThickness = Menu.GetFloat("fCrosshairThickness")

    if (not Menu.GetBool("bEnableCrosshair")) then
        IEngine.ExecuteClientCmd("crosshair 1")
        return
    else
        IEngine.ExecuteClientCmd("crosshair 0")
    end

    -- CROSSHAIR LINES
    if (Menu.GetBool("bEnableCrosshairLines")) then
        -- LEFT LINE
        Render.RectFilled(ScreenX - CrosshairSize - CrosshairGap, ScreenY - CrosshairThickness, ScreenX - CrosshairGap, ScreenY + CrosshairThickness, CrosshairColor, 0)

        -- RIGHT LINE
        Render.RectFilled(ScreenX + CrosshairSize + CrosshairGap, ScreenY - CrosshairThickness, ScreenX + CrosshairGap, ScreenY + CrosshairThickness, CrosshairColor, 0)

        -- TOP LINE
        Render.RectFilled(ScreenX - CrosshairThickness, ScreenY - CrosshairSize - CrosshairGap, ScreenX + CrosshairThickness, ScreenY - CrosshairGap, CrosshairColor, 0)

        -- BOTTOM LINE
        Render.RectFilled(ScreenX - CrosshairThickness, ScreenY + CrosshairSize + CrosshairGap, ScreenX + CrosshairThickness, ScreenY + CrosshairGap, CrosshairColor, 0)
    end

    -- CROSSHAIR DOT
    if (Menu.GetInt("iDotType") == 2) then
        Render.CircleFilled(ScreenX, ScreenY, DotSize, CrosshairColor, 100 * DotSize)
    else
        if (Menu.GetInt("iDotType") == 1) then
            Render.RectFilled(ScreenX - DotSize, ScreenY - DotSize, ScreenX + DotSize, ScreenY + DotSize, CrosshairColor, 0)
        else
            return
        end
    end
end

Hack.RegisterCallback("PaintTraverse", Crosshair)

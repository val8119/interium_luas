-- Init Menu
Menu.Spacing()
Menu.Separator()
Menu.Spacing()
Menu.Text("Teammate decoy ESP")
Menu.Checkbox("Enable decoy circle", "bDecoy", true)
Menu.Spacing()
Menu.Checkbox("Enable decoy text", "bDecoyText", true)
Menu.Spacing()
Menu.ColorPicker("Decoy circle color", "cDecoyColor", 255, 0, 0, 75)
Menu.ColorPicker("Decoy text Color", "cDecoyTextColor", 255, 255, 255, 255)
Menu.Spacing()
Menu.SliderFloat("Decoy circle size", "fDecoyCircleSize", 1, 30, "%.0f", 5)
Menu.SliderFloat("Decoy text size", "fDecoyTextSize", 6, 32, "%.0f", 14)
Menu.SliderFloat("Decoy text y-offset", "fDecoyTextyOffset", 0, 200, "%.0f", 30)
Menu.Spacing()
Menu.Checkbox("Enable decoy notification", "bDecoyNotification", false)
Menu.Text("Need file: \n*appdata*\\INTERIUM\\CSGO\\FilesForLUA\\Decoy.wav")

local Show = false
local VectorEnd = Vector.new()
TimerPrintInChat = false

function DecoyStarted(Event)
    VectorEnd = Vector.new(Event:GetInt("x", 0), Event:GetInt("y", 0), Event:GetInt("z", 0))
end

function FireEventClientSideThink(Event)
    if (not Menu.GetBool("bDecoyText")) then
        return
    end
    if (not Utils.IsLocal()) then
        return
    end

    if (Event:GetName() == "decoy_started") then
        local Player = IEntityList.GetPlayer(IEngine.GetPlayerForUserID(Event:GetInt("userid", 0)))
        if (Player and Player:GetClassId() == 40 and Player:IsTeammate()) then
            local WeaponUserUID = Event:GetInt("userid")
            local WeaponUserEntityID = IEngine.GetPlayerForUserID(WeaponUserUID)

            local Player = IEntityList.GetPlayer(WeaponUserEntityID)
            if (not Player) then
                return
            end

            local PlayerInfo = CPlayerInfo.new()
            if (not Player:GetPlayerInfo(PlayerInfo)) then
                return
            end

            Name = PlayerInfo.szName

            if (Menu.GetBool("bDecoyNotification") == true) then
                PlaySound(GetAppData() .. "\\INTERIUM\\CSGO\\FilesForLUA\\Decoy.wav")
            end

            IChatElement.ChatPrintf(0, 0, "\x01[interium] " .. "\x07" .. Name .. " \x01threw a \x07decoy!")

            DecoyStarted(Event)
            Show = true
        end
    end

    if (Event:GetName() == "decoy_detonate") then
        Show = false

        local Player = IEntityList.GetPlayer(IEngine.GetPlayerForUserID(Event:GetInt("userid", 0)))
        if (Player and Player:GetClassId() == 40 and Player:IsTeammate()) then
            local WeaponUserUID = Event:GetInt("userid")
            local WeaponUserEntityID = IEngine.GetPlayerForUserID(WeaponUserUID)

            local Player = IEntityList.GetPlayer(WeaponUserEntityID)
            if (not Player) then
                return
            end

            local PlayerInfo = CPlayerInfo.new()
            if (not Player:GetPlayerInfo(PlayerInfo)) then
                return
            end

            IChatElement.ChatPrintf(0, 0, "\x01[interium] " .. "\x07decoy " .. "\x01detonated!")

        end
    end

    if (Event:GetName() == "round_start") then
        Show = false
    end
end

function PaintTraverse()
    if (not Menu.GetBool("bDecoyText")) then
        return
    end
    if (not Utils.IsLocal()) then
        return
    end
    if (not Show) then
        return
    end

    local DecoyTextColor = Menu.GetColor("cDecoyTextColor")
    local DecoyColor = Menu.GetColor("cDecoyColor")
    local DecoyTextSize = Menu.GetFloat("fDecoyTextSize")
    local DecoyCircleSize = Menu.GetFloat("fDecoyCircleSize")
    local DecoyTextyOffset = Menu.GetFloat("fDecoyTextyOffset")

    local ToScreen = Vector.new()

    if (Math.WorldToScreen(VectorEnd, ToScreen)) then
        if (Menu.GetBool("bDecoy")) then
            Render.CircleFilled3D(VectorEnd, DecoyCircleSize * 6, DecoyCircleSize, DecoyColor)
        end
        if (Menu.GetBool("bDecoyText")) then
            Render.Text_1(
                Name .. "'s decoy",
                ToScreen.x,
                ToScreen.y - DecoyTextyOffset,
                DecoyTextSize,
                DecoyTextColor,
                true,
                true
            )
        end
    end
end

Hack.RegisterCallback("PaintTraverse", PaintTraverse)
Hack.RegisterCallback("FireEventClientSideThink", FireEventClientSideThink)
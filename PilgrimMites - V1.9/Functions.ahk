PilgrimMites(M, H) {
Middle := ( M + H ) / 2
    Random, r1, 0, Middle - M, A_Now . A_IsCritical . %A_TickCount%
    Random, r2, 0, H - Middle, A_Now . A_IsCritical . %A_TickCount%
    Anchor := M + r1 + r2
    if (Anchor < M || Anchor > H) {
        MsgBox, 49, Anchor Error, % "Invalid anchor: " . Anchor . "`nRestarting`nPlease contact PilgrimMites if this message appears."
        Reload
    } else {
        Return Anchor
    }
}

GunSelection(Gun := 0, human :=  0, wait := 0) {
If (Gun != "", human != "", wait != "") {
	Global GunPattern:=Gun, humanizer :=  human, waitdivider := wait
	Sleep, 1
		Speak(GunPattern)
		If (GunPattern = "Recoil OFF") {
			Sleep, 1
			ShowToolTip(GunPattern , , , 1)
		} if InStr("AK|M4A1|M4A4|FAMAS|GALIL|UMP|AUG|SG", GunPattern) {
			Sleep, 1
			ShowToolTip(GunPattern " | ON" , , , 1)
		} if (GunPattern = "UniversalRCS") {
			Sleep, 1
			UniversalRCS:= 1
			if (GuiVisible) {
				Gosub GUI_UNIRCS
				GuiControl, Hide, Humanizer
			}
		} if (GunPattern != "UniversalRCS") {
			UniversalRCS:= 0
			if (GuiVisible) {
				Gosub GUI_UNIRCS
				GuiControl, Hide, Humanizer
			}
			
		}
	;CustomSave(GunPattern,"General", "GunPattern")
	} Else {
		MsgBox, 48, ERROR!, Gunselection Function needs `nParam #1 Gun = %Gun%.`nParam #2 human = %human%.`nParam #3 wait = %wait%, 10
	}
}

Click(Delay_Min:=35.0, Delay_Max:=60.0,SpamPrevent_Min:=35.0,SpamPrevent_Max:=60.0) {
DllCall("user32.dll\mouse_event", uint, 0x0002, int, 0, int, 0, uint, 0, int, 0)
	Sleep, PilgrimMites(Delay_Min, Delay_Max)
DllCall("user32.dll\mouse_event", uint, 0x0004, int, 0, int, 0, uint, 0, int, 0)
    Sleep, PilgrimMites(SpamPrevent_Min, SpamPrevent_Max)
}

Random(min, max) {
	Random, R1, min, max
	Random, R2, max, min
	Random, R, R1, R2
	If (R > Min || R < Max) {
		return r
	} Else {
		MsgBox, 48, ERROR!,Failed Random %r%. `nError code: %ErrorLevel%
	}
}

Rand(range=8) {
    Random, r, -%range%, +%range%
    Return R
}

TRandom(min, max, value := 0.28) {
	target := (min + max) / 2
	range := (max - min) * value
	min_range := target - range
	max_range := target + range
	Random, anchor, min_range, max_range, A_Now . A_IsCritical . %A_TickCount%
Return anchor
}

MoveMouse(x := 0,y := 0) {
    DllCall("user32.dll\mouse_event", "UInt", 0x01, "Int", x, "Int", y)
	Sleep 1
}

KeyPress(Key, Sleepmin := 80, SleepMax := 125) {
    DllCall("user32.dll\keybd_event", "UInt", Key, "UInt", 0, "UInt", 0, "UInt", 0)
    Sleep, Random(Sleepmin, SleepMax)
    DllCall("user32.dll\keybd_event", "UInt", Key, "UInt", 0, "UInt", 2, "UInt", 0)
    Sleep, Random(Sleepmin, SleepMax)
}

strafe() {
    Static x, lastX
    CoordMode Mouse
    lastX := x
    MouseGetPos x

    if (lastX = "")
        return

    if (lastX > x) {
        if (!GetKeyState("a"))
            SendInput {d up}{a down}
    }
    else if (lastX < x) {
        if (!GetKeyState("d"))
            SendInput {a up}{d down}
    }
    else if (GetKeyState("a") && GetKeyState("d")) {
        Send {a up}{d up}
		SoundBeep 1500
    }
}

ShowToolTip(Text = "", X = 1, Y = 0, WhichToolTip1 := 1, Timer := 0) {

    if (RCSNotification) {
        ToolTip, , , , %WhichToolTip1%
        ToolTip, %Text%, %X%, %Y%, %WhichToolTip1%
        ToolTips.push(WhichToolTip1) ; Add the new tooltip index to the array
        if (Timer >= 1) {
            SetTimer, HideToolTip, % Timer * 1000
        }
    } else {
        ; Close all active tooltips
        for Each, tooltip in ToolTips {
            ToolTip, , , , %tooltip%
        }
        ToolTips := [] ; Clear the array of active tooltips
    }
}

HideToolTip:
SetTimer, HideToolTip, Off
ToolTip, , , , %ToolTips%
return


Speak(text, Volume = 90, Rate = 1.5) {
    if (SpeechT) {
        if (A_OSVersion > 10) {
			sp := ComObjCreate("SAPI.SpVoice")
			sp.Rate := Rate
			sp.Volume := Volume
			sp.Speak(text)
        } else {
            speaker := ComObjCreate("SAPI.SpVoice")
            speaker.Rate := Rate
            speaker.Volume := Volume
            speaker.Speak(text)
        }
    }
}

ReadSettings() {
    if (FileExist("Settings.ini")) {
		IniRead, sens, Settings.ini, General, sens
		IniRead, zoomsens, Settings.ini, General, zoomsens
		IniRead, Speed, Settings.ini, General, Speed
		IniRead, RCSPercent, Settings.ini, General, RCSPercent
		IniRead, GunPattern, Settings.ini, General, GunPattern

        IniRead, Key_AK, Settings.ini, Hotkeys, Key_AK, %Key_AK%
        IniRead, Key_M4A1, Settings.ini, Hotkeys, Key_M4A1, %Key_M4A1%
        IniRead, Key_M4A4, Settings.ini, Hotkeys, Key_M4A4, %Key_M4A4%
        IniRead, Key_Famas, Settings.ini, Hotkeys, Key_Famas, %Key_Famas%
        IniRead, Key_Galil, Settings.ini, Hotkeys, Key_Galil, %Key_Galil%
        IniRead, Key_UMP, Settings.ini, Hotkeys, Key_UMP, %Key_UMP%
        IniRead, Key_AUG, Settings.ini, Hotkeys, Key_AUG, %Key_AUG%
        IniRead, Key_SG, Settings.ini, Hotkeys, Key_SG, %Key_SG%
        IniRead, Key_180, Settings.ini, Hotkeys, Key_180, %Key_180%
        IniRead, Key_RCoff, Settings.ini, Hotkeys, Key_RCoff, %Key_RCoff%
        IniRead, Key_RapidFire, Settings.ini, Hotkeys, Key_RapidFire, %Key_RapidFire%
        IniRead, Key_PixelBot, Settings.ini, Hotkeys, Key_PixelBot, %Key_PixelBot%
		IniRead, Key_BHOP, Settings.ini, Hotkeys, Key_BHOP
		IniRead, Key_UniversalRCS, Settings.ini, Hotkeys, Key_UniversalRCS

		IniRead, TriggerBotT, Settings.ini, PixelBot, TriggerBotT
		IniRead, reaction_min, Settings.ini, PixelBot, reaction_min
		IniRead, reaction_max, Settings.ini, PixelBot, reaction_max

		IniRead, CrossHairT, Settings.ini, CrossHair, CrossHairT
		IniRead, CrossHairTrans, Settings.ini, CrossHair, CrossHairTrans
		IniRead, SelectedCrosshair, Settings.ini, CrossHair, SelectedCrosshair
		IniRead, CrossHairSize, Settings.ini, CrossHair, CrossHairSize
		IniRead, CrossHairColor, Settings.ini, CrossHair, CrossHairColor

		IniRead, RapidFireT, Settings.ini, RapidFire, RapidFireT
		IniRead, RFL, Settings.ini, RapidFire, RFL
		IniRead, RFH, Settings.ini, RapidFire, RFH

		IniRead, Magnifier, Settings.ini, Magnifier, Magnifier
		IniRead, Zoom, Settings.ini, Magnifier, Zoom
		IniRead, Size, Settings.ini, Magnifier, Size
		IniRead, Delay, Settings.ini, Magnifier, Delay
		IniRead, MagnifierTrans, Settings.ini, Magnifier, MagnifierTrans

		IniRead, BHOPT, Settings.ini, BHOP, BHOPT
		IniRead, Legit, Settings.ini, BHOP, Legit
		IniRead, Perfect, Settings.ini, BHOP, Perfect
		IniRead, ScrollWheel, Settings.ini, BHOP, ScrollWheel

		IniRead, RCSNotification, Settings.ini, Toggle, RCSNotification
		IniRead, TriggerBotNotification, Settings.ini, Toggle, TriggerBotNotification
		IniRead, TurnAroundT, Settings.ini, Toggle, TurnAroundT
		IniRead, RecoilSafety, Settings.ini, Toggle, RecoilSafety
		IniRead, UniversalRCS, Settings.ini, Toggle, UniversalRCS
		IniRead, SpeechT, Settings.ini, Toggle, SpeechT
		IniRead, CounterStrafeT, Settings.ini, Toggle, CounterStrafeT
    } else {
        MsgBox, 4, Error,Settings.ini does NOT exist.`nWould you like to Create it?
		ifMsgBox, Yes
		{
		Gosub FindSettings
		} else {
		Return
		}
    }
}

SaveSettings() {
    if (FileExist("Settings.ini")) {
		IniWrite, %sens%, Settings.ini, General, sens
		IniWrite, %zoomsens%, Settings.ini, General, zoomsens
		IniWrite, %Speed%, Settings.ini, General, Speed
		IniWrite, %GunPattern%, Settings.ini, General, GunPattern
		IniWrite, %RCSPercent%, Settings.ini, General, RCSPercent

        IniWrite, %Key_AK%, Settings.ini, Hotkeys, Key_AK
        IniWrite, %Key_M4A1%, Settings.ini, Hotkeys, Key_M4A1
        IniWrite, %Key_M4A4%, Settings.ini, Hotkeys, Key_M4A4
        IniWrite, %Key_Famas%, Settings.ini, Hotkeys, Key_Famas
        IniWrite, %Key_Galil%, Settings.ini, Hotkeys, Key_Galil
        IniWrite, %Key_UMP%, Settings.ini, Hotkeys, Key_UMP
        IniWrite, %Key_AUG%, Settings.ini, Hotkeys, Key_AUG
        IniWrite, %Key_SG%, Settings.ini, Hotkeys, Key_SG
        IniWrite, %Key_180%, Settings.ini, Hotkeys, Key_180
        IniWrite, %Key_RCoff%, Settings.ini, Hotkeys, Key_RCoff
        IniWrite, %Key_RapidFire%, Settings.ini, Hotkeys, Key_RapidFire
        IniWrite, %Key_PixelBot%, Settings.ini, Hotkeys, Key_PixelBot
        IniWrite, %Key_Safety%, Settings.ini, Hotkeys, Key_Safety
		IniWrite, %Key_BHOP%, Settings.ini, Hotkeys, Key_BHOP
		IniWrite, %Key_UniversalRCS%, Settings.ini, Hotkeys, Key_UniversalRCS

		IniWrite, %TriggerBotT%, Settings.ini, PixelBot, TriggerBotT
		IniWrite, %reaction_min%, Settings.ini, PixelBot, reaction_min
		IniWrite, %reaction_max%, Settings.ini, PixelBot, reaction_max

		IniWrite, %CrossHairT%, Settings.ini, CrossHair, CrossHairT
		IniWrite, %CrossHairTrans%, Settings.ini, CrossHair, CrossHairTrans
		IniWrite, %SelectedCrosshair%, Settings.ini, CrossHair, SelectedCrosshair
		IniWrite, %CrossHairSize%, Settings.ini, CrossHair, CrossHairSize
		IniWrite, %CrossHairColor%, Settings.ini, CrossHair, CrossHairColor

		IniWrite, %RapidFireT%, Settings.ini, RapidFire, RapidFireT
		IniWrite, %RFL%, Settings.ini, RapidFire, RFL
		IniWrite, %RFH%, Settings.ini, RapidFire, RFH

		IniWrite, %Magnifier%, Settings.ini, Magnifier, Magnifier
		IniWrite, %Zoom%, Settings.ini, Magnifier, zoom
		IniWrite, %Size%, Settings.ini, Magnifier, Size
		IniWrite, %Delay%, Settings.ini, Magnifier, Delay
		IniWrite, %MagnifierTrans%, Settings.ini, Magnifier, MagnifierTrans

		IniWrite, %BHOPT%, Settings.ini, BHOP, BHOPT
		IniWrite, %Legit%, Settings.ini, BHOP, Legit
		IniWrite, %Perfect%, Settings.ini, BHOP, Perfect
		IniWrite, %ScrollWheel%, Settings.ini, BHOP, ScrollWheel

		IniWrite, %RCSNotification%, Settings.ini, Toggle, RCSNotification
		IniWrite, %TriggerBotNotification%, Settings.ini, Toggle, TriggerBotNotification
		IniWrite, %TurnAroundT%, Settings.ini, Toggle, TurnAroundT
		IniWrite, %RecoilSafety%, Settings.ini, Toggle, RecoilSafety
		IniWrite, %UniversalRCS%, Settings.ini, Toggle, UniversalRCS
		IniWrite, %SpeechT%, Settings.ini, Toggle, SpeechT
		IniWrite, %CounterStrafeT%, Settings.ini, Toggle, CounterStrafeT

    } else {
        MsgBox, 4, Error,Settings.ini does NOT exist.`nWould you like to Create it?
		ifMsgBox, Yes
		{
		Gosub FindSettings
		} else {
		Return
		}
    }
}

CustomSave(Value, Section, Name) {
    if (FileExist("Settings.ini")) {
        IniWrite, %Value%, Settings.ini, %Section%, %Name%
        if ErrorLevel
        {
            MsgBox, Error writing to Settings.ini. `n Error: %ErrorLevel%
        }
        else
        {
            ;MsgBox,,,Saving`nName : %Name%`nsection : %section%`nValue : %Value%, 1
        }
    } else {
        MsgBox, 4, Error, Settings.ini does NOT exist.`nWould you like to Create it?
        ifMsgBox, Yes
        {
            Gosub FindSettings
        } else {
            Return
        }
    }
}

CustomRead(Value, Section, Name) {
    if (FileExist("Settings.ini")) {
        IniRead, %Value%, Settings.ini, %Section%, %Name%
		if ErrorLevel
        {
            MsgBox, Error writing to Settings.ini. `n Error: %ErrorLevel%

        }
        else
        {
            ;MsgBox,,,Reading`nName : %Name%`nsection : %section%`nValue : %Value%, 1


        }
    } else {
        MsgBox, 4, Error,Settings.ini does NOT exist.`nWould you like to Create it?
		ifMsgBox, Yes
		{
		Gosub FindSettings
		} else {
		Return
		}
    }
}

RunAsAdmin() {
	Global 0
	IfEqual, A_IsAdmin, 1, Return 0
	Loop, %0%
		params .= A_Space . %A_Index%
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath : A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	ExitApp
}

HasDuplicates(arr) {
    disallowedHotkeys := ["^r", "End", "Pause"] ; List of disallowed hotkeys
    unique := {}

    for index, value in arr {
        if (unique.HasKey(value)) {
		     MsgBox, 48, Duplicate Hotkeys Found, Duplicate hotkeys were found. Please make sure each hotkey is unique.
            return true
        }

        ; Check if the current value is a disallowed hotkey
        for _, hotkey in disallowedHotkeys {
            if (value = hotkey) {
			msgbox, This KeyBind is not Allowed, by Pilgrim_Mite. %E1%
                return true
            }
        }

        unique[value] := true
    }

    return false
}

; Function to get process name based on PID
GetProcessName(PID) {
    Process, Exist, %PID%
    return (ErrorLevel) ? "Unknown Process Name" : ProcessName
}

ProcessExist(Name) {
    Process, Exist, %Name%
    return ErrorLevel
}

PictureCheck(Image_Name, URL) {
    if (FileExist(Image_Name)) {
        ; File already exists
    } else {
        Gui, PictureCheck: Add, Progress, vProgressRange cGreen w200, Downloading...
        Gui, PictureCheck: Add, Text, , Downloading %Image_Name%`nfrom %URL%
        Gui, PictureCheck: Show,, %A_UserName%
        Progress := 0
        SetTimer, Update_Progress_Bar, 10
        URLDownloadToFile, %URL%, %Image_Name%
		Sleep, 1000
        Gui, PictureCheck: Destroy
		    if (!FileExist(Image_Name)) {
				SetTimer, Update_Progress_Bar, Off
				MsgBox, 48, ERROR!, Failed to save %Image_Name%. Error code: %ErrorLevel%, 5
			}
		if (Image_Name = "FBI_Evee.png") {
			if (FileExist(Image_Name)) {
				MsgBox, , Agent Evee Status Report,The Helicopter found and saved Evee. Hazaah!
				Menu, Tray, Icon, FBI_Evee.PNG, ,1
			}
		} Else {
			if (FileExist(Image_Name)) {
				MsgBox, , %Image_Name% Status Report,%Image_Name% Saved.
				Menu, Tray, Icon, %Image_Name%, ,1
			}
		}
			if (ErrorLevel = 1) {
				MsgBox, 48, ERROR!, Failed to save %Image_Name%. Error code: %ErrorLevel%, 5
			}
		}
	}


/*
GenerateRandomUUID() {
    Random, part1, 0, 0xFFFF
    Random, part2, 0, 0xFFFF
    Random, part3, 0, 0xFFFF
    Random, part4, 0, 0xFFFF
    part1 := Format("{:04X}", part1)
    part2 := Format("{:04X}", part2)
    part3 := Format("{:04X}", part3)
    part4 := Format("{:04X}", part4)
    UUID := part1 . part2 . part3 . part4
    ;MsgBox, New Randomized UUID: %UUID%
	return UUID

}

ToggleHotkey(oldHotkey, newHotkey, actionHandler) {
    global
    if (oldHotkey != newHotkey) {
        if (oldHotkey != "") {
            Hotkey, %oldHotkey%, Off  ; Turn off the previous hotkey
        }
        Hotkey, %newHotkey%, %actionHandler%  ; Set the new hotkey
    }
}

isMouseShown() ;It suspends the script when mouse is visible (map, inventory, menu).
{
  StructSize := A_PtrSize + 16
  VarSetCapacity(InfoStruct, StructSize)
  NumPut(StructSize, InfoStruct)
  DllCall("GetCursorInfo", UInt, &InfoStruct)
  Result := NumGet(InfoStruct, 8)

  if Result > 1
    Return 1
  else
    Return 0
}
Loop
{
  if isMouseShown() == 1
    Suspend On
  else
    Suspend Off
    Sleep 1
}

English (United States): 409 or en-US
English (United Kingdom): 809 or en-GB
Spanish (Spain): 40A or es-ES
Spanish (Mexico): 80A or es-MX
French (France): 40C or fr-FR
French (Canada): C0C or fr-CA
German (Germany): 407 or de-DE
Italian (Italy): 410 or it-IT
Japanese: 411 or ja-JP
Chinese (Simplified): 804 or zh-CN
Chinese (Traditional): 404 or zh-TW

	Tooltip, % "ErrorLevel:      " ErrorLevel              "`n`n"
                    . "Target color:   "  colorPB            "`n`n"
                    . "Pixel mode:    "   A_CoordModePixel "`n`n"
                    . "Coordinates:   "   Center_X ", " Center_Y         "`n`n"
                    . "Window title:  "   title

*/
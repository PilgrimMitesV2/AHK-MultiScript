PilgrimMites(M, H) {
Middle := ( M + H ) / 2
    Random, r1, 0, Middle - M, A_Now . A_IsCritical
    Random, r2, 0, H - Middle, A_Now . A_IsCritical
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
		Gosub UniversalRCS_handler
		If (GunPattern = "Recoil OFF") {
			ShowToolTip(GunPattern , , , 1)
		} if InStr("AK|M4A1|M4A4|FAMAS|GALIL|UMP|AUG|SG", GunPattern) {
			ShowToolTip(GunPattern " | ON" , , , 1)
		}
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
	Random, R1, min, max, A_IsCritical
	Random, R2, max, min, A_IsCritical
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
	Random, anchor, min_range, max_range, A_Now . A_IsCritical
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

ShowToolTip(Text = "", X = 1, Y = 0, WhichToolTip1 := 1, Timer := 0) {
    if (RCSNotification) {
        ToolTip, , , , %WhichToolTip1%
        ToolTip, %Text%, %X%, %Y%, %WhichToolTip1%
        ToolTips.push(WhichToolTip1)
        if (Timer >= 1) {
            SetTimer, HideToolTip, % Timer * 1000
        }
    } else {
        for Each, tooltip in ToolTips {
            ToolTip, , , , %tooltip%
        }
        ToolTips := []
    }
}

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

        for _, hotkey in disallowedHotkeys {
            if (value = hotkey) {
				msgbox, This KeyBind is not Allowed, by PilgrimMites. `n%E1%
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
		
isMouseShown() {
    StructSize := A_PtrSize + 16
    VarSetCapacity(InfoStruct, StructSize)
    NumPut(StructSize, InfoStruct)
    DllCall("GetCursorInfo", UInt, &InfoStruct)
    Result := NumGet(InfoStruct, 8)
	;ToolTip, Result %Result%`nSuspend %a_isSuspended%
    if (Result = 65545 || 65543) {
		Suspend, On
    } Else  {
		Suspend, Off
	if (GuiVisible) {
			Suspend, Off
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
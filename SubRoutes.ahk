RCS:
modifier := 2.52 / sens
RecoilScaled:=(RCSPercent * .01)
IfWinActive, ahk_exe CS2.exe
{
    if InStr("AK|M4A1|M4A4|FAMAS|GALIL|UMP|AUG|SG", GunPattern) {
	Sleep, 30
        for each, action in pattern {
			X:=(action[1]/humanizer*modifier)* RecoilScaled
			Y:=(action[2]/humanizer*modifier)* RecoilScaled
			if (GetKeyState(key_Zoom, "P") && GunPattern = "AUG" || GunPattern = "SG" ) {
				obs := .75/Zoomsens
				X:=((action[1]/humanizer*modifier)*obs)* RecoilScaled
				Y:=((action[2]/humanizer*modifier)*obs)* RecoilScaled
			}
			SleepTime:=action[3]/waitdivider
            Loop, 4 {
                DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", X  , "UInt", Y)
                Sleep, % SleepTime
                if !GetKeyState(key_shoot, "P") {
                    RETURN
                }
            }
        }
        if !GetKeyState(key_shoot, "P") {
            RETURN
        }
        DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
		Goto ReloadGun
	}
}
    if (GunPattern = "UniversalRCS" && UniversalRCS) {
		loop {
			UniversalRCS_HumanizeUniversal:= % (HumanizeUniversal ? xMath : 0)
			xMath := ((Rand(2.0) - Rand(3.0)) * .5 ) * RecoilScaled
			humanizer := 4
			x := UniversalRCS_HumanizeUniversal
			y := (Speed * humanizer / modifier) * RecoilScaled
			MoveMouse(x,y)
			if !GetKeyState(key_shoot, "P") || rapidfireT {
				break
			}
		}
	}
Return

ToggleGUI:
if (GuiVisible) {
	GoSub GuiClose
} Else {
    GoSub MainGui
}
Return

MainGui:
if !GuiVisible {
		;Gui, Add, Picture, x1 y1 w330 h455, %A_ScriptDir%\Background.jpg
	Menu, Tray, check, Toggle Main Menu
	Tabs := "Recoil|PixelBot|RapidFire|BHOP|Magnifier|Crosshair|Extras"
	GuiVisible := true
	Gui, +AlwaysOnTop  +Owner -MinimizeBox +0x400000
	Gui, Margin, 0, 0
	Gui, Color, Black
	Gui, Font, cWhite s14, Impact
	Gui, Add, Text, x5 y400, Good Luck`, Have Fun!
	Gui, Add, Tab, xM+0 yM+0 Section w330 h400 c0x3db7f7, %Tabs%
	
	Gui, tab, Recoil
	Gui, Add, GroupBox, xs+10 ys+55 Section w160 H330 c0xFFC000 ,RCS
	Gui, Add, text, xs+5  ys+25 c0x00ff18, Scoped-IN:
	Gui, Add, Hotkey, xs+95  ys+23   w60 vKey_Zoom, %Key_Zoom%

	Gui, Add, Text, xs+5  ys+55 c0x00ff18, AK-47:
	Gui, Add, Hotkey, xs+55  ys+53   w100 vKey_AK, %Key_AK%
	Gui, Add, Text, xs+5  ys+85 c0x00ff18, M4A1:
	Gui, Add, Hotkey, xs+55  ys+83    w100 vKey_M4A1, %Key_M4A1%
	Gui, Add, Text, xs+5  ys+115 c0x00ff18, M4A4:
	Gui, Add, Hotkey, xs+55  ys+113    w100 vKey_M4A4, %Key_M4A4%
	Gui, Add, Text, xs+5  ys+145 c0x00ff18, Famas:
	Gui, Add, Hotkey, xs+65  ys+143    w90 vKey_Famas, %Key_Famas%
	Gui, Add, Text, xs+5  ys+175 c0x00ff18, Galil:
	Gui, Add, Hotkey, xs+55  ys+173    w100 vKey_Galil, %Key_Galil%
	Gui, Add, Text, xs+5  ys+205 c0x00ff18, UMP:
	Gui, Add, Hotkey, xs+55  ys+203    w100 vKey_UMP, %Key_UMP%
	Gui, Add, Text, xs+5  ys+235 c0x00ff18, AUG:
	Gui, Add, Hotkey, xs+55  ys+233    w100 vKey_AUG, %Key_AUG%
	Gui, Add, Text, xs+5  ys+265 c0x00ff18, SG:
	Gui, Add, Hotkey, xs+55  ys+263    w100 vKey_SG, %Key_SG%
	Gui, Add, Text, xs+5  ys+295 c0x00ff18, Recoil Off:
	Gui, Add, Hotkey, xs+95  ys+293    w60 vKey_RCoff, %Key_RCoff%

	Gui, Add, GroupBox, xs+162 ys+5 W150 H325 c0xFFC000 +Center,Other
	RCSNotificationColor:= % (RCSNotification ? "Green" : "0xCB0000")
	Gui, Add, CheckBox, xS+170 ys+30 Checked%RCSNotification% gCheckBoxHandler c%RCSNotificationColor% , Notification

	UniversalRCSColor:= % (UniversalRCS ? "Green" : "0xCB0000")
	Gui, Add, CheckBox, xS+170 ys+60 Checked%UniversalRCS% gCheckBoxHandler c%UniversalRCSColor%, Universal RCS

	HumanizeUniversalColor:= % (HumanizeUniversal ? "Green" : "0xCB0000")
if (!UniversalRCS) {
	Gui, Add, CheckBox, xS+170 ys+80 Checked%HumanizeUniversal% gCheckBoxHandler c%HumanizeUniversalColor% Hidden, Humanizer
} Else {
	Gui, Add, CheckBox, xS+170 ys+80 Checked%HumanizeUniversal% gCheckBoxHandler c%HumanizeUniversalColor%, Humanizer
}
	Gui, Add, text, xs+170  ys+105 c0x00ff18, Hotkey:
	Gui, Add, Hotkey, xs+170  ys+135   w60 vKey_UniversalRCS, %Key_UniversalRCS%

	Gui, Add, text, xs+248  ys+105 c0xc548ec, Speed:
	Gui, Add, Edit, xs+250  ys+135    w50 cBlack vSpeed1, %Speed%

	Gui, Add, Text, xS+180 ys+180 c0xFFC000, Recoil Percent
	Gui, Add, Slider, xs+167  ys+205   w140 cBlack vRCSPercent1 gRCS_Slider +ToolTip +Range10-100, %RCSPercent%


	Gui, Add, text, xs+167  ys+247 c0xc548ec, Sensitivity:
	Gui, Add, Edit, xs+257  ys+245    w50 cBlack vSens1, % sens

	Gui, Add, Button, xS+180 ys+280  w110 h40 gButtonHandler +0x8000, Save Recoil

	Gui, Font, s20, Impact

	Gui, tab, PixelBot
	PixelBotGUIColor := % (TriggerBotT ? "Green" : "0xCB0000")
	Gui, Add, CheckBox, xS+95 ys+30 Checked%TriggerBotT% c%PixelBotGUIColor% gCheckBoxHandler, PixelBot
	Gui, Add, Combobox, xS+80 ys+70 w150 vKey_PixelBot, XButton1|XButton2|Z|X|C|Alt|Ctrl|CapsLock
	GuiControl, Choose, Key_PixelBot, %Key_PixelBot%
	Gui, Add, Text, xS+5 ys+120 h20 c0xc548ec Center, Min:
	Gui, Add, edit, xS+5 ys+150 cBlack vReactionMin, %reaction_min%
	Gui, Add, Text, xS+245 ys+120 h20 c0xc548ec Center, Max:
	Gui, Add, edit, xS+245 ys+150 cBlack vReactionMax, %reaction_max%
	GUI Add, Text, xS+80 ys+130 c0xB0AE3B BackgroundTrans, Shoots When`nCenter Pixel`nChanges Color
	TriggerBotNotificationGUIColor := % (TriggerBotNotification ? "Green" : "0xCB0000")
	Gui, Add, CheckBox, xS+35 ys+260 Checked%TriggerBotNotification% gCheckBoxHandler c%TriggerBotNotificationGUIColor%, PixelBot Notification
	Gui, Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save Pixel Bot

	Gui, tab, RapidFire
	RapidFireGUIColor := % (RapidFireT ? "Green" : "0xCB0000")
	Gui, Add, CheckBox, xS+90 ys+30 Checked%RapidFireT% gCheckBoxHandler c%RapidFireGUIColor%, RapidFire
	Gui, Add, Combobox, xS+80 ys+70 w150 vKey_RapidFire, XButton1|XButton2|LButton|Z|X|C|Alt|Ctrl|CapsLock
	GuiControl, Choose, Key_RapidFire, %Key_RapidFire%
	Gui, Add, Text, xS+5 ys+120 h20 c0xc548ec Center, Min:
	Gui, Add, edit, xS+5 ys+150 cBlack vRFL1, %RFL%
	Gui, Add, Text, xS+245 ys+120 h20 c0xc548ec Center, Max:
	Gui, Add, edit, xS+245 ys+150 cBlack vRFH1, %RFH%
	Gui, Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save Rapid Fire

	Gui, Tab, BHOP
	Gui, Add, GroupBox, xS+5 yS+5 w200 h170 c0xFFC000, Settings
	Gui, Add, CheckBox, xS+20 yS+45 h35 Checked%BHOPT% c%BHOP_GUIColor% gCheckBoxHandler, BHOP
	Gui, Add, Hotkey, xS+20 yS+85 w160 h35 vKey_BHOP, %Key_BHOP%

	Gui, Add, GroupBox, xS+5 yS+185 w200 h130 c0xFFC000, Modes
	Gui, Add, Radio, xS+20 yS+225 w150 h25 Checked%Legit% vLegit gBHOP_Handler, Legit
	Gui, Add, Radio, xS+20 yS+255 w150 h25 Checked%Perfect% vPerfect gBHOP_Handler, Perfect
	Gui, Add, Radio, xS+20 yS+285 w160 h25 Checked%ScrollWheel% vScrollWheel gBHOP_Handler, ScrollWheel

	Gui, Add, Button, xS+215 ys+25  w90 h60 gButtonHandler +0x8000, BHOP TIPS
	Gui, Add, Button, xS+215 ys+255  w90 h60 gButtonHandler +0x8000, Save BHOP
	GoSub GUIBHOP

	Gui, Tab, Magnifier
	MagnifierGUIColor := % (Magnifier ? "Green" : "0xCB0000")
	Gui, Add, CheckBox, xS+50 ys+15 Checked%Magnifier% gCheckBoxHandler c%MagnifierGUIColor%,  Magnifying Glass


	Gui, Add, GroupBox, xS+5 yS+60 w300 h110 c0xFFC000 +Center, Settings
	Gui, Add, Text, xS+15 ys+90 h20 c0xc548ec Center, Zoom
	Gui, Add, Edit, xS+25 ys+120 cBlack vZoom1, %Zoom%
	Gui, Add, Text, xS+128 ys+90 h20 c0xc548ec Center, Size
	Gui, Add, Edit, xS+125 ys+120 cBlack vSize1, %Size%
	Gui, Add, Text, xS+230 ys+90 h20 c0xc548ec Center, Timer
	Gui, Add, Edit, xS+235 ys+120 cBlack vDelay1, %Delay%

	Gui, Add, Text, xS+25 ys+180 h20 Center c0xB0AE3B, Save to change Settings.

	Gui, Add, GroupBox, xS+5 ys+220 h20 Center w300 h80 c0xFFC000, Transparency Slider
	Gui, Add, Slider, xS+10 ys+260 W290 vMagnifierTrans gMagnifierTrans1 +ToolTip +Range0.0-224, %MagnifierTrans%

	Gui, Add, Button, xS+35 ys+305 w250 h30  gButtonHandler, Save Magnifier

	Gui, Tab, Crosshair
	CrosshairGUIColor:= % (CrosshairT ? "Green" : "0xCB0000")
	Gui, Add, CheckBox, xS+50 ys+15 Checked%CrosshairT% c%CrosshairGUIColor% gCheckBoxHandler, CrossHair Toggle

	Gui, Add, GroupBox, xS+5 yS+50 w300 h90 c0xFFC000 +Center, Settings
	Gui, Add, Text, xS+10 ys+85 h20 c0xc548ec Center, Size:
	Gui, Add, Edit, xS+65 ys+83 cBlack vCrosshairSize, %CrosshairSize%
	Gui, Add, Text, xS+125 ys+85 h20 c0xc548ec Center, Color:
	Gui, Add, Edit, xS+195 ys+83 cBlack vCrossHairColor, %CrossHairColor%

	Gui, Add, GroupBox, xS+5 ys+140 h20 Center w300 h80 c0xFFC000, Select CrossHair
	Gui, Add, Button, xS+180 ys+180 w80 h30 gCrossHairMenu, Extras
	Gui, Add, Button, xS+50  ys+180 w30 h30 gSelectCrosshair, ∙
	Gui, Add, Button, xS+80 ys+180 w30 h30 gSelectCrosshair, +
	Gui, Add, Button, xS+110 ys+180 w30 h30 gSelectCrosshair, ×
	Gui, Add, Button, xS+140  ys+180 w30 h30 gSelectCrosshair, ¤

	Gui, Add, GroupBox, xS+5 ys+220 h20 Center w300 h80 c0xFFC000, Transparency Slider
	Gui, Add, Slider, xS+10 ys+260 W290 vCrossHairTrans gCrossHairTrans1 +ToolTip +Range0.0-224, %CrossHairTrans%
	Gui, Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save CrossHair

	Gui, tab, Extras
	Gui, Add, CheckBox, xS+5 ys+25 Checked%TurnAroundT% gCheckBoxHandler, Turn Around
	Gui, Add, Hotkey, xS+190 ys+20 w80 vkey_180, %Key_180%

	Gui, Add, CheckBox, xS+5 ys+77 Checked%RecoilSafety% gCheckBoxHandler, Recoil Safety
	Gui, Add, Hotkey, xs+190  ys+73 w80 vKey_Safety, %Key_Safety%

	Gui, Add, CheckBox, xS+180 ys+140 Checked%SpeechT% gCheckBoxHandler, Speech

	Gui, Add, CheckBox, xS+5 ys+140 Checked%SniperQQ% gCheckBoxHandler, Sniper QQ
	Gui, Add, CheckBox, xS+5 ys+170 Checked%CounterStrafeT% gCheckBoxHandler, Counter Strafe
	Gui, Add, CheckBox, xS+5 ys+200 Checked%ReloadT% gCheckBoxHandler, Quick Reload

	Gui, Add, Button, xS+35 ys+235 w125 h60 gButtonHandler, Mouse Properties
	Gui Add, Button, xS+185 ys+235 w100 h60 gSelectProcess, Elevate Priority
	Gui, Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save Extras

	rty := [e1, Version, A143, ajmf0, Jam, Bananananana, shoe, cat]
	iuy := 1
	ahgdsfh := rty[iuy]"!" . " | " . Version
	Gui, Show, x0 y0, %A_UserName% %ahgdsfh%
} Else {
Return
}
Return

ReloadGun:
if (ReloadT) {
IfWinActive, ahk_exe CS2.exe
    if (GunPattern = "" || GunPattern = "Recoil OFF" || GunPattern = "UniversalRCS") {
		Return
    } else {
        ReloadSleep := {AK: 1200, GALIL: 1200, SG: 1200, M4A1: 1450, M4A4: 1450, UMP: 1550, FAMAS: 1700}
        Sleep, % ReloadSleep[GunPattern]
        Goto QQ
    }
}
Return

RapidFire:
	Sleep, PilgrimMites(RFL,RFH)
	Click(35,65,5,10)
	if (GunPattern = "UniversalRCS") {
		Gosub RCS
	}
Return

QQ:
	Sleep 10
	SendInput, q
	Sleep, 25
	SendInput, q
Return

SniperQQ:
	if GetKeyState("LButton", "P") {
		Settimer, SniperQQ, Off
		Goto, QQ
	}
Return

Toggle_Accept:
AcceptT := !AcceptT
	if (AcceptT) {
		ShowToolTip("Accept | ON", , 60, 4)
		CenterXMin := A_ScreenWidth * 0.4500, CenterXMax := A_ScreenWidth * 0.5600
		CenterYMin := A_ScreenHeight * 0.4200, CenterYMax := A_ScreenHeight * 0.4500
		AcceptX := PilgrimMites(CenterXMin, CenterXMax), AcceptY := PilgrimMites(CenterYMin, CenterYMax)
		randomSpeed := Random(6, 12)
		PixelGetColor, colorA, 50, 50, Fast
		Settimer, Accept, 20
		SoundBeep, 800, 300
	} Else {
		ShowToolTip(, , 60, 4)
		Settimer, Accept, Off
		AcceptT := false
		SoundBeep, 1600, 300
	}
Return

Accept:
If (AcceptT) {
    PixelSearch,,, 50, 50, 50, 50, %colorA%, 2, Fast
    if (ErrorLevel = 1) {
        Mousegetpos, MouseX, MouseY, Window
        X1 := MouseX + Rand(10), Y1 := MouseY + Rand(10)
        Sleep, Random(1000, 3000)
        MouseMove, %AcceptX%, %AcceptY%, %randomSpeed%
		Sleep, Random(100, 500)
        Click()
        Sleep, Random(100, 500)
        MouseMove, %X1%, %Y1%, %randomSpeed%
		Sleep, 500
        SetTimer, Accept, Off
        AcceptT := false
		ShowToolTip(, , 60, 4)
		SoundBeep, 1600, 300
    }
}
Return

UniversalRCS_handler:
if (GunPattern = "UniversalRCS") {
	UniversalRCS:= 1
	Gosub UniversalRCS_GUI
} if (GunPattern != "UniversalRCS") {
	UniversalRCS:= 0
	Gosub UniversalRCS_GUI
}
Gosub UniversalRCSNotification
Return

UniversalRCS_GUI:
if (GuiVisible) {
	GuiControl,, Universal RCS, % (UniversalRCS ? "1" : "0")
	UniversalRCSColor := % (UniversalRCS ? "Green" : "0xCB0000")
	GuiControl, +c%UniversalRCSColor%, Universal RCS
	UniversalRCS_Show_Hide := % (UniversalRCS ? "Show" : "Hide")
	GuiControl, % UniversalRCS_Show_Hide, Humanizer
}
Return

UniversalRCSNotification:
If (RCSNotification && UniversalRCS) {
	ShowToolTip(GunPattern " | ON", , , 1)
}
if (RCSNotification && UniversalRCS && HumanizeUniversal) {
	ShowToolTip(GunPattern " & Humanizer | ON" , , , 1)
}
If (!UniversalRCS) {
	ShowToolTip("", , , 1)
}
return

PixelBotNotification:
If (TriggerBotT && TriggerBotNotification) {
	ShowToolTip("PixelBot | ON", , 20, 2)
} Else {
	ShowToolTip("", , 20, 2)
}
Return

CheckBoxHandler:
{
    Switch A_GuiControl {
        Case "Universal RCS": {
		    if (UniversalRCS) {
                GunPattern := "Recoil OFF"
                UniversalRCS := 0
                Gosub UniversalRCS_handler
				sleep 10
				Speak("Recoil OFF")
            } Else {
                GunPattern := "UniversalRCS"
                UniversalRCS := 1
                Gosub UniversalRCS_handler
				sleep 10
				Speak("UniversalRCS")
            }
		}

        Case "Recoil Safety": {
            RecoilSafety := !RecoilSafety
        }
		
        Case "CrossHair Toggle": {
            CrossHairT := !CrossHairT
            Goto CrossHair
        }
		
        Case "Magnifying Glass": {
            Magnifier := !Magnifier
            Goto ZoomIN
        }
		
        Case "RapidFire": {
            RapidFireT := !RapidFireT
            RFColor := RapidFireT ? "Green" : "0xCB0000"
            GuiControl, +c%RFColor%, RapidFire
        }
		
        Case "PixelBot": {
            TriggerBotT := !TriggerBotT
            PixelBotGUIColor := TriggerBotT ? "Green" : "0xCB0000"
            GuiControl, +c%PixelBotGUIColor%, PixelBot
            Gosub PixelBotNotification
        }
		
        Case "Notification": {
            RCSNotification := !RCSNotification
            RCSNotificationColor := RCSNotification ? "Green" : "0xCB0000"
            GuiControl, +c%RCSNotificationColor%, Notification
        }
		
        Case "PixelBot Notification": {
            TriggerBotNotification := !TriggerBotNotification
            TriggerBotNotificationGUIColor := TriggerBotNotification ? "Green" : "0xCB0000"
            GuiControl, +c%TriggerBotNotificationGUIColor%, PixelBot Notification
            Gosub PixelBotNotification
        }
		
        Case "Speech": {
            SpeechT := !SpeechT
        }
		
        Case "Counter Strafe": {
            Goto CounterStrafe
        }
		
        Case "Turn Around": {
            TurnAroundT := !TurnAroundT
        }
		
        Case "Humanizer": {
            HumanizeUniversal := !HumanizeUniversal
            HumanizeUniversalColor := HumanizeUniversal ? "Green" : "0xCB0000"
            GuiControl, +c%HumanizeUniversalColor%, Humanizer
			Gosub UniversalRCSNotification
        }
		
        Case "BHOP": {
            BHOPT := !BHOPT
            if (!BHOPT) {
                Legit := 0, Perfect := 0, ScrollWheel := 0
            }
			Gosub GUIBHOP
		}
			
        Case "Quick Reload": {
			ReloadT:=!ReloadT
		}
			
		Case "Sniper QQ": {
			SniperQQ:=!SniperQQ
		}
		
        Default:
            Msgbox, 48, Error!, Error Checkbox Handler., 5
    }
}
Return

ButtonHandler:
    if (GuiVisible) {
        Gui, Submit, NoHide
        hotkeys := [Key_AK, Key_M4A1, Key_M4A4, Key_Famas, Key_Galil, Key_UMP, Key_AUG, Key_SG, Key_RCoff, Key_RapidFire, Key_PixelBot, Key_BHOP, Key_180, Key_Safety, Key_UniversalRCS]
        if (HasDuplicates(hotkeys)) {
            return
        }

        Switch A_GuiControl
        {
            Case "SAVE RECOIL":
                global sens := Sens1, Speed := Speed1
                MsgBox, 4, Do you want to Save?, Sensitivity: %sens%`nAK: %Key_AK%`nM4A1: %Key_M4A1%`nM4A4: %Key_M4A4%`nFamas: %Key_Famas%`nGalil: %Key_Galil%`nUMP: %Key_UMP%`nAUG: %Key_AUG%`nSG: %Key_SG%`nKey_UniversalRCS: %Key_UniversalRCS%`nRecoil Off: %Key_RCoff%`nNotification: %RCSNotification%`nUniversalRCS: %UniversalRCS%`nHumanizeUniversal: %HumanizeUniversal%`nSpeed: %Speed%`nZoom Key: %Key_Zoom%`nRCS Percent: %RCSPercent%
                IfMsgBox Yes
                    Saving := [[Key_AK, "Hotkeys", "Key_AK"], [Key_M4A1, "Hotkeys", "Key_M4A1"], [Key_M4A4, "Hotkeys", "Key_M4A4"], [Key_Famas, "Hotkeys", "Key_Famas"], [Key_Galil, "Hotkeys", "Key_Galil"], [Key_UMP, "Hotkeys", "Key_UMP"], [Key_AUG, "Hotkeys", "Key_AUG"], [Key_SG, "Hotkeys", "Key_SG"], [Key_RCoff, "Hotkeys", "Key_RCoff"], [Key_Zoom, "Hotkeys", "Key_Zoom"], [sens, "General", "sens"], [Speed, "General", "Speed"], [RCSPercent, "General", "RCSPercent"], [RCSNotification, "Toggle", "RCSNotification"], [Key_UniversalRCS, "Hotkeys", "Key_UniversalRCS"], [UniversalRCS, "Toggle", "UniversalRCS"], [HumanizeUniversal, "Toggle", "HumanizeUniversal"]]
                    for index, Save in Saving {
                        CustomSave(Save.1, Save.2, Save.3)
                    }
                    Goto GuiClose

            Case "SAVE PIXEL BOT":
                if (ReactionMin >= ReactionMax) {
                    MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range., 5
                    return
                }
                global reaction_min := ReactionMin, reaction_max := ReactionMax
                MsgBox, 4, Do you want to Save?, Toggle State: %TriggerBotT%`nTriggerBot: %Key_PixelBot%`nTBMin: %reaction_min%`nTBMax: %reaction_max%`nNotification: %TriggerBotNotification%
                IfMsgBox Yes
                    Saving := [[Key_PixelBot, "Hotkeys", "Key_PixelBot"], [reaction_min, "PixelBot", "reaction_min"], [reaction_max, "PixelBot", "reaction_max"], [TriggerBotT, "PixelBot", "TriggerBotT"], [TriggerBotNotification, "Toggle", "TriggerBotNotification"]]
                    for index, Save in Saving {
                        CustomSave(Save.1, Save.2, Save.3)
                    }
                    Goto GuiClose
                IfMsgBox NO
                    Goto GuiClose

            Case "SAVE RAPID FIRE":
                if (RFL1 >= RFH1) {
                    MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range., 5
                    return
                }
                global RFL := RFL1, RFH := RFH1
                MsgBox, 4, Do you want to Save?, Toggle State: %RapidFireT%`nRapidFire: %Key_RapidFire%`nRFMin: %RFL%`nRFMax: %RFH%
                IfMsgBox Yes
                    Saving := [[Key_RapidFire, "Hotkeys", "Key_RapidFire"], [RFL, "RapidFire", "RFL"], [RFH, "RapidFire", "RFH"], [RapidFireT, "RapidFire", "RapidFireT"]]
                    for index, Save in Saving {
                        CustomSave(Save.1, Save.2, Save.3)
                    }
                    Goto GuiClose
                IfMsgBox NO
                    Goto GuiClose

            Case "Save BHOP":
                MsgBox, 4, Do you want to Save?, BHOP Key: %Key_BHOP%`nBHOP Toggle: %BHOPT%`nLegit: %Legit%`nPerfect: %Perfect%`nScrollWheel: %ScrollWheel%
                IfMsgBox Yes
                    Saving := [[Key_BHOP, "Hotkeys", "Key_BHOP"], [BHOPT, "BHOP", "BHOPT"], [Legit, "BHOP", "Legit"], [Perfect, "BHOP", "Perfect"], [ScrollWheel, "BHOP", "ScrollWheel"]]
                    for index, Save in Saving {
                        CustomSave(Save.1, Save.2, Save.3)
                    }
                    Goto GuiClose
                IfMsgBox NO
                    Goto GuiClose

            Case "SAVE Magnifier":
                global Zoom := Zoom1, Size := Size1, Delay := Delay1
                MsgBox, 4, Do you want to Save?, Toggle State: %Magnifier%`nZoom: %Zoom%`nSize: %Size%`nDelay: %Delay%
                IfMsgBox Yes
                    Saving := [[Zoom, "Magnifier", "Zoom"], [Size, "Magnifier", "Size"], [Delay, "Magnifier", "Delay"], [Magnifier, "Magnifier", "Magnifier"]]
                    for index, Save in Saving {
                        CustomSave(Save.1, Save.2, Save.3)
                    }
                    if (Magnifier) {
                        GoSub DestroyZoomin
                        GoSub CreateZoomIN
                    }
                    Goto GuiClose
                IfMsgBox NO
                    Goto GuiClose

            Case "SAVE CrossHair":
                MsgBox, 4, Do you want to Save?, Toggle State: %CrossHairT%`nCrossHair: %SelectedCrosshair%`nCrossHair Trans: %CrossHairTrans%`nCrossHairSize: %CrossHairSize%`nCrossHairColor: %CrossHairColor%
                IfMsgBox Yes
                    Saving := [[CrossHairTrans, "CrossHair", "CrossHairTrans"], [SelectedCrosshair, "CrossHair", "SelectedCrosshair"], [CrossHairSize, "CrossHair", "CrossHairSize"], [CrossHairColor, "CrossHair", "CrossHairColor"], [CrossHairT, "CrossHair", "CrossHairT"]]
                    for index, Save in Saving {
                        CustomSave(Save.1, Save.2, Save.3)
                    }
                    if (CrossHairT) {
                        GoSub DestroyCrossHair
                        GoSub CreateCrossHair
                    }
                    Goto GuiClose
                IfMsgBox NO
                    Goto GuiClose

            Case "Save Extras":
                MsgBox, 4, Do you want to Save?, TurnAround Toggle: %TurnAroundT%`nTurn Around Key: %key_180%`nRCS Safety Toggle: %RecoilSafety%`nRCS Safety Key: %Key_Safety%`nCrouch Correction Toggle: %DuckT%`nSpeech Toggle: %SpeechT%`nCounter Strafe: %CounterStrafeT%`n Quick reload: %ReloadT%`n SniperQQ %SniperQQ%
                IfMsgBox Yes
                    Saving := [[Key_180, "Hotkeys", "Key_180"], [TurnAroundT, "Toggle", "TurnAroundT"], [Key_Safety, "Hotkeys", "Key_Safety"], [RecoilSafety, "Toggle", "RecoilSafety"], [SpeechT, "Toggle", "SpeechT"], [CounterStrafeT, "Toggle", "CounterStrafeT"], [SniperQQ, "Toggle", "SniperQQ"], [ReloadT, "Toggle", "ReloadT"]]
                    for index, Save in Saving {
                        CustomSave(Save.1, Save.2, Save.3)
                    }
                    Goto GuiClose
                IfMsgBox NO
                    Goto GuiClose

            Case "Mouse Properties":
                Run main.cpl

            Case "Elevate Priority":
                Gosub, SelectProcess

            Case "BHOP TIPS":
                Msgbox, 1, Bind ScrollWheel IN-GAME, BHOP will sometimes NOT work when BHOP is bound to spacebar!`n`n`nTo use ScrollWheel BHOP you need to use this in command console.`n"Bind mwheeldown +jump;bind mwheelup +jump;bind space +jump"`n^ This bind is for For CS2`n`nDo you want to copy CS2 Bind to your Clipboard?,20
                IfMsgBox ok
                {
                    Clipboard := "Bind mwheeldown +jump;bind mwheelup +jump;bind space +jump"
                }
        }
    }
Return

BHOP_Handler:
    if (BHOPT) {
        if (A_GuiControl = "Legit") {
			if (Legit = 0) {
				Legit := 1, Perfect := 0, ScrollWheel := 0			
				}
		} else if (A_GuiControl = "Perfect") {
			if (Perfect = 0) {
				Legit := 0, Perfect := 1, ScrollWheel := 0			
				}
        } else if (A_GuiControl = "ScrollWheel") {
			if (ScrollWheel = 0) {
				Legit := 0, Perfect := 0, ScrollWheel := 1
			}
		}
    } else {
        Legit := 0, Perfect := 0, ScrollWheel := 0
		GoSub, GUIBHOP
        MsgBox, 64, %ahgdsfh%, BHOP is toggled OFF. Please Toggle ON., 3
    }
GoSub GUIBHOP
 Return

GUIBHOP:
{
BHOP_GUIColor := % (BHOPT ? "Green" : "0xCB0000")
GuiControl, +c%BHOP_GUIColor%, BHOP
Legit_GUIColor := % (Legit ? "Green" : "0xCB0000")
GuiControl, +c%Legit_GUIColor%, Legit
Perfect_GUIColor := % (Perfect ? "Green" : "0xCB0000")
GuiControl, +c%Perfect_GUIColor%, Perfect
ScrollWheel_GUIColor := % (ScrollWheel ? "Green" : "0xCB0000")
GuiControl, +c%ScrollWheel_GUIColor%, ScrollWheel

GuiControl,, BHOP, % (BHOPT ? "1" : "0")
GuiControl,, Legit, % (Legit ? "1" : "0")
GuiControl,, Perfect, % (Perfect ? "1" : "0")
GuiControl,, ScrollWheel, % (ScrollWheel ? "1" : "0")
}
Return

HideToolTip:
SetTimer, HideToolTip, Off
ToolTip, , , , %ToolTips%
return

CounterStrafe:
CounterStrafeT := !CounterStrafeT
Gosub ToggleScripts
Gosub CounterstrafeGUI
return

CounterstrafeGUI:
if (GuiVisible) {
Guicontrol,, Counter Strafe, % (CounterStrafeT ? "1" : "0")
}
If (!CounterStrafeT) {
	ShowToolTip("", , , 3)
	Menu, Tray, Uncheck, Toggle Counter Strafe
} else {
	ShowToolTip("CounterStrafe | ON", , 40, 3)
	Menu, Tray, Check, Toggle Counter Strafe
}
Return

ToggleScripts:
{
allExist := true  ; Initialize to true

; Check if all scripts exist
for each, script in scripts {
    if !ProcessExist(script) {
        allExist := false
        break  ; No need to check further if any script is not running
    }
}

; Toggle scripts based on their existence
if allExist {
    ; Close all scripts
    for each, script in scripts {
        Process, Close, %script%
    }
} else {
    ; Run all scripts
		for each, script in scripts {
			Run %A_ScriptDir%\CounterStrafe\%script%, , UseErrorLevel
			if ErrorLevel {
				MsgBox % "Error: " ErrorLevel
			}
		}
	}
}
Return

CloseScripts:
if ProcessExist(script) {
		for each, script in scripts {
			Process, Close, %script%
		}
    }
return

RCS_Slider:
GuiControlGet, RCSPercent1
Global RCSPercent:=RCSPercent1
Return

FindSettings:
if !FileExist("Settings.ini") {
	FileAppend, [PilgrimMites] Available @ " https://www.unknowncheats.me/forum/counter-strike-2-releases/605440-ahk-multiscript-peans-rcs.html " `n, Settings.ini
	Gosub SaveALLSettings
} Else {
;MsgBox, 48,ERROR!,Settings already exist!, 5
}
Return

ReadALLSettings: 
{
    if (FileExist("Settings.ini")) {
        ; General section
        settingsGeneral := {sens: "sens", zoomsens: "zoomsens", Speed: "Speed", GunPattern: "GunPattern", RCSPercent: "RCSPercent"}
        for key, value in settingsGeneral
            IniRead, %key%, Settings.ini, General, %value%
        ; Hotkeys section
        settingsHotkeys := {Key_AK: "Key_AK", Key_M4A1: "Key_M4A1", Key_M4A4: "Key_M4A4", Key_Famas: "Key_Famas", Key_Galil: "Key_Galil", Key_UMP: "Key_UMP", Key_AUG: "Key_AUG", Key_SG: "Key_SG", Key_180: "Key_180", Key_RCoff: "Key_RCoff", Key_RapidFire: "Key_RapidFire", Key_PixelBot: "Key_PixelBot", Key_BHOP: "Key_BHOP", Key_UniversalRCS: "Key_UniversalRCS"}
        for key, value in settingsHotkeys
            IniRead, %key%, Settings.ini, Hotkeys, %value%

        ; PixelBot section
        settingsPixelBot := {TriggerBotT: "TriggerBotT", reaction_min: "reaction_min", reaction_max: "reaction_max"}
        for key, value in settingsPixelBot
            IniRead, %key%, Settings.ini, PixelBot, %value%

        ; CrossHair section
        settingsCrossHair := {CrossHairT: "CrossHairT", CrossHairTrans: "CrossHairTrans", SelectedCrosshair: "SelectedCrosshair", CrossHairSize: "CrossHairSize", CrossHairColor: "CrossHairColor"}
        for key, value in settingsCrossHair
            IniRead, %key%, Settings.ini, CrossHair, %value%

        ; RapidFire section
        settingsRapidFire := {RapidFireT: "RapidFireT", RFL: "RFL", RFH: "RFH"}
        for key, value in settingsRapidFire
            IniRead, %key%, Settings.ini, RapidFire, %value%

        ; Magnifier section
        settingsMagnifier := {Magnifier: "Magnifier", Zoom: "Zoom", Size: "Size", Delay: "Delay", MagnifierTrans: "MagnifierTrans"}
        for key, value in settingsMagnifier
            IniRead, %key%, Settings.ini, Magnifier, %value%

        ; BHOP section
        settingsBHOP := {BHOPT: "BHOPT", Legit: "Legit", Perfect: "Perfect", ScrollWheel: "ScrollWheel"}
        for key, value in settingsBHOP
            IniRead, %key%, Settings.ini, BHOP, %value%

        ; Toggle section
        settingsToggle := {RCSNotification: "RCSNotification", TriggerBotNotification: "TriggerBotNotification", TurnAroundT: "TurnAroundT", RecoilSafety: "RecoilSafety", UniversalRCS: "UniversalRCS", SpeechT: "SpeechT", CounterStrafeT: "CounterStrafeT", ReloadT: "ReloadT", SniperQQ: "SniperQQ", HumanizeUniversal: "HumanizeUniversal"}
        for key, value in settingsToggle
            IniRead, %key%, Settings.ini, Toggle, %value%

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
Return

SaveALLSettings: 
{
    if (FileExist("Settings.ini")) {
        ; General section
        settingsGeneral := {sens: sens, zoomsens: zoomsens, Speed: Speed, GunPattern: GunPattern, RCSPercent: RCSPercent}
        for key, value in settingsGeneral
            IniWrite, %value%, Settings.ini, General, %key%

        ; Hotkeys section
        settingsHotkeys := {Key_AK: Key_AK, Key_M4A1: Key_M4A1, Key_M4A4: Key_M4A4, Key_Famas: Key_Famas, Key_Galil: Key_Galil, Key_UMP: Key_UMP, Key_AUG: Key_AUG, Key_SG: Key_SG, Key_180: Key_180, Key_RCoff: Key_RCoff, Key_RapidFire: Key_RapidFire, Key_PixelBot: Key_PixelBot, Key_Safety: Key_Safety, Key_BHOP: Key_BHOP, Key_UniversalRCS: Key_UniversalRCS}
        for key, value in settingsHotkeys
            IniWrite, %value%, Settings.ini, Hotkeys, %key%

        ; PixelBot section
        settingsPixelBot := {TriggerBotT: TriggerBotT, reaction_min: reaction_min, reaction_max: reaction_max}
        for key, value in settingsPixelBot
            IniWrite, %value%, Settings.ini, PixelBot, %key%

        ; CrossHair section
        settingsCrossHair := {CrossHairT: CrossHairT, CrossHairTrans: CrossHairTrans, SelectedCrosshair: SelectedCrosshair, CrossHairSize: CrossHairSize, CrossHairColor: CrossHairColor}
        for key, value in settingsCrossHair
            IniWrite, %value%, Settings.ini, CrossHair, %key%

        ; RapidFire section
        settingsRapidFire := {RapidFireT: RapidFireT, RFL: RFL, RFH: RFH}
        for key, value in settingsRapidFire
            IniWrite, %value%, Settings.ini, RapidFire, %key%

        ; Magnifier section
        settingsMagnifier := {Magnifier: Magnifier, zoom: Zoom, Size: Size, Delay: Delay, MagnifierTrans: MagnifierTrans}
        for key, value in settingsMagnifier
            IniWrite, %value%, Settings.ini, Magnifier, %key%

        ; BHOP section
        settingsBHOP := {BHOPT: BHOPT, Legit: Legit, Perfect: Perfect, ScrollWheel: ScrollWheel}
        for key, value in settingsBHOP
            IniWrite, %value%, Settings.ini, BHOP, %key%

        ; Toggle section
        settingsToggle := {RCSNotification: RCSNotification, TriggerBotNotification: TriggerBotNotification, TurnAroundT: TurnAroundT, RecoilSafety: RecoilSafety, UniversalRCS: UniversalRCS, SpeechT: SpeechT, CounterStrafeT: CounterStrafeT, ReloadT: ReloadT, SniperQQ: SniperQQ, HumanizeUniversal: HumanizeUniversal}
        for key, value in settingsToggle
            IniWrite, %value%, Settings.ini, Toggle, %key%
		
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
Return

; Stop lurking through my code aint nothing good in here.

GuiClose:
GuiEscape:
if (GuiVisible = true) {
    Gui, Destroy
	Menu, Tray, Uncheck, Toggle Main Menu
	GuiVisible := False
}
	GoSub Close2
	GoSub Close_M_CH
return

Close2:
    if (Gui2 = true) {
        Gui 2:Destroy
		Gui2 := False
    }
return

Close_M_CH:
if (CrossHairT = 0) {
    Gosub DestroyCrossHair
}
if (Magnifier = 0) {
    Gosub DestroyZoomin
}
Return

ExitScript:
	Gosub GuiClose
	Gosub UnHook
	Gosub CloseScripts
	Speak("Exiting Script")
    ExitApp
return

UnHook:
{
    if (hHook) {
        DllCall("UnhookWindowsHookEx", Ptr, hHook)
        MsgBox, 64, Success, Process UnHooked!, 2
    } Else {
        ;MsgBox, 48,ERROR!,UnhookWindowsHookEx failed!, 5
    }
    if (hMod) {
        DllCall("FreeLibrary", Ptr, hMod)
		MsgBox, 64, Success, Library UnLoaded!, 2
    } Else {
        ;MsgBox, 48,ERROR!,Library unloaded failed!, 5
    }
}
Return

SelectProcess:
InputBox, ExeName, Select Process, Enter a process Name(Exe) or PID:
    if (ExeName != "") {
        ; Check if the input is a PID or a process name
        if (ExeName is digit) {
            PID := ExeName
        } else {
            Process, Exist, %ExeName%
            PID := ErrorLevel
        }
        
        if (PID) {
            ; Open the process with full access
            hProcess := DllCall("OpenProcess", "uint", 0x1F0FFF, "int", false, "uint", PID)
            if (hProcess) {
                ; Get the current priority class
                PriorityClass := DllCall("GetPriorityClass", "uint", hProcess)
                
                ; Check if the priority class is already Real Time
                if (PriorityClass = 0x00000080) {
                    MsgBox, 64, Found!, Process Selected`nPID: %PID%`nName: %ExeName%`nAlready at Real Time Priority, 5
                } else {
                    ; Set the priority class to Real Time
                    if (DllCall("SetPriorityClass", "uint", hProcess, "uint", 0x00000080)) {
                        MsgBox, 64, Success!, Process Selected`nPID: %PID%`nName: %ExeName%`nElevated to Real Time Priority, 5
                    } else {
                        MsgBox, 48, Error!, Error elevating priority for `nPID: %PID%`nName: %ExeName%`nLastError: %A_LastError%, 5
                    }
                }
                
                ; Close the process handle
                DllCall("CloseHandle", "uint", hProcess)
            } else {
                MsgBox, 48, Error, Error opening process for `nPID: %PID%`nName: %ExeName%`nLastError: %A_LastError%, 5
            }
        } else {
            MsgBox, 48, Error!, Process not found`nName/PID: %ExeName%, 5
        }
    } else {
        MsgBox, 32, Why you no enter name?, No process name or PID entered., 5
    }
return

HideProcess:
{
if ((A_Is64bitOS=1) && (A_PtrSize!=4))
        hMod := DllCall("LoadLibrary", Str, "hyde64.dll", Ptr)
    else if ((A_Is32bitOS=1) && (A_PtrSize=4))
        hMod := DllCall("LoadLibrary", Str, "hyde.dll", Ptr)
    else
    {
        MsgBox, 48,ERROR!,Mixed Versions detected!`nOS Version and AHK Version need to be the same (x86 & AHK32 or x64 & AHK64).`n`nScript will now Reload!, 5
        Goto, ReloadScript
    }

    if (hMod)
    {
        hHook := DllCall("SetWindowsHookEx", Int, 5, Ptr, DllCall("GetProcAddress", Ptr, hMod, AStr, "CBProc", ptr), Ptr, hMod, Ptr, 0, Ptr)
        if (!hHook)
        {
            MsgBox, 48,ERROR!,SetWindowsHookEx failed!`nScript will now Reload!, 5
            Goto, ReloadScript
        }
    }
    else
    {
        MsgBox, 48,ERROR!,LoadLibrary failed!`nScript will now Reload!, 5
        Goto, ReloadScript
    }

    MsgBox, 64,SUCCESS!,% "Process ('" . A_ScriptName . "') hidden!", 5
}
return

PrankMsgBox:
{
    MsgBox, 5, Why Not?, Why dont you love EVEE?`nEVEE is adorable!
	IfMsgBox Retry
	{
		PictureCheck("FBI_Evee.png","https://i.imgur.com/EPeUF8M.png")
		Suspend
		Return
	}
    Sleep, 1000  ; Wait for 1 second
    MsgBox, 5, Really?, Are you sure you dont love EVEE?`nThink of the cute face!
	IfMsgBox Retry
	{
		PictureCheck("FBI_Evee.png","https://i.imgur.com/EPeUF8M.png")
		Suspend
		Return
	}
    Sleep, 1000  ; Wait for 1 second
    MsgBox, 5, Think Again!, EVEE is so cute!`nPlease reconsider!
	IfMsgBox Retry
	{
		PictureCheck("FBI_Evee.png","https://i.imgur.com/EPeUF8M.png")
		Suspend
		Return
	}
    Sleep, 1000  ; Wait for 1 second
    MsgBox, 5, Last Chance, Download the picture of EVEE now!`n	  OR ELSE!
	IfMsgBox Retry
	{
		PictureCheck("FBI_Evee.png","https://i.imgur.com/EPeUF8M.png")
		Suspend
		Return
	}
    IfMsgBox, Cancel
    {
        MsgBox, 16, Disappointment, EVEE is sad you dont want the picture. :(
		run https://www.youtube.com/watch?v=dQw4w9WgXcQ
		Goto, PrankMsgBox
		Return
    }
}
Return

OpenLoc:
    run % A_ScriptDir
return

Pause:
{
suspend toggle
	if (a_isSuspended = 1) {
	Sleep 1
    Speak("Paused Script")
	Sleep 1
	Menu, Tray, check, Pause Script
	Pause on
} Else {
	Sleep 1
	Speak("UnPaused Script")
	Sleep 1
	Menu, Tray, uncheck, Pause Script
	Pause Off
	}
}
Return

ReloadScript:
{
	Sleep 100
	Speak("Reloading Script")
	Sleep 100
	Gosub, UnHook
	Sleep 100
	Gosub CloseScripts
	Sleep 100
	Reload
}
Return

Update_Progress_Bar:
{
    if (FileExist(Image_Name)) {
        GuiControl, PictureCheck:, ProgressRange, 100
			SetTimer, Update_Progress_Bar, Off
    } else {
        Progress += 2
		GuiControl, PictureCheck:, ProgressRange, %Progress%
		If (Progress > 99) {
				SetTimer, Update_Progress_Bar, Off
		}
    }
}
Return

StartSequence: 
{    ; DO NOT TOUCH!!!!!!!!!!!!!!!
    Menu, Tray, NoStandard ; Remove default menu
    Menu, Tray, Add, Toggle Main Menu, ToggleGUI
    Menu, Tray, Add, Toggle CrossHair, CrossHairToggler
    Menu, Tray, Add, Toggle Magnifier, MagnifierToggler
    Menu, Tray, Add, Toggle Counter Strafe, CounterStrafe
    Menu, Tray, Add,
    Menu, Tray, Add, Elevate Priority, SelectProcess
    Menu, Tray, Add,
    Menu, Tray, Add, Reload Script, ReloadScript
    Menu, Tray, Add, Locate Script, OpenLoc
    Menu, Tray, Add, Pause Script, Pause
    Menu, Tray, Add, Hide Script, HideProcess
    Menu, Tray, Add, Exit Script, ExitScript
    
    Sleep, 1
    RunAsAdmin()
    ;Settimer isMouseShown, 1000
		GoSub FindSettings
        Gosub ReadALLSettings
		if (CounterStrafeT) {
			Gosub, ToggleScripts
		}	
		if (UniversalRCS) {
			GunPattern := "UniversalRCS"
		}
        Gosub Zoomin
        Gosub Crosshair
        Gosub UniversalRCSNotification
		Gosub PixelBotNotification
        Gosub CounterstrafeGUI
    
    if FileExist("FBI_Evee.PNG") {
        Menu, Tray, Icon, FBI_Evee.PNG, , 1
    } else {
        MsgBox, 49, Status Report!, Agent Evee IS MISSING!`nSTART THE HELICOPTER WE NEED TO FIND AGENT EVEE!!
        ifMsgBox ok 
		{
            PictureCheck("FBI_Evee.png", "https://i.imgur.com/EPeUF8M.png")
        } else ifMsgBox Cancel
		{
            Suspend
            Gosub PrankMsgBox
        }
    }
    
    ; IfNotExist, Background.jpg
    ; {
    ;     PictureCheck("Background.jpg", "https://i.imgur.com/xyQzMrR.jpeg")
    ;     MsgBox, , , Background.jpg Downloaded, 5
    ; }
    
    MainLoop()
}
Return


Pause:: Goto, Pause

#r::Goto, ReloadScript

End::Goto, ExitScript

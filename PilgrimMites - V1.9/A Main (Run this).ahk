#NoEnv
#MaxThreadsPerHotkey 9999
#SingleInstance Force
#KeyHistory 0
#MaxMem 4095
#MaxThreads 255
#MaxThreadsBuffer on
#InstallMouseHook
#InstallKeybdHook
Process, Priority, , R
ListLines Off
SetWorkingDir %A_ScriptDir%
SetKeyDelay,-1
SetControlDelay, -1
SetBatchLines,-1

SysGet, Monitor_1, Monitor, 1
primaryWidth := Monitor_1Right - Monitor_1Left
primaryHeight := Monitor_1Bottom - Monitor_1Top

Global Center_X := A_ScreenWidth // 2 + 1 , Center_Y := A_ScreenHeight // 2 + 1

;MSGBox, , ,MonitorPrimary: %MonitorPrimary%`nprimaryWidth: %primaryWidth%`nprimaryHeight: %primaryHeight%`nprimaryWidth_Center: %primaryWidth_Center%`nprimaryHeight_center: %primaryHeight_center%`nCenter_X: %Center_X%`nCenter_Y: %Center_Y%


Global sens := 1.80, Zoomsens := 0.75, reaction_min := 25, reaction_max := 100, RFL := 50, RFH := 80, Speed:= 1

Global CrossHairTrans := 220, SelectedCrosshair := "+",CrossHairSize := 20, CrossHairColor:= "Green"

Global Magnifier := False, Zoom := 1, Size := 30, Delay := 10, MagnifierTrans := 220

Global key_AK := "Numpad1", Key_M4A1 := "Numpad2", Key_M4A4 := "Numpad3", Key_Famas := "Numpad4", Key_Galil := "Numpad5", Key_UMP := "Numpad6", Key_AUG := "Numpad7", Key_SG := "Numpad8", Key_UniversalRCS:= "Numpad9", Key_RCoff := "Numpad0", key_180 := "v", Key_shoot := "LButton", Key_Zoom := "Alt", Key_RapidFire := "XButton1", Key_PixelBot := "XButton2", Key_BHOP := "x", Key_Safety:= "n"

Global humanizer,waitdivider,humanizer88,waitdivider88,RCSPercent:= 100, ToolTips := []

Global GuiVisible := False,BHOPT := False, RapidFireT := False, TriggerBotT := False, TurnAroundT := False, AcceptT := False, CrosshairT := False, RCSNotification := True, TriggerBotNotification := True, RecoilSafety:= False, UniversalRCS := False, Legit :=  False, Perfect := False, ScrollWheel := False, SpeechT := True, CounterStrafeT := False, HumanizeUniversal := False, ReloadT := True, SniperQQ := False, Paused := False
Global WhichToolTip := 20, ProgressRange := 100
Global pattern := [], GunPattern := "Recoil OFF"
Global modifier := 2.52 / sens ; 2.52

scripts := ["counterstrafe_B.exe", "counterstrafe_F.exe", "counterstrafe_L.exe", "counterstrafe_R.exe"]

ch1 := Chr(84), ch2 := Chr(72), ch3 := Chr(73), ch4 := Chr(83), ch5 := Chr(32), ch6 := Chr(83), ch7 := Chr(82), ch8 := Chr(73), ch9 := Chr(80), ch10 := Chr(84), ch11 := Chr(32), ch12 := Chr(73), ch13 := Chr(83), ch14 := Chr(32), ch15 := Chr(70), ch16 := Chr(82), ch17 := Chr(69), ch18 := Chr(69), pair1 := ch1 . ch2, pair2 := ch3 . ch4, pair3 := ch5 . ch6, pair4 := ch7 . ch8, pair5 := ch9 . ch10, pair6 := ch11 . ch12, pair7 := ch13 . ch14, pair8 := ch15 . ch16, pair9 := ch17 . ch18, str1 := pair1 . pair2, str2 := pair3 . pair4, str3 := pair5 . pair6, str4 := pair7 . pair8, str5 := pair9, temp1 := str1 . str2, temp2 := str3 . str4, temp3 := temp1 . temp2, e1 := temp3 . str5

Version := "V1.9"
/*
Note Sensitivity under 1.5 may break. looking into how to fix this
Note SniperQQ and Reload have no GUI for now. This will be added later. To enable you must turn False into True and save/Reload

Removed MSGBox for pressing Terminate Key = End
Added Quick Reload (WIP | Off by default | Adjust sleep time to Gun) (Thank You WhyLol123)
Added Toggle Counter Stafe & Locate Script to Tray Menu
Added Sniper QQ | Dafault OFF
Updated Pause to work Properly
Updated Galil to be more accurate.
Updated StartSequence X2  | StartSequence into a subroute, should imrpove start time.
Updated CounterStrafe to properly open and Close Process.
Updated Universal RCS will work at any time. SprayPatterns will only work when CS is the active window.
Updated ExitScript Subroute
Updated Prank MSGBOX/Picture Check, Make sure you rescue Agent Evee!
Updated Gunselection Function to work with UniversalRCS & all other recoil states (reworked twice to insure UniversalRCS Turns off when other patterns are selected)
Updated Gunselection Function Fixed bug that would result in recoil off
Updated Bhop Save/Default key (Spacebar -> x)
Updated Crosshair and Magnifier no longer saves when using hotkeys
Updated GUI Humanize uni -> Humanizer
Updated KeyPress Function to use DLLCALL instead of sending input through AHK
Updated PixelBot FINALLY WORKING AS INTENDED (Was not searaching in proper X,Y for some reason. Switched how X,Y is obtained
Updated ToolTips
Updated BHOP sleep times | Else if statements for better performance
Updated Zoom.AHK to work with Shift+ UP or Down Arrows
Updated UniversalRCS to work with RapidFire (Turn on both for it to work. Will be adding a toggle for this)
Updated Humizer for UniversalRCS To be really human like (Adjusted X Axis, Speed controls Y Axis)
Updated Recoils for CS2 can only be selected or used when CS2 is the active window
Updated PixelBot Search Cords so they properly work with Sniper CrossHair
Updated AutoAccept
Updated Pause subroute
Updated Select CrossHair to use For Each loop (This will shorten the code)
Updated Reload to be accurate for each gun in script | if gun not selected then it will reload regularly 
Updated RCS to Reload if you full spray and run out of ammo


Updated RapidFire to work With Lbutton (Left Click and hold for RapidFire) TYSVM kyxz09 GREAT IDEA! To answer your question....
Had to add to this line, to make this idea work with everything else.
while GetKeyState(key_shoot, "P") && !GUIVISIBLE && Key_RapidFire != LButton && !RapidFireT 
Also added the option to select LButton under MainGUI
DPMenu := "XButton1|XButton2|LButton|Z|X|C|Alt|Ctrl|CapsLock"


ToDo:  | | | | Toggle For RapidFire + universalRCS | | | RapidFire More GUI options | | | | | | Find Way to Auto Select Weapon
*/

VarSetCapacity(INPUT, 28)
VarSetCapacity(MOUSEINPUT, 24)
VarSetCapacity(KEYBDINPUT, 16)
VarSetCapacity(HARDWAREINPUT, 8)
VarSetCapacity(INPUT_union, 24)

Gosub StartSequence
#Include Subroutes.AHK
#Include Functions.AHK
#Include Zoom.AHK
#Include Crosshair.AHK

~*+F1::Goto ToggleGUI

~*+F2::Goto MagnifierToggler

~*+F3::Goto CrosshairToggler

~*+F4::Goto CounterStrafe

~*+F5::Goto Toggle_Accept

~r::Goto, ReloadGun

~$*LButton::
while GetKeyState(key_shoot, "P") && !GUIVISIBLE && Key_RapidFire != LButton && !RapidFireT {
	If !RecoilSafety {
		GoTo RCS
	} Else {
		If GetKeyState(Key_Safety, "P") {
			GoTo RCS
		}
	}
}
Return

~$*RButton::
if (SniperQQ) {
	keywait, Lbutton, D
	Goto, QQ
}
Return

MainLoop() {
	loop {
	Sleep, 2
	DllCall("psapi.dll\EmptyWorkingSet", "UInt", -1)
	While (TriggerBotT && GetKeyState(Key_PixelBot, "P")) {
		MouseGetPos, MouseX, MouseY
		CenterX:= MouseX + 1,CenterY:= MouseY + 1
		PixelGetColor, colorPB, CenterX, CenterY, Fast . A_critical 
		PixelSearch, , , CenterX, CenterY, CenterX, CenterY, colorPB, 1, Fast . A_critical
		if (colorPB != "0xFFFFFFFF") {
			if (ErrorLevel = 1) { 
				Sleep, PilgrimMites(reaction_min, reaction_max)
				Click()
				Sleep, 300
			}
		}
	}
	While (RapidFireT && GetKeyState(Key_RapidFire, "P") && !GUIVISIBLE)  {
		sleep, PilgrimMites(RFL,RFH)
		Click(35,65,5,10)
		if (GunPattern = "UniversalRCS") {
			Gosub RCS
		}
	}
	While (BHOPT && GetKeyState(Key_BHOP, "D"))  {
		if (ScrollWheel) {
			Sleep, 2
			MouseClick, WheelDown
			Sleep, 2
			MouseClick, WheelUp
			Sleep, 2
		} Else if (Perfect)  {
			Sleep,10
			Send, {Space Down}
			Sleep,10
			Send, {Space Up}
			Sleep,10
		} Else if (Legit) {
			Sleep,15
			Send, {Space Down}
			Sleep, Random(30,70)
			Send, {Space Up}
			Sleep, 15
		}
		if !GetKeyState(Key_BHOP, "P") {
			break
		}
	}
	While (TurnAroundT && GetKeyState(Key_180, "P"))  {
		Random, chance, 0.0, 1.0
		PosNeg := chance <= 0.49 ? -1 : 1
			DllCall("mouse_event", "UInt", 0x01, "UInt", (PosNeg*228)*modifier, "UInt", 0)
			sleep 1
		Loop, 7 {
			DllCall("mouse_event", "UInt", 0x01, "UInt", (PosNeg*432)*modifier, "UInt", 0)
			sleep 1
		}
		Sleep, Random(300,500)
	}
	While GetKeyState(key_UniversalRCS, "P")  {
		if (GunPattern != "UniversalRCS") {
			GunPattern := "UniversalRCS"
			UniversalRCS := 1
			if (GuiVisible) {
				Gosub GUI_UNIRCS
				GuiControl, Show, Humanize Uni
			}
			ShowToolTip(GunPattern, , , 1)
		}
	}
	While GetKeyState(key_RCoff, "P")  {
		if (GunPattern != "Recoil OFF") {
			GunSelection("Recoil OFF", 0, 0)
		}
	}
	Sleep, 2
		IfWinActive, ahk_exe CS2.exe
		{
		if GetKeyState(key_AK, "P")  { ; 99%
			if (GunPattern != "AK") {
				GunSelection("AK", 3.80, 4.7)
				pattern := [[-4, 7, 99], [4, 19, 99], [-3, 29, 99], [-1, 31, 99], [13, 31, 99], [8, 28, 99], [13, 21, 99], [-17, 12, 99], [-42, -3, 99], [-21, 2, 99], [12, 11, 99], [-15, 7, 99], [-26, -8, 99], [-3, 4, 99], [40, 1, 99], [19, 7, 99], [14, 10, 99], [27, 0, 99], [33, -10, 99], [-21, -2, 99], [7, 3, 99], [-7, 9, 99], [-8, 4, 99], [19, -3, 99], [5, 6, 99], [-20, -1, 99], [-33, -4, 99], [-45, -21, 99], [-14, 1, 99]]
			}
		Sleep, 250
		}
		if GetKeyState(key_M4A1, "P") { ; 99%
			if (GunPattern != "M4A1") {
				GunSelection("M4A1", 4.20, 4.17)
				pattern := [[1, 6, 88], [0, 4, 88], [-4, 14, 88], [4, 18, 88], [-6, 21, 88], [-4, 20, 88], [14, 14, 88], [8, 12, 88], [18, 5, 88], [-14, 5, 88], [-25, -3, 88], [-19, 0, 88], [-22, -3, 88], [1, 3, 88], [8, 3, 88], [-9, 1, 88], [-11, -2, 88], [5, 2, 88], [3, 1, 88]]
			}
		Sleep, 250
		}
		if GetKeyState(key_M4A4, "P") { ; 90% 
			if (GunPattern != "M4A4") {
				GunSelection("M4A4", 3.90, 4.05)
				pattern := [[1, 8, 88], [0, 15, 9], [-2, 16, 87], [4, 21, 87], [-9, 23, 87], [-5, 27, 87], [18, 15, 88], [18, 13, 88], [16, 6, 44],[-20, 4, 44], [-15, 6, 88], [-15, 4, 80], [-15, -4, 88], [-20, -6, 88], [-20, -4, 87], [2, 12, 87], [-5, -1, 87], [-5, -2, 87], [18, 2, 88], [10, -1, 88], [14, 6, 88], [20, 3, 88], [15, 2, 88], [15, 3, 88], [-15, -3, 87], [6, 5, 87], [4, 5, 87], [3, 1, 87], [4, -1, 0]] 
			}
		Sleep, 250
		}
		if GetKeyState(key_Famas, "P") { ; 90%
			if (GunPattern != "FAMAS") {
				GunSelection("FAMAS", 3.60, 4.18)
				Pattern := [[0, 4, 5, 88], [1, 6, 88], [-6, 10, 88], [-1, 17, 88], [6, 20, 88], [14, 18, 88], [15, 12, 88], [-18, 14, 88], [-15, 8, 88], [-18, 5, 88], [-13, 2, 88], [20, 5, 87], [18, 4, 88], [14, 6, 88], [10, -3, 88], [10, 0, 88], [15, 0, 88], [6,5,88], [-14,3,88], [-10,5,80], [-8,5,84], [8,2,80], [9,-5,44], [9,-7,44], [-3,6,88]]
			}
		Sleep, 250
		}
		if GetKeyState(key_Galil, "P") { ; 85%
			if (GunPattern != "GALIL") {
				GunSelection("GALIL", 4.10, 4.25)
				Pattern := [[4, 5,90],[-2, 9,90],[6, 10,90],[12, 15,90],[-1, 21,90],[2, 24,90],[6, 16,90],[6, 10,90],[-18, 14,90],[-20, 8,90],[-28, -3,85],[-19, -13,90],[-23, 8,90],[-12, 2,85],[-7, 1,90],[-2, 10,50],[14, 7,90],[25, 7,85],[14, 4,90],[25, -3,85],[31, -5,85],[6, 3,90],[-12, 3,90],[13, -1,90],[10, -1,90],[16, -4,90],[-9, 5,90],[-32, -5,90],[-24, -3,90],[-15, 5,90],[6, 8,90],[-14, -3,90],[-24, -14,90],[-13, -1,90]]

			}
		Sleep, 250
		}
		if GetKeyState(key_UMP, "P") { ; 90%
			if (GunPattern != "UMP") {
				GunSelection("UMP", 4.55, 4.20)
				Pattern := [[-3, 16, 90],[-4, 18, 90],[-3, 18, 90],[-4, 23, 90],[-9, 23, 85],[-3, 26, 85],[11, 17, 85],[-4, 12, 85],[9, 13, 90],[18, 10, 90],[15, 6, 90],[-1, 5, 90],[5, 6, 90],[1, 6, 85],[9, -3, 85],[5, -1, 85],[8, 1, 85],[7, 4, 85],[-2, -2, 90],[-7, 12, 85],[-7, 12, 85],[-2, -4, 85],[-8, -4, 90],[-10, -4, 85],[-2, -1, 85],[-2, -9, 85],[5, -9, 85],[12, -6, 90],[-16, -6, 80]]
			}
		Sleep, 250
		}
		if GetKeyState(key_AUG, "P") { ; 80% | Zoom  95% Needs Work
			if (GunPattern != "AUG") {
				GunSelection("AUG", 3.9, 4.7) ; 3.9 , 4.7
				Pattern := [[5, 6, 99], [0, 13, 99], [-5, 22, 99], [-7, 26, 99], [15, 7, 99], [6, 30, 99], [10, 21, 99], [12, 15, 99], [14, 13, 99], [-18, 11, 99], [-20, 6, 99], [9, 0, 99], [10, 6, 99], [-22, 5, 99], [-10, -11, 99], [-20, -13, 99], [-8, 6, 99], [-10, 5, 99], [-9, 0, 99], [15, 1, 99], [18, 3, 99], [15, 6, 99], [-5, 1, 99], [15, -3, 99], [15, -11, 99], [15, 0, 99], [-16, 6, 99], [-19, 3, 99], [-14, 1, 99], [-8, 1, 99]]

			}
		Sleep, 250
		}
		if GetKeyState(key_SG, "P") { ; 75% | Zoom  75% Alittle loose
			if (GunPattern != "SG") {
				GunSelection("SG", 4.50, 4.60)
				Pattern := [[-4, 9, 99],[-13, 15, 99],[-9, 25, 99],[-6, 29, 99],[-8, 31, 99],[-8, 36, 99],[-6, 8, 45],[-5, 7, 45],[7, 9, 45], [6, 9, 45],[-8, 12, 99],[-15, 8, 99],[-5, 5, 99],[-6, 5, 99],[-8, 6, 99],[-2, 6, 99],[-18, -6, 99],[-20, -13, 99],[-10, -9, 99],[19, -2, 99],[20, 3, 99],[15, -5, 99],[20, -1, 45],[15, -1, 45],[20, -1, 45],[20, -1, 45],[20, 9, 99],[20, 6, 99],[16, 5, 99],[6, 5, 99],[15, -2, 99],[15, -3, 99],[15, -5, 99],[-19, 8, 99],[-25, 5, 99],[-32, -5, 99]]

			}
		Sleep, 250
		} ; Recoil Hotkeys
		} Else {
			
		}
	} ; Loop
} ; Main Loop Function

;Welp you did it, you lurked on all this naked code. Pervert....
RCS:
    modifier := 2.52 / sens
    ;X := X + RandomizeValue(-0.5, 0.5)
    ;Y := Y + RandomizeValue(-0.5, 0.5)
    IfWinActive, ahk_exe CS2.exe
    {
        if InStr("AK|M4A1|M4A4|FAMAS|GALIL|UMP|AUG|SG|P90|MP5|Mac10|CZ75", GunPattern) {
        RecoilScaledX := (RCSPercentX * .01)
        RecoilScaledY := (RCSPercentY * .01)
        Sleep, 30
            for each, action in pattern {
                X := (action[1] / humanizer * modifier) * RecoilScaledX
                Y := (action[2] / humanizer * modifier) * RecoilScaledY

                if (GetKeyState(key_Zoom, "P") && InStr("AUG|SG", GunPattern)) {
                    Zoomsens := 0.75
                    obs := .75 / Zoomsens
                    X := (action[1] / humanizer * modifier) * RecoilScaledX
                    Y := (action[2] / humanizer * modifier) * RecoilScaledY
                }

                Loop, 4 {
                    DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", X, "UInt", Y)
                    Global totalOffsetX += X
                    Sleep, action[3] / waitdivider
                    Global totalOffsetY += Y
                    totalOffsetwaitdivider += action[3]/waitdivider
                    if !GetKeyState(key_shoot, "P") {
                        Settimer ReturnMouse, -25
                        RETURN
                    }
                }
            }
            if !GetKeyState(key_shoot, "P") {
            Settimer ReturnMouse, -25
                RETURN
            }
            DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
            Settimer ReturnMouse, -25
            Gosub ReloadGun
        }
    }
    if (GunPattern = "UniversalRCS" && UniversalRCS) {
    Settimer UniversalRCS, 10
    }
Return

UniversalRCS:
    UniversalRCSScaledX := (UniversalRCSPercentX * .01)
    UniversalRCSScaledY := (UniversalRCSPercentY * .01)
    y := Speed * UniversalRCSScaledY
        ; loop 
        {
            xMath := Rand(3.0) - Rand(3.0) * UniversalRCSScaledX
            UniversalRCS_HumanizeUniversal := (HumanizeUniversal ? xMath : 0)
            x := UniversalRCS_HumanizeUniversal
    ;Tooltip, x = %x% `n y= %y% `n gun = %GunPattern% `n UNI = %UniversalRCS% `n Rapid = %RapidFireT%
            DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", Round(x,.2), "UInt", Round(y,2))
            Sleep 1
            if !GetKeyState(key_shoot, "P") {
                Settimer UniversalRCS, Off
            }
        }
return

ReturnMouse:
    if ReturnMouseT && !ReturnMouseInProgress {
        ReturnMouseInProgress := true ; Prevent overlapping calls
        MoveMouseSmooth(totalOffsetX, totalOffsetY, 10, 1)
        totalOffsetY := 0
        totalOffsetX := 0
        ReturnMouseInProgress := false ; Allow further calls
        Settimer ReturnMouse, off
    }
return

GunKeys:
    {

        ; ---- Mapping of Hotkey -> GunName
        Global GunKeyMap := {}
        GunKeyMap[key_AK]         := "AK"
        GunKeyMap[Key_M4A1]       := "M4A1"
        GunKeyMap[Key_M4A4]       := "M4A4"
        GunKeyMap[Key_Famas]      := "FAMAS"
        GunKeyMap[Key_Galil]      := "GALIL"
        GunKeyMap[Key_UMP]        := "UMP"
        GunKeyMap[Key_AUG]        := "AUG"
        GunKeyMap[Key_SG]         := "SG"
        GunKeyMap[Key_P90]        := "P90"
        GunKeyMap[Key_MP5]        := "MP5"
        GunKeyMap[Key_Mac10]        := "Mac10"
        GunKeyMap[Key_CZ75]        := "CZ75"
        GunKeyMap[Key_UniversalRCS] := "UniversalRCS"
        GunKeyMap[Key_RCoff]      := "Recoil OFF"

        ; Initialize GunConfigs as an empty object first
        Global GunConfigs := {}

        GunConfigs["P90"] := {sense:3.90, zoom:4.05, pattern:[[-1,8,88],[-4,10,88],[-6,14,88],[-15,20,88],[-10,25,88],[4,25,88],[25,25,88],[-5,10,88],[-20,6,88],[-16,5,88],[-22,4,88],[23,2,88],[27,-1,88],[25,-1,88],[10,-1,88],[5,-1,88],[-5,-2,88],[-15,-2,88],[-15,-2,88],[-16,-2,88],[-15,-2,88],[1,-3,88],[1,-4,88],[6,-3,88],[6,-4,88],[-20,2,88],[35,2,88],[25,2,88],[10,2,88],[10,2,88],[55,2,88],[-20,2,88],[5,2,88],[5,2,88]]}

        GunConfigs["MP5"] := {sense:3.90, zoom:4.05, pattern:[[1,1,99],[-5,7,99],[-12,20,99],[-12,20,99],[-12,20,99],[-6,20,99],[-1,20,99],[31,-1,99],[27,-1,99],[-10,-2,99],[-10,-1,99],[5,6,99],[8,6,99],[-29,-8,99],[-29,-8,99],[5,-8,99],[6,-8,99],[-6,-4,99],[-7,-2,99]]}

        GunConfigs["AK"] := {sense:3.80, zoom:4.70, pattern:[[-4,7,99],[4,19,99],[-3,29,99],[-1,31,99],[13,31,99],[8,28,99],[13,21,99],[-17,12,99],[-42,-3,99],[-21,2,99],[12,11,99],[-15,7,99],[-26,-8,99],[-3,4,99],[40,1,99],[19,7,99],[14,10,99],[27,0,99],[33,-10,99],[-21,-2,99],[7,3,99],[-7,9,99],[-8,4,99],[19,-3,99],[5,6,99],[-20,-1,99],[-33,-4,99],[-45,-21,99],[-14,1,99]]}

        GunConfigs["M4A1"] := {sense:4.40, zoom:4.17, pattern:[[1,6,88],[0,4,88],[-4,14,88],[4,18,88],[-6,21,88],[-4,20,88],[14,14,88],[8,12,88],[18,5,88],[-14,5,88],[-25,-3,88],[-19,0,88],[-22,-3,88],[1,3,88],[8,3,88],[-9,1,88],[-11,-2,88],[5,2,88],[3,1,88]]}

        GunConfigs["M4A4"] := {sense:3.90, zoom:4.05, pattern:[[1,8,88],[0,15,9],[-2,16,87],[4,21,87],[-9,23,87],[-5,27,87],[18,15,88],[18,13,88],[16,6,44],[-20,4,44],[-15,6,88],[-15,4,80],[-15,-4,88],[-20,-6,88],[-20,-4,87],[2,12,87],[-5,-1,87],[-5,-2,87],[18,2,88],[10,-1,88],[14,6,88],[20,3,88],[15,2,88],[15,3,88],[-15,-3,87],[6,5,87],[4,5,87],[3,1,87],[4,-1,0]]}

        GunConfigs["FAMAS"] := {sense:3.60, zoom:4.18, pattern:[[0,4,5,88],[1,6,88],[-6,10,88],[-1,17,88],[6,20,88],[14,18,88],[15,12,88],[-18,14,88],[-15,8,88],[-18,5,88],[-13,2,88],[20,5,87],[18,4,88],[14,6,88],[10,-3,88],[10,0,88],[15,0,88],[6,5,88],[-14,3,88],[-10,5,80],[-8,5,84],[8,2,80],[9,-5,44],[9,-7,44],[-3,6,88]]}

        GunConfigs["GALIL"] := {sense:4.10, zoom:4.25, pattern:[[4,5,90],[-2,9,90],[6,10,90],[12,15,90],[-1,21,90],[2,24,90],[6,16,90],[6,10,90],[-18,14,90],[-20,8,90],[-28,-3,85],[-19,-13,90],[-23,8,90],[-12,2,85],[-7,1,90],[-2,10,50],[14,7,90],[25,7,85],[14,4,90],[25,-3,85],[31,-5,85],[6,3,90],[-12,3,90],[13,-1,90],[10,-1,90],[16,-4,90],[-9,5,90],[-32,-5,90],[-24,-3,90],[-15,5,90],[6,8,90],[-14,-3,90],[-24,-14,90],[-13,-1,90]]}

        GunConfigs["UMP"] := {sense:4.55, zoom:4.20, pattern:[[-3,16,90],[-4,18,90],[-3,18,90],[-4,23,90],[-9,23,85],[-3,26,85],[11,17,85],[-4,12,85],[9,13,90],[18,10,90],[15,6,90],[-1,5,90],[5,6,90],[1,6,85],[9,-3,85],[5,-1,85],[8,1,85],[7,4,85],[-2,-2,90],[-7,12,85],[-7,12,85],[-2,-4,85],[-8,-4,90],[-10,-4,85],[-2,-1,85],[-2,-3,85],[5,-3,85],[2,-6,90],[-6,-6,80]]}

        GunConfigs["AUG"] := {sense:3.90, zoom:4.70, pattern:[[5,6,99],[0,13,99],[-5,22,99],[-7,26,99],[15,7,99],[6,30,99],[10,21,99],[12,15,99],[14,13,99],[-18,11,99],[-20,6,99],[9,0,99],[10,6,99],[-22,5,99],[-10,-11,99],[-20,-13,99],[-8,6,99],[-10,5,99],[-9,0,99],[15,1,99],[18,3,99],[15,6,99],[-5,1,99],[15,-3,99],[15,-11,99],[15,0,99],[-16,6,99],[-19,3,99],[-14,1,99],[-8,1,99]]}

        GunConfigs["SG"] := {sense:4.50, zoom:4.60, pattern:[[-4,9,99],[-13,15,99],[-9,25,99],[-6,29,99],[-8,31,99],[-8,36,99],[-6,8,45],[-5,7,45],[7,9,45],[6,9,45],[-8,12,99],[-15,8,99],[-5,5,99],[-6,5,99],[-8,6,99],[-2,6,99],[-18,-6,99],[-20,-13,99],[-10,-9,99],[19,-2,99],[20,3,99],[15,-5,99],[20,-1,45],[15,-1,45],[20,-1,45],[20,-1,45],[20,9,99],[20,6,99],[16,5,99],[6,5,99],[15,-2,99],[15,-3,99],[15,-5,99],[-19,8,99],[-25,5,99],[-32,-5,99]]}

        GunConfigs["CZ75"] := {sense:3.60, zoom:4.18, pattern:[[-5,4,88],[-16,8,88],[5,16,88],[43,10,88],[22,17,99],[-40,54,99],[-50,5,99],[30,5,99],[5,25,99],[-15,22,99],[-15,23,99]]}

        GunConfigs["Mac10"] := {sense:4.55, zoom:4.20, pattern:[[-3,4,90],[-1,13,90],[8,22,90],[15,25,90],[20,35,90],[10,38,90],[10,20,90],[10,18,90],[6,15,90],[-15,14,90],[-25,4,90],[-39,-6,90],[-20,-9,90],[10,-9,90],[-10,-9,90],[-15,-9,90],[-9,-7,90],[17,-6,90],[33,25,90],[34,21,90],[-14,-15,90],[-14,-15,90]]}

        ; Special entries (no recoil or universal)
        GunConfigs["UniversalRCS"] := { sense:0, zoom:0, pattern:[] }
        GunConfigs["Recoil OFF"]    := { sense:0, zoom:0, pattern:[] }
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
        ahgdsfh := e1 . "!" . " | " . Version
        Tabs := "Recoil|Universal RCS|BHOP|RapidFire|PixelBot|Magnifier|Crosshair|Extras"
        GuiVisible := true
        Gui, +AlwaysOnTop  +Owner -MinimizeBox +0x400000
        Gui, Margin, 0, 0
        Gui, Color, Black
        Gui, Font, cWhite s12, Comic Sans MS 
        Gui, Add, Text, x5 y5, %A_UserName%`, Good Luck && Have Fun!

        Gui, Add, Text, x5 y25, %ahgdsfh%
        Gui, Add, Tab, xM+3 yM+50 Section w350 h547 c0x3db7f7, %Tabs%
        
    ; ============== Recoil Tab ==============
        Gui, tab, Recoil
        {
        Gui, Add, GroupBox, xs+10 ys+70 Section w180 H450 c0xFFC000 ,RCS Hotkeys
        
        Gui, Add, text, xs+5  ys+25 c0x00ff18, Scoped-IN:
        Gui, Add, Hotkey, xs+95  ys+23   w80 vKey_Zoom, %Key_Zoom%
        Gui, Add, Text, xs+5  ys+55 c0x00ff18, AK-47:
        Gui, Add, Hotkey, xs+70  ys+53   w105 vKey_AK, %Key_AK%
        Gui, Add, Text, xs+5  ys+85 c0x00ff18, M4A1:
        Gui, Add, Hotkey, xs+70  ys+83    w105 vKey_M4A1, %Key_M4A1%
        Gui, Add, Text, xs+5  ys+115 c0x00ff18, M4A4:
        Gui, Add, Hotkey, xs+70  ys+113    w105 vKey_M4A4, %Key_M4A4%
        Gui, Add, Text, xs+5  ys+145 c0x00ff18, Famas:
        Gui, Add, Hotkey, xs+70  ys+143    w105 vKey_Famas, %Key_Famas%
        Gui, Add, Text, xs+5  ys+175 c0x00ff18, Galil:
        Gui, Add, Hotkey, xs+70  ys+173    w105 vKey_Galil, %Key_Galil%
        Gui, Add, Text, xs+5  ys+205 c0x00ff18, UMP:
        Gui, Add, Hotkey, xs+70  ys+203    w105 vKey_UMP, %Key_UMP%
        Gui, Add, Text, xs+5  ys+235 c0x00ff18, AUG:
        Gui, Add, Hotkey, xs+70  ys+233    w105 vKey_AUG, %Key_AUG%
        Gui, Add, Text, xs+5  ys+265 c0x00ff18, SG:
        Gui, Add, Hotkey, xs+70  ys+263    w105 vKey_SG, %Key_SG%
        
        Gui, Add, Text, xs+5  ys+293 c0x00ff18, Mac10:
        Gui, Add, Hotkey, xs+70  ys+293    w105 vKey_Mac10, %Key_Mac10%	
        Gui, Add, Text, xs+5  ys+323 c0x00ff18, CZ75:
        Gui, Add, Hotkey, xs+70  ys+323    w105 vKey_CZ75, %Key_CZ75%	
        Gui, Add, Text, xs+5  ys+353 c0x00ff18, P90:
        Gui, Add, Hotkey, xs+70  ys+353    w105 vKey_P90, %Key_P90%	
        Gui, Add, Text, xs+5  ys+383 c0x00ff18, MP5:
        Gui, Add, Hotkey, xs+70  ys+383    w105 vKey_MP5, %Key_MP5%
        
        Gui, Add, Text, xs+5  ys+415 c0x00ff18, Recoil Off:
        Gui, Add, Hotkey, xs+95  ys+413    w80 vKey_RCoff, %Key_RCoff%

        Gui, Add, GroupBox, xs+182 ys+0 W150 H450 c0xFFC000 +Center,Other

        Gui, Add, text, xs+212  ys+32 c0xc548ec  , Sensitivity:
        Gui, Add, Edit, xs+207  ys+60 w100 cBlack vSens1, % sens
        
        Gui, Add, Text, xS+195 ys+145 c0xFFC000, % "Recoil   %   X"
        Gui, Add, Slider, xs+185  ys+165 w145 cBlack vRCSPercentX1 gRCSPercentX +ToolTip +Range1-100, %RCSPercentX%	
        Gui, Add, Text, xS+195 ys+195 c0xFFC000, % "Recoil   %   Y"
        Gui, Add, Slider, xs+185  ys+215 w145 cBlack vRCSPercentY1 gRCSPercentY +ToolTip +Range1-100, %RCSPercentY%
        
        ReturnMouseTColor:= % (ReturnMouseT ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+195 ys+350 Checked%ReturnMouseT% gCheckBoxHandler c%ReturnMouseTColor%, Return Mouse

        Gui, Add, Button, xS+200 ys+400 w110 h40 gButtonHandler +0x8000, Save Recoil
        }

        Gui, Font, s18, Comic Sans MS
        
    ; ============== Universal RCS Tab ==============
        Gui, Tab, Universal RCS
        {
        UniversalRCSColor:= % (UniversalRCS ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+80 ys+30 Checked%UniversalRCS% gCheckBoxHandler c%UniversalRCSColor%, Universal RCS

        HumanizeUniversalColor:= % (HumanizeUniversal ? "Green" : "0xCB0000")
        if (!UniversalRCS) {
            Gui, Add, CheckBox, xS+90 ys+70 Checked%HumanizeUniversal% gCheckBoxHandler c%HumanizeUniversalColor% Hidden, Humanizer
        } Else {
            Gui, Add, CheckBox, xS+90 ys+70 Checked%HumanizeUniversal% gCheckBoxHandler c%HumanizeUniversalColor%, Humanizer
        }
        Gui, Add, text, xs+30  ys+105 c0x00ff18, Hotkey:
        Gui, Add, Hotkey, xs+20  ys+150   w120 vKey_UniversalRCS, %Key_UniversalRCS%
        Gui, Add, text, xs+210  ys+105 c0xc548ec, Speed:
        Gui, Add, Edit, xs+200  ys+150    w100 cBlack vSpeed1, %Speed%
        
        Gui, Add, Text, xS+20 ys+270 c0xFFC000, % "Recoil % X"
        Gui, Add, Slider, xs+15  ys+300 w145 cBlack vUniversalRCSPercentX1 gUniversalRCSPercentX +ToolTip +Range1-100, %UniversalRCSPercentX%	
        Gui, Add, Text, xS+170 ys+270 c0xFFC000, % "Recoil % Y"
        Gui, Add, Slider, xs+160  ys+300 w145 cBlack vUniversalRCSPercentY1 gUniversalRCSPercentY +ToolTip +Range1-100, %UniversalRCSPercentY%
        
        Gui, Add, Button,  xS+45 ys+405 w250 h30 gButtonHandler, Save Universal RCS
        
        }

    ; ============== PixelBot Tab ==============
        Gui, tab, PixelBot
        {
        PixelBotGUIColor := % (TriggerBotT ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+105 ys+30 Checked%TriggerBotT% c%PixelBotGUIColor% gCheckBoxHandler, PixelBot
        Gui, Add, Combobox, xS+90 ys+70 w150 vKey_PixelBot, XButton1|XButton2|Z|X|C|Alt|Ctrl|CapsLock
        GuiControl, Choose, Key_PixelBot, %Key_PixelBot%
        Gui, Add, Text, xS+5 ys+120 h20 c0xc548ec Center, Min:
        Gui, Add, edit, xS+5 ys+150 cBlack vReactionMin, %reaction_min%
        Gui, Add, Text, xS+255 ys+120 h20 c0xc548ec Center, Max:
        Gui, Add, edit, xS+255 ys+150 cBlack vReactionMax, %reaction_max%
        GUI Add, Text, xS+90 ys+130 c0xB0AE3B BackgroundTrans, Shoots When`nCenter Pixel`nChanges Color
        TriggerBotNotificationGUIColor := % (TriggerBotNotification ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+45 ys+360 Checked%TriggerBotNotification% gCheckBoxHandler c%TriggerBotNotificationGUIColor%, PixelBot Notification
        Gui, Add, Button, xS+45 ys+405 w250 h30 gButtonHandler, Save Pixel Bot
        }

    ; ============== RapidFire Tab ==============
        Gui, tab, RapidFire
        {
        RapidFireGUIColor := % (RapidFireT ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+100 ys+30 Checked%RapidFireT% gCheckBoxHandler c%RapidFireGUIColor%, RapidFire
        Gui, Add, Combobox, xS+90 ys+70 w150 vKey_RapidFire, XButton1|XButton2|LButton|Z|X|C|Alt|Ctrl|CapsLock
        GuiControl, Choose, Key_RapidFire, %Key_RapidFire%
        Gui, Add, Text, xS+5 ys+120 h20 c0xc548ec Center, Min:
        Gui, Add, edit, xS+5 ys+150 cBlack vRFL1, %RFL%
        Gui, Add, Text, xS+255 ys+120 h20 c0xc548ec Center, Max:
        Gui, Add, edit, xS+245 ys+150 w70 cBlack vRFH1, %RFH%
        Gui, Add, Button, xS+45 ys+405 w250 h30 gButtonHandler, Save Rapid Fire
        }

    ; ============== BHOP Tab ==============
        Gui, Tab, BHOP
        {
        Gui, Add, GroupBox, xS+5 yS+5 w200 h170 c0xFFC000, Settings
        Gui, Add, CheckBox, xS+20 yS+45 h35 Checked%BHOPT% c%BHOP_GUIColor% gCheckBoxHandler, BHOP
        Gui, Add, Hotkey, xS+20 yS+85 w160 h35 vKey_BHOP, %Key_BHOP%

        Gui, Add, GroupBox, xS+5 yS+185 w200 h130 c0xFFC000, Modes
        Gui, Add, Radio, xS+20 yS+225 w150 h25 Checked%Legit% vLegit gBHOP_Handler, Legit
        Gui, Add, Radio, xS+20 yS+255 w150 h25 Checked%Perfect% vPerfect gBHOP_Handler, Perfect
        Gui, Add, Radio, xS+20 yS+285 w165 h25 Checked%ScrollWheel% vScrollWheel gBHOP_Handler, ScrollWheel

        Gui, Add, Button, xS+95 ys+355  w150 h30 gButtonHandler +0x8000, BHOP TIPS
        Gui, Add, Button, xS+45 ys+405 w250 h30 gButtonHandler +0x8000, Save BHOP
        
        GoSub GUIBHOP
        }

    ; ============== Magnifier Tab ==============
        Gui, Tab, Magnifier
        {
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

        Gui, Add, Button, xS+45 ys+405 w250 h30  gButtonHandler, Save Magnifier
        }

    ; ============== Crosshair Tab ==============
        Gui, Tab, Crosshair
        {
        CrosshairGUIColor:= % (CrosshairT ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+50 ys+15 Checked%CrosshairT% c%CrosshairGUIColor% gCheckBoxHandler, CrossHair Toggle

        Gui, Add, GroupBox, xS+5 yS+50 w300 h90 c0xFFC000 +Center, Settings
        Gui, Add, Text, xS+10 ys+85 h20 c0xc548ec Center, Size:
        Gui, Add, Edit, xS+70 ys+83 cBlack vCrosshairSize, %CrosshairSize%
        Gui, Add, Text, xS+130 ys+85 h20 c0xc548ec Center, Color:
        Gui, Add, Edit, xS+200 ys+83 w100 cBlack vCrossHairColor, %CrossHairColor%

        Gui, Add, GroupBox, xS+5 ys+140 h20 Center w300 h80 c0xFFC000, Select CrossHair
        Gui, Add, Button, xS+180 ys+180 w80 h30 gCrossHairMenu, Extras
        Gui, Add, Button, xS+50  ys+180 w30 h30 gSelectCrosshair, ∙
        Gui, Add, Button, xS+80 ys+180 w30 h30 gSelectCrosshair, +
        Gui, Add, Button, xS+110 ys+180 w30 h30 gSelectCrosshair, ×
        Gui, Add, Button, xS+140  ys+180 w30 h30 gSelectCrosshair, ¤

        Gui, Add, GroupBox, xS+5 ys+220 h20 Center w300 h80 c0xFFC000, Transparency Slider
        Gui, Add, Slider, xS+10 ys+260 W290 vCrossHairTrans gCrossHairTrans1 +ToolTip +Range0.0-224, %CrossHairTrans%
        Gui, Add, Button, xS+45 ys+405 w250 h30 gButtonHandler, Save CrossHair
        }

    ; ============== Extras Tab ==============
        Gui, tab, Extras
        {
        TurnAroundTColor:= % (TurnAroundT ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+5 ys+10 Checked%TurnAroundT% gCheckBoxHandler c%TurnAroundTColor%, Turn Around
        Gui, Add, Hotkey, xS+190 ys+5 w80 vkey_180, %Key_180%

        RecoilSafetyColor:= % (RecoilSafety ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+5 ys+67 Checked%RecoilSafety% gCheckBoxHandler c%RecoilSafetyColor%, Recoil Safety
        Gui, Add, Hotkey, xs+190  ys+63 w80 vKey_Safety, %Key_Safety%

        RCSNotificationColor:= % (RCSNotification ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+5 ys+110 Checked%RCSNotification% gCheckBoxHandler c%RCSNotificationColor% , Notification
        
        SpeechTColor:= % (SpeechT ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+5 ys+140 Checked%SpeechT% gCheckBoxHandler c%SpeechTColor%, Speech
        
        SniperQQColor:= % (SniperQQ ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+5 ys+170 Checked%SniperQQ% gCheckBoxHandler c%SniperQQColor%, Sniper QQ
        
        CounterStrafeTColor:= % (CounterStrafeT ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+5 ys+200 Checked%CounterStrafeT% gCheckBoxHandler c%CounterStrafeTColor%, Counter Strafe
        
        ReloadTColor:= % (ReloadT ? "Green" : "0xCB0000")
        Gui, Add, CheckBox, xS+5 ys+230 Checked%ReloadT% gCheckBoxHandler c%ReloadTColor%, Quick Reload

        Gui, Add, Button, xS+40 ys+405 w250 h30 gButtonHandler, Save Extras
        
        Gui, Font, s14, Impact
        Gui, Add, Button, xS+20 ys+355 w150 h40 gButtonHandler, Mouse Properties
        Gui Add, Button, xS+180 ys+355 w125 h40 gSelectProcess, Elevate Priority
        }
        
        Gui, tab
        Gui, Show, x10 y250 h571 w350, %ahgdsfh%
        Gui, -border -caption
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
	Click(35,65,5,10)
	Sleep, PilgrimMites(RFL,RFH)
Return

QQ:
	Sleep 10
	SendInput, q
	Sleep, 30
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
        UniversalRCS:= true
    } if (GunPattern != "UniversalRCS") {
        UniversalRCS:= false
    }
    Gosub UniversalRCS_GUI
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

    Switch A_GuiControl {
        Case "Universal RCS": {
		    if (UniversalRCS) {
                GunPattern := "Recoil OFF"
                UniversalRCS := 0
                Gosub UniversalRCS_handler
				sleep 100
				Speak("Recoil OFF")
            } Else {
                GunPattern := "UniversalRCS"
                UniversalRCS := 1
                Gosub UniversalRCS_handler
				sleep 100
				Speak("Universal RCS")
            }
		}

		Case "Return Mouse": {
			ReturnMouseT := !ReturnMouseT
			ReturnMouseTColor := ReturnMouseT ? "Green" : "0xCB0000"
            GuiControl, +c%ReturnMouseTColor%, Return Mouse
		
		}

        Case "Recoil Safety": {
            RecoilSafety := !RecoilSafety
			RecoilSafetyColor := RecoilSafety ? "Green" : "0xCB0000"
            GuiControl, +c%RecoilSafetyColor%, Recoil Safety
        }
		
        Case "CrossHair Toggle": {
            Goto CrossHairToggler
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
            TriggerBotNotificationColor := TriggerBotNotification ? "Green" : "0xCB0000"
            GuiControl, +c%TriggerBotNotificationColor%, PixelBot Notification
            Gosub PixelBotNotification
        }
		
        Case "Speech": {
            SpeechT := !SpeechT
			SpeechTColor:= SpeechT ? "Green" : "0xCB0000"
            GuiControl, +c%SpeechTColor%, Speech
        }
		
        Case "Counter Strafe": {
            Goto CounterStrafe
        }
		
        Case "Turn Around": {
            TurnAroundT := !TurnAroundT
			TurnAroundTColor:= % (TurnAroundT ? "Green" : "0xCB0000")
            GuiControl, +c%TurnAroundTColor%, Turn Around
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
			ReloadTColor:= % (ReloadT ? "Green" : "0xCB0000")
			GuiControl, +c%ReloadTColor%, Quick Reload
		}
			
		Case "Sniper QQ": {
			SniperQQ:=!SniperQQ
			SniperQQColor:= % (SniperQQ ? "Green" : "0xCB0000")
            GuiControl, +c%SniperQQColor%, Sniper QQ
		}
		
        Default:
            Msgbox, 48, Error!, Error Checkbox Handler., 5
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
    global sens := Sens1
    MsgBox, 4, Save Settings?, 
    (
    Sensitivity: %sens%
    Return Mouse: %ReturnMouseT%
    AK: %Key_AK%
    M4A1: %Key_M4A1%
    M4A4: %Key_M4A4%
    Famas: %Key_Famas%
    Galil: %Key_Galil%
    UMP: %Key_UMP%
    AUG: %Key_AUG%
    SG: %Key_SG%
    Mac10: %Key_Mac10%
    MP5: %Key_MP5%
    CZ75: %Key_CZ75%
    P90 : %Key_P90%
    Universal RCS Key: %Key_UniversalRCS%
    Recoil Off: %Key_RCoff%
    Notification: %RCSNotification%
    Zoom Key: %Key_Zoom%
    RCS Percent X: %RCSPercentX%
    RCS Percent Y: %RCSPercentY%
    )
    IfMsgBox Yes
        Saving := [[Key_P90, "Hotkeys", "Key_P90"],[Key_CZ75, "Hotkeys", "Key_CZ75"],[Key_MP5, "Hotkeys", "Key_MP5"],[Key_Mac10, "Hotkeys", "Key_Mac10"],[Key_AK, "Hotkeys", "Key_AK"], [Key_M4A1, "Hotkeys", "Key_M4A1"], [Key_M4A4, "Hotkeys", "Key_M4A4"], [Key_Famas, "Hotkeys", "Key_Famas"], [Key_Galil, "Hotkeys", "Key_Galil"], [Key_UMP, "Hotkeys", "Key_UMP"], [Key_AUG, "Hotkeys", "Key_AUG"], [Key_SG, "Hotkeys", "Key_SG"], [Key_RCoff, "Hotkeys", "Key_RCoff"], [Key_Zoom, "Hotkeys", "Key_Zoom"], [sens, "General", "sens"], [RCSPercentX, "General", "RCSPercentX"],[RCSPercentY, "General", "RCSPercentY"], [ReturnMouseT, "Toggle", "ReturnMouseT"]]
        gosub GunKeys ; GUI will not register new hotkeys with out this for some reason
            for index, Save in Saving {
                CustomSave(Save.1, Save.2, Save.3)
    }

                        
Case "SAVE Universal RCS":
        global Speed := Speed1
        MsgBox, 4, Save Settings?, 
        (
    Universal RCS: %UniversalRCS%
    Humanize Universal: %HumanizeUniversal%
    Hotkey: %Key_UniversalRCS%
    Speed: %Speed%
        )
        IfMsgBox Yes
            Saving := [[Key_UniversalRCS, "Hotkeys", "Key_UniversalRCS"], [UniversalRCS, "Toggle", "UniversalRCS"], [HumanizeUniversal, "Toggle", "HumanizeUniversal"], [Speed, "General", "Speed"], [UniversalRCSPercentX, "General", "UniversalRCSPercentX"], [UniversalRCSPercentY, "General", "UniversalRCSPercentY"]]
            for index, Save in Saving {
                CustomSave(Save.1, Save.2, Save.3)
            }

Case "SAVE PIXEL BOT":
        if (ReactionMin >= ReactionMax) {
            MsgBox, 48, Warning: Invalid Input,
            (
            The minimum reaction time should be lower than the maximum reaction time.
            Please make sure to enter a valid range.
            ), 5
            return
        }
        global reaction_min := ReactionMin, reaction_max := ReactionMax
        MsgBox, 4, Save Settings?, 
        (
    Toggle State: %TriggerBotT%
    TriggerBot: %Key_PixelBot%
    TB Min: %reaction_min%
    TB Max: %reaction_max%
    Notification: %TriggerBotNotification%
        )
        IfMsgBox Yes
            Saving := [[Key_PixelBot, "Hotkeys", "Key_PixelBot"], [reaction_min, "PixelBot", "reaction_min"], [reaction_max, "PixelBot", "reaction_max"], [TriggerBotT, "PixelBot", "TriggerBotT"], [TriggerBotNotification, "Toggle", "TriggerBotNotification"]]
            for index, Save in Saving {
                CustomSave(Save.1, Save.2, Save.3)
            }

Case "SAVE RAPID FIRE":
        if (RFL1 >= RFH1) {
            MsgBox, 48, Warning: Invalid Input,
            (
            The minimum reaction time should be lower than the maximum reaction time.
            Please make sure to enter a valid range.
            ), 5
            return
        }
        global RFL := RFL1, RFH := RFH1
        MsgBox, 4, Save Settings?, 
        (
    Toggle State: %RapidFireT%
    RapidFire: %Key_RapidFire%
    RF Min: %RFL%
    RF Max: %RFH%
        )
        IfMsgBox Yes
            Saving := [[Key_RapidFire, "Hotkeys", "Key_RapidFire"], [RFL, "RapidFire", "RFL"], [RFH, "RapidFire", "RFH"], [RapidFireT, "RapidFire", "RapidFireT"]]
            for index, Save in Saving {
                CustomSave(Save.1, Save.2, Save.3)
            }

Case "Save BHOP":
        MsgBox, 4, Save Settings?, 
        (
    BHOP Key: %Key_BHOP%
    BHOP Toggle: %BHOPT%
    Legit: %Legit%
    Perfect: %Perfect%
    ScrollWheel: %ScrollWheel%
        )
        IfMsgBox Yes
            Saving := [[Key_BHOP, "Hotkeys", "Key_BHOP"], [BHOPT, "BHOP", "BHOPT"], [Legit, "BHOP", "Legit"], [Perfect, "BHOP", "Perfect"], [ScrollWheel, "BHOP", "ScrollWheel"]]
            for index, Save in Saving {
                CustomSave(Save.1, Save.2, Save.3)
            }

Case "SAVE Magnifier":
        global Zoom := Zoom1, Size := Size1, Delay := Delay1
        MsgBox, 4, Save Settings?, 
        (
    Toggle State: %Magnifier%
    Zoom: %Zoom%
    Size: %Size%
    Delay: %Delay%
        )
        IfMsgBox Yes
            Saving := [[Zoom, "Magnifier", "Zoom"], [Size, "Magnifier", "Size"], [Delay, "Magnifier", "Delay"], [Magnifier, "Magnifier", "Magnifier"]]
            for index, Save in Saving {
                CustomSave(Save.1, Save.2, Save.3)
            }
            if (Magnifier) {
                GoSub DestroyZoomin
                GoSub CreateZoomIN
            }

Case "SAVE CrossHair":
        MsgBox, 4, Save Settings?, 
        (
    Toggle State: %CrossHairT%
    CrossHair: %SelectedCrosshair%
    CrossHair Transparency: %CrossHairTrans%
    CrossHair Size: %CrossHairSize%
    CrossHair Color: %CrossHairColor%
        )
        IfMsgBox Yes
            Saving := [[CrossHairTrans, "CrossHair", "CrossHairTrans"], [SelectedCrosshair, "CrossHair", "SelectedCrosshair"], [CrossHairSize, "CrossHair", "CrossHairSize"], [CrossHairColor, "CrossHair", "CrossHairColor"], [CrossHairT, "CrossHair", "CrossHairT"]]
            for index, Save in Saving {
                CustomSave(Save.1, Save.2, Save.3)
            }
            if (CrossHairT) {
                GoSub DestroyCrossHair
                GoSub CreateCrossHair
            }

Case "Save Extras":
        MsgBox, 4, Save Settings?, 
        (
    TurnAround Toggle: %TurnAroundT%
    Turn Around Key: %key_180%
    RCS Safety Toggle: %RecoilSafety%
    RCS Safety Key: %Key_Safety%
    Crouch Correction Toggle: %DuckT%
    Speech Toggle: %SpeechT%
    Counter Strafe: %CounterStrafeT%
    Quick Reload: %ReloadT%
    Sniper QQ: %SniperQQ%
        )
        IfMsgBox Yes
            Saving := [[Key_180, "Hotkeys", "Key_180"], [TurnAroundT, "Toggle", "TurnAroundT"], [Key_Safety, "Hotkeys", "Key_Safety"], [RecoilSafety, "Toggle", "RecoilSafety"], [SpeechT, "Toggle", "SpeechT"], [CounterStrafeT, "Toggle", "CounterStrafeT"], [SniperQQ, "Toggle", "SniperQQ"], [ReloadT, "Toggle", "ReloadT"]]
            for index, Save in Saving {
                CustomSave(Save.1, Save.2, Save.3)
            }

Case "Mouse Properties":
        Run main.cpl

Case "Elevate Priority":
        Gosub, SelectProcess

Case "BHOP TIPS":
        MsgBox, 1, Bind ScrollWheel IN-GAME, 
        (
        BHOP will sometimes NOT work when BHOP is bound to spacebar!

        To use ScrollWheel BHOP you need to use this in the command console:
        "Bind mwheeldown +jump;bind mwheelup +jump;bind space +jump"

        ^ This bind is for CS2

        Do you want to copy the CS2 Bind to your Clipboard?
        ), 20
        IfMsgBox OK
            Clipboard := "Bind mwheeldown +jump;bind mwheelup +jump;bind space +jump"
    }   
}
Return

BHOP_Handler:
    if (BHOPT) {
	Switch A_GuiControl {
		Case "Legit":
			if (Legit = 0) {
				Legit := 1, Perfect := 0, ScrollWheel := 0			
				}
		Case "Perfect":
			if (Perfect = 0) {
				Legit := 0, Perfect := 1, ScrollWheel := 0			
				}
        Case "ScrollWheel":
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
Return

HideToolTip:
    SetTimer, HideToolTip, Off
    ToolTip, , , , %ToolTips%
return

CounterStrafe:
    CounterStrafeT := !CounterStrafeT
    Gosub CounterstrafeGUI
    Gosub ToggleScripts
return

CounterstrafeGUI:
    if (GuiVisible) {
    GuiControl,, Universal RCS, % (UniversalRCS ? "1" : "0")
    CounterStrafeTColor:= % (CounterStrafeT ? "Green" : "0xCB0000")
    GuiControl, +c%CounterStrafeTColor%, Counter Strafe
    }
    If (!CounterStrafeT) {
        ShowToolTip("", , , 3)
        Menu, Tray, Uncheck, Toggle Counter Strafe
    } else {
        ShowToolTip("CounterStrafe | ON", , 40, 3)
        Menu, Tray, Check, Toggle Counter Strafe
    }
Return


;---------------------------
; Global Variables
;---------------------------
global autostrafe := false
global prevX := ""
threshold := 10  ; Minimum movement (in pixels) to trigger a key press

;---------------------------
; Toggle Hotkey (F12)
;---------------------------
^!F12::
    autostrafe := !autostrafe
    if (autostrafe) {
        #UseHook
        SendMode, Input
        CoordMode, Mouse, Screen
        TrayTip, Autostrafe, Autostrafe ENABLED, 1
        MouseGetPos, prevX
        SetTimer, DoAutostrafe, 10
    } else {
        TrayTip, Autostrafe, Autostrafe DISABLED, 1
        SetTimer, DoAutostrafe, Off
        if GetKeyState("a", "P")
            SendInput, {a up}
        if GetKeyState("d", "P")
            SendInput, {d up}
    }
return

;---------------------------
; Autostrafe Logic
;---------------------------
DoAutostrafe:
    MouseGetPos, mX
    if (prevX = "")
    {
        prevX := mX
        return
    }

    deltaX := mX - prevX

    if (Abs(deltaX) < threshold) {
        if GetKeyState("a", "P")
            SendInput, {a up}
        if GetKeyState("d", "P")
            SendInput, {d up}
    }
    else if (deltaX < 0) {   ; Left movement
        if !GetKeyState("a", "P")
            SendInput, {a down}
        if GetKeyState("d", "P")
            SendInput, {d up}
    }
    else if (deltaX > 0) {   ; Right movement
        if !GetKeyState("d", "P")
            SendInput, {d down}
        if GetKeyState("a", "P")
            SendInput, {a up}
    }

    prevX := mX
return



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
        Gosub CloseScripts
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

UniversalRCSPercentX:
    GuiControlGet, UniversalRCSPercentX1
    Global UniversalRCSPercentX:=UniversalRCSPercentX1
Return

UniversalRCSPercentY:
    GuiControlGet, UniversalRCSPercentY1
    Global UniversalRCSPercentY:=UniversalRCSPercentY1
Return

RCSPercentX:
    GuiControlGet, RCSPercentX1
    Global RCSPercentX:=RCSPercentX1
Return

RCSPercentY:
    GuiControlGet, RCSPercentY1
    Global RCSPercentY:=RCSPercentY1
Return

FindSettings:
    if !FileExist("Settings.ini") {
        FileAppend, [PilgrimMites] Available for Free!`n"https://www.unknowncheats.me/forum/counter-strike-2-releases/605440-ahk-multiscript-peans-rcs.html"`n`n, Settings.ini
        Gosub SaveALLSettings
    } Else {
    ;MsgBox, 48,ERROR!,Settings already exist!, 5
    }
Return

Settings:
	settingsGeneral := {sens: "sens", zoomsens: "zoomsens", Speed: "Speed", GunPattern: "GunPattern", RCSPercentX: "RCSPercentX", RCSPercentY: "RCSPercentY", UniversalRCSPercentX: "UniversalRCSPercentX", UniversalRCSPercentY: "UniversalRCSPercentY"}
	settingsHotkeys := {Key_AK: "Key_AK", Key_M4A1: "Key_M4A1", Key_M4A4: "Key_M4A4", Key_Famas: "Key_Famas", Key_Galil: "Key_Galil", Key_UMP: "Key_UMP", Key_AUG: "Key_AUG", Key_SG: "Key_SG", Key_P90: "Key_P90", Key_MP5: "Key_MP5", Key_CZ75: "Key_CZ75", Key_Mac10: "Key_Mac10", Key_180: "Key_180", Key_RCoff: "Key_RCoff", Key_RapidFire: "Key_RapidFire", Key_PixelBot: "Key_PixelBot", Key_BHOP: "Key_BHOP", Key_UniversalRCS: "Key_UniversalRCS"}
	settingsPixelBot := {TriggerBotT: "TriggerBotT", reaction_min: "reaction_min", reaction_max: "reaction_max"}
	settingsCrossHair := {CrossHairT: "CrossHairT", CrossHairTrans: "CrossHairTrans", SelectedCrosshair: "SelectedCrosshair", CrossHairSize: "CrossHairSize", CrossHairColor: "CrossHairColor"}
	settingsRapidFire := {RapidFireT: "RapidFireT", RFL: "RFL", RFH: "RFH"}
	settingsMagnifier := {Magnifier: "Magnifier", Zoom: "Zoom", Size: "Size", Delay: "Delay", MagnifierTrans: "MagnifierTrans"}
	settingsBHOP := {BHOPT: "BHOPT", Legit: "Legit", Perfect: "Perfect", ScrollWheel: "ScrollWheel"}
	settingsToggle := {ReturnMouseT: "ReturnMouseT", RCSNotification: "RCSNotification", TriggerBotNotification: "TriggerBotNotification", TurnAroundT: "TurnAroundT", RecoilSafety: "RecoilSafety", UniversalRCS: "UniversalRCS", SpeechT: "SpeechT", CounterStrafeT: "CounterStrafeT", ReloadT: "ReloadT", SniperQQ: "SniperQQ", HumanizeUniversal: "HumanizeUniversal"}
	Reading := [ {name: "General", data: settingsGeneral},{name: "Hotkeys", data: settingsHotkeys},{name: "PixelBot", data: settingsPixelBot},{name: "CrossHair", data: settingsCrossHair},{name: "RapidFire", data: settingsRapidFire},{name: "Magnifier", data: settingsMagnifier},{name: "BHOP", data: settingsBHOP},{name: "Toggle", data: settingsToggle} ]
Return

ReadALLSettings: 
    {
        if (FileExist("Settings.ini")) {
    ; Add all settings sections to an array
        Gosub, Settings
    ; Loop through each section
    for _, sectionObj in Reading {
        sectionName := sectionObj.name
        sectionData := sectionObj.data

        ; Loop through key-value pairs in the section
        for key, value in sectionData {
            ; Call CustomRead with three parameters: section name, key, and value
            CustomRead(key, sectionName, value)
        }
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
Return

SaveALLSettings: 
    {
        if (FileExist("Settings.ini")) {
    ; Add all settings sections to an array
        Gosub, Settings
    ; Loop through each section
    for _, sectionObj in Reading {
        sectionName := sectionObj.name
        sectionData := sectionObj.data

        ; Loop through key-value pairs in the section
        for key, value in sectionData {
            ; Call CustomRead with three parameters: section name, key, and value
            CustomSave(%key%, sectionName, value)
        }
        FileAppend, `n, Settings.ini
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
        
    mainloop() ; DO NOT REMOVE!!!!!!!!!!!!!!!
    }
Return

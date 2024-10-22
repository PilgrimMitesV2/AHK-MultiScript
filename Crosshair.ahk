CrossHair:
CrosshairGUIColor:= % (CrosshairT ? "Green" : "0xCB0000")
GuiControl, +c%CrosshairGUIColor%, CrossHair Toggle
If (CrosshairT) {
	GoSub CreateCrossHair
	Menu, Tray, Check, Toggle CrossHair
} else {
	GoSub DestroyCrossHair
	Menu, Tray, Uncheck, Toggle CrossHair
}
Return

CrossHairToggler:
CrosshairT:=!CrosshairT
Gosub,Crosshair
Return

CreateCrossHair:
CrossHairHWND := 0
	ActiveWindow := WinExist("A")
    Gui, CrossHair:new, -Caption +E0x80000 +LastFound +Owner +AlwaysOnTop +E0x20
	Gui, CrossHair:Margin, -1, -1
    Gui, CrossHair:Font, c%CrossHairColor% s%CrossHairSize% q4
    Gui, CrossHair:Add, Text, , %SelectedCrosshair%
	Controlgetpos, , , CrossHairW, CrossHairH, ,
	xPos  := (A_ScreenWidth//2 - CrossHairW//2 + 1)
	yPos  := (A_ScreenHeight//2 - CrossHairH//2)
	Gui CrossHair:show, x%xPos% y%yPos% NA
    Gui, CrossHair:Color, 00FF00
    WinSet, TransColor, 00FF00 %CrossHairTrans%
	WinActivate, ahk_id %ActiveWindow%
    CrossHairT := true
	WinGet, CrossHairHWND, ID
return

DestroyCrossHair:
	Gui, CrossHair:Destroy
	CrossHairT:= false
Return

CrossHairMenu:
If !Gui2 {
	Gui, 2: +LastFound  -MinimizeBox
	Gui, 2: Show, w440 h95,CAUTION:
	Gui, 2: Color, Black
	Gui, 2: Add, Text, x50 y20 Center BackgroundTrans cRed, These CrossHairs WILL NOT Save Properly. USE WITH CAUTION!
	 Symbols := ["🥚", "👌", "❤️", "💀", "☠️", "❄️", "🦄", "👻", "☺", "○", "◊", "◎", "⚔", "☢", "⚙", "✜", "✠", "✣", "✜", "☭"]
	 xOffset := 0
	 For each, Bunttons in Symbols {
	 Gui, 2: Add, Button, x%xOffset% y50 w22 h40 gSelectCrosshair, %Bunttons%
	 xOffset += 22
	 }
	Gui2 := true
	} Else {
		Gosub Close2
}
return

CrossHairTrans1:
GuiControlGet, CrossHairTrans, , CrossHairTrans
WinSet, TransColor, 00FF00 %CrossHairTrans%, ahk_id %CrossHairHWND%
Return

SelectCrosshair:
If (CrosshairT) {
    SelectedCrosshair := A_GuiControl
    GuiControl,,SelectedCrosshair, %SelectedCrosshair%
	GoSub CreateCrossHair
	}
return

UpdateCrossHair:
GuiControlGet, CrossHairColor
GuiControlGet, CrossHairSize
Gui, CrossHair:Font, c%CrossHairColor% s%CrossHairSize% q4
Return
~+Up::
~+Down::
~+WheelUp::
~+WheelDown::
If (Magnifier) {
    If (zoom < 31 and ( A_ThisHotKey = "~+WheelUp" or A_ThisHotKey = "~+Up" )) {
        zoom *= 1.189207115      ; sqrt(sqrt(2))
        Zx := Rx/zoom
        Zy := Ry/zoom
        if (zoom > 31) {
            zoom := 31
            Zx := Rx/zoom
            Zy := Ry/zoom
        }
    }
    If (zoom > 1 and ( A_ThisHotKey = "~+WheelDown" or A_ThisHotKey = "~+Down" )) {
        zoom /= 1.189207115 
        Zx := Rx/zoom
        Zy := Ry/zoom
        If (zoom < Zoomtemp) {
            zoom := Zoomtemp
            Zx := Rx/zoom
            Zy := Ry/zoom
        }
    }
    If (zoom > ZoomTemp) {
        ShowToolTip(" Zoom = " Round(100*zoom) "%", , 70, 3, 3)
    } Else {
        ShowToolTip("", 0, 70, 3)
    }
}
Return

ZoomIN:
ZoomINColor:= % (Magnifier ? "Green" : "0xCB0000")
GuiControl, +c%ZoomINColor%, Magnifying Glass
If (Magnifier) {
	GoSub CreateZoomIN
	Menu, Tray, Check, Toggle Magnifier
} else {
	GoSub DestroyZoomin
	Menu, Tray, Uncheck, Toggle Magnifier
}
Return

MagnifierToggler:
Magnifier:=!Magnifier
Gosub Zoomin
Return

CreateZoomIN:
hwnd := WinExist("A")
ZoomTemp := zoom
Rx := Size
Ry := Size
Zx := Rx / zoom, ZX_Temp := ZX
Zy := Ry / zoom, ZY_Temp := ZY
AW := ((A_ScreenWidth // 2) - Rx)-1
AH := ((A_ScreenHeight // 2) + Ry)+1 
Gui, MagnifierGUI: +AlwaysOnTop +ToolWindow -Caption -dpiscale +E0x20
Gui, MagnifierGUI:Show, % "w" . 2*Rx . " h" . 2*Ry . " x" . AW . " y" . AH , Magnifier
WinGet, MagnifierID, ID, Magnifier
hMask := DllCall("gdi32.dll\CreateEllipticRgn", Int, 0, Int, 0, Int, 2 * Rx, Int, 2 * Ry)
DllCall("user32.dll\SetWindowRgn", UInt, MagnifierID, UInt, hMask, Int, true)
WinSet, Transparent, %MagnifierTrans%, ahk_id %MagnifierID% ; Set full transparency
SetTimer, Repaint, %Delay%
Magnifier := True
WinActivate, ahk_id %hwnd%
return

ZoomDelete:
	DllCall("gdi32.dll\DeleteObject", UInt, hMask)
    DllCall("gdi32.dll\DeleteDC", UInt, hdc_frame)
    DllCall("gdi32.dll\DeleteDC", UInt, hdd_frame)
return

Repaint:
if (Magnifier) {
 	xz := In(center_x-Zx, 0, A_ScreenWidth-2*Zx) ; Frame X
	yz := In(center_y-Zy, 0, A_ScreenHeight-2*Zy) ; Frame Y
    hdd_frame := DllCall("GetDC", UInt, PrintSourceID)
    hdc_frame := DllCall("GetDC", UInt, MagnifierID)
	DllCall("gdi32.dll\StretchBlt", UInt,hdc_frame, Int,0, Int,0, Int,2*Rx, Int,2*Ry
   , UInt,hdd_frame, UInt,xz, UInt,yz, Int,2*Zx, Int,2*Zy, UInt,0xCC0020) ; SRCCOPY
  ; DllCall( "gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )  ; Antializing ?
    Gosub ZoomDelete
    }
Return

DestroyZoomin:
	Gosub ZoomDelete
    Gui, MagnifierGUI:Destroy
    SetTimer, Repaint, Off
    Magnifier := false
return

MagnifierTrans1:
GuiControlGet, Magnifier, , Magnifier
WinSet, TransColor, 00FF00 %MagnifierTrans%, ahk_id %MagnifierID%
Return

In(x,a,b) {                      ; closest number to x in [a,b]
   IfLess x, %a%, Return a
   IfLess b, %x%, Return b
   Return x
}

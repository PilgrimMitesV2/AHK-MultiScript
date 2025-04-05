toggle_key = c
sleep_time = 20
show_status = 1 ; 1=yes 0=no (Fulscreenwindowed only!)
;######################################## - Status Options
status_x = 290
status_y = 8
status_size = 16 ; Font size
status_text = AutoStrafe ; Displayed Text
status_font =  ; Leave blank for default
;######################################## - Code
#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#MaxThreadsPerHotkey 255
#KeyHistory 0
SetWorkingDir %A_ScriptDir%
SendMode Input
screenmid := A_ScreenWidth / 2
drawString(status_x, status_y, status_text, 0xff0000, status_size, "", 880000)
Hotkey, ~$*%toggle_key%, toggle_as
toggle = 0
return

toggle_as:
if(toggle==1)
{
	toggle = 0
	Send, {d up}
	Send, {a up}
	if(show_status == 1)
	{
		drawString(status_x, status_y, status_text, 0xff0000, status_size, "", 880000)
	}
}
else
{
	toggle = 1
	if(show_status == 1)
	{
		drawString(status_x, status_y, status_text, 0x00ff00, status_size, "", 008800)
	}
}
return

~$*Space::
while(GetKeyState("Space", "p"))
{
	if(toggle == 0)
	{
		break
	}
	
	MouseGetPos, x
	if (x>screenmid)
	{
		Send {Blind}{a Up}
		Send {Blind}{d Down}
	}
	else if (x<screenmid)
	{
		Send {Blind}{d Up}
		Send {Blind}{a Down}
	}
	else if (x==screenmid)
	{
		Send {Blind}{d Up}
		Send {Blind}{a Down}
	}
	
	Sleep, %sleep_time%
	SetKeyDelay 10
}
Send {Blind}{d Up}
Send {Blind}{a Up}
return

drawString(x, y, string, color, size, Font, background)
{
    Gui, 2:destroy
    Gui, 2: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop +E0x20
    Gui, 2:Color, c%background%
    Gui, 2:Font, s%size% q1 c%color%, %Font%
    gui, 2:margin,, 0
    gui, 2:add, text,, %string%
    Gui, 2:Show, y%Y% x%X% NoActivate, ch
    WinSet, TransColor, c%background% 255
}
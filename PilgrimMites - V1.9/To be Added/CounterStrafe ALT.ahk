CounterStrafeT := 1 

~*w up::
If CounterStrafeT = 1 
{
    if(GetKeyState("s","P")) ; If "w" is pressed, do not perform substitution
        return
    start := A_TickCount
    start += 125
    Send {s down}
    While (!GetKeyState("s","P") && A_TickCount < start) ; If "w" is pressed, exit this While loop. Exit after 100 ms regardless
        Sleep 10
    If !GetKeyState("s","P") ; If you are holding "w" down physically, you don't want to send a "w" up keystroke
        Send {s up}
}
return

~*a up::
If CounterStrafeT = 1
{
    if(GetKeyState("d","P")) ; If "a" is pressed, do not perform substitution
        return
    start := A_TickCount
    start += 125
    Send {d down}
    While (!GetKeyState("d","P") && A_TickCount < start) ; If "a" is pressed, exit this While loop. Exit after 100 ms regardless
        Sleep 10
    If !GetKeyState("d","P") ; If you are holding "a" down physically, you don't want to send an "a" up keystroke
        Send {d up}
}
return

~*d up::
If CounterStrafeT = 1
{
    if(GetKeyState("a","P")) ; If "d" is pressed, do not perform substitution
        return
    start := A_TickCount
    start += 125
    Send {a down}
    While (!GetKeyState("a","P") && A_TickCount < start) ; If "d" is pressed, exit this While loop. Exit after 100 ms regardless
        Sleep 10
    If !GetKeyState("a","P") ; If you are holding "d" down physically, you don't want to send a "d" up keystroke
        Send {a up}
}
return

~*s up::
If CounterStrafeT = 1
{
    if(GetKeyState("w","P")) ; If "s" is pressed, do not perform substitution
        return
    start := A_TickCount
    start += 125
    Send {w down}
    While (!GetKeyState("w","P") && A_TickCount < start) ; If "s" is pressed, exit this While loop. Exit after 100 ms regardless
        Sleep 10
    If !GetKeyState("w","P") ; If you are holding "s" down physically, you don't want to send a "s" up keystroke
        Send {w up}	
}
return


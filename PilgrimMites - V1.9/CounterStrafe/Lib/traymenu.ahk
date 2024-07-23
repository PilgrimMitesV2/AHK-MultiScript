Menu, Tray, NoMainWindow
Menu, Tray, noStandard
Menu, Tray, add, Edit This Script	, TrayEdit
Menu, Tray, add, Reload This Script	, TrayReload
Menu, Tray, add, 
Menu, Tray, add, Suspend Hotkeys	, TraySuspend
Menu, Tray, add, Pause Script		, TrayPause
Menu, Tray, add, Exit				, TrayExit
Menu, Tray, add,
Menu, Tray, add, Open Script Location, TrayOpenLoc

Menu, Tray, default, Edit This Script

Gosub TrayMenuEnd 

return

;-------------------------------------------------------------------------------
;	Labels
;-------------------------------------------------------------------------------

; TrayOpen:
; 	listLines
; 	return
	
; TrayHelp:
; 	splitpath, a_ahkPath, , ahk_dir
; 	run, % ahk_dir "\AutoHotkey.chm"
; 	return
	
; TrayWindowSpy:
; 	splitpath, a_ahkPath, , ahk_dir
; 	run, % ahk_dir "\AU3_Spy.exe"
; 	return

TrayReload:
	reload
	sleep 1000
	msgBox, 4, , The script could not be reloaded and will need to be manually restarted. Would you like Exit?
	ifMsgBox, yes, exitApp
	return

TrayEdit:
	run, edit %a_scriptFullPath%
	return
	
TraySuspend:
	suspend toggle
	if (a_isSuspended = 1)
		 menu, tray, check  , Suspend Hotkeys
	else menu, tray, unCheck, Suspend Hotkeys
	return
	
TrayPause:
	if (a_isPaused = 1)
	{
		pause off
		menu, tray, unCheck, Pause Script
	}
	else
	{
		menu, tray, check, Pause Script
		pause on
	}
	return
	
TrayExit:
	exitApp

TrayOpenLoc:
    run % A_ScriptDir
    return

TrayMenuEnd:
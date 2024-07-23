;===============================================================================
	app_name := "VAL Counterstrafe (Right)"
	Menu, Tray, Tip, % app_name . (current_version ? " v" . current_version : "")
;===============================================================================

;		______              ____________________________________________
;		___  /______  __    __  ___/_|__  /_  __ \__  __ \_  ___/_|__  /
;		__  __ \_  / / /    _  __ \___/_ <_  / / /_  /_/ /  __ \___/_ <
;		_  /_/ /  /_/ /     / /_/ /____/ // /_/ /_  _, _// /_/ /____/ /
;		/_.___/_\__, /      \____/ /____/ \____/ /_/ |_| \____/ /____/
;		       /____/

;-------------------------------------------------------------------------------
;	GENERAL SETTINGS
;-------------------------------------------------------------------------------

#Include <default_Settings>

#Include <counterstrafe>

#Include <traymenu>

#MaxThreadsPerHotkey 100

GroupAdd, source, ahk_exe VALORANT.exe



;-------------------------------------------------------------------------------
;	PREFERENCES
;-------------------------------------------------------------------------------

move_forward 	:= "vk57" 	; w
move_back 		:= "vk53" 	; s
move_left 		:= "vk41" 	; a
move_right 		:= "vk44" 	; d
jump 			:= "vk20" 	; space

enable_counter := 1

;-------------------------------------------------------------------------------
;	MAPPING HOTKEYS
;-------------------------------------------------------------------------------

Hotkey, ~$%move_forward% up, move_forward_up
Hotkey, ~$%move_back% up, move_back_up
Hotkey, ~$%move_left% up, move_left_up
Hotkey, ~$%move_right% up, move_right_up

Hotkey, ~$%move_forward%, move_forward_down
Hotkey, ~$%move_back%, move_back_down
Hotkey, ~$%move_left%, move_left_down
Hotkey, ~$%move_right%, move_right_down

Hotkey, ~$%jump%, jump


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;	END OF AUTO-EXECUTE SECTION
	return
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;-------------------------------------------------------------------------------
;	Hotkey labels
;-------------------------------------------------------------------------------

jump:
	hop := 1
	SetTimer, jumpoff, off
	SetTimer, jumpoff, -1200
	Return

jumpoff:
	hop := 0
	Return

do_enable_counter:
	if GetKeyState(move_forward, "P")
	or if GetKeyState(move_back, "P")
	or if GetKeyState(move_left, "P")
	or if GetKeyState(move_right, "P")
		enable_counter := 1
	Return

move_forward_down:
	SetTimer, do_enable_counter, -500
	Return

move_back_down:
	SetTimer, do_enable_counter, -500
	Return

move_left_down:
	SetTimer, do_enable_counter, -500
	Return

move_right_down:
	SetTimer, do_enable_counter, -500
	if(moving_right != 1)
		start_moving_right := A_TickCount
	moving_right := 1
	Return

move_forward_up:
	last_moving_forward := 1
	SetTimer, move_forward_off, off
	SetTimer, move_forward_off, -300
	return

move_forward_off:
	last_moving_forward := 0
	return

move_back_up:
	last_moving_back := 1
	SetTimer, move_back_off, off
	SetTimer, move_back_off, -300
	return

move_back_off:
	last_moving_back := 0
	return

move_left_up:
	last_moving_left := 1
	SetTimer, move_left_off, off
	SetTimer, move_left_off, -300
	return

move_left_off:
	last_moving_left := 0
	return

move_right_up:
	moving_right := 0
	if(last_moving_left != 1)
		counterstrafe(move_right, move_left, start_moving_right)
	return

#NoEnv
#SingleInstance, force
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines, Off
Process, Priority, , H
SetBatchLines, -1
SetWinDelay, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetControlDelay, -1
SetDefaultMouseSpeed, 0
SendMode, Input

SetWorkingDir %A_ScriptDir%
ScriptName := A_ScriptName
StringReplace, ScriptName, ScriptName, .ahk, , All
StringReplace, ScriptName, ScriptName, .exe, , All

IfExist, %ScriptName%.ico
	Menu, Tray, Icon, %ScriptName%.ico, , 1
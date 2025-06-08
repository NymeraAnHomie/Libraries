#NoEnv
SendMode Input
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

Gui, Add, Text,, Tasability AHK is running...
Gui, Add, Button, gExitScript w200, Exit AHK Playback
Gui, Show,, Tasability AHK Input Player

filePath := "Tasability\PC\AHK\request.txt"
lastKeys := {}

SetTimer, ReadInputs, 10
return

ReadInputs:
	FileRead, rawInput, %filePath%
	StringReplace, rawInput, rawInput, `r`n,, All
	StringReplace, rawInput, rawInput, `n,, All

	keys := StrSplit(rawInput, ",")
	currentKeys := []

	for i, k in lastKeys {
		if !IsInArray(k, keys) {
			Send, {%k% up}
		}
	}

	for i, k in keys {
		if (k != "") {
			Send, {%k% down}
			currentKeys.Push(k)
		}
	}

	lastKeys := currentKeys
	ToolTip, %rawInput%
return

ExitScript:
	SetTimer, ReadInputs, Off
	for i, k in lastKeys {
		Send, {%k% up}
	}
	ExitApp
return

IsInArray(val, arr) {
	for index, element in arr {
		if (element = val)
			return true
	}
	return false
}

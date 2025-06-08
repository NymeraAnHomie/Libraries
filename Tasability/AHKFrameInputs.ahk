SendMode Input
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

Gui, Add, Button, gExitScript w200, Exit AHK Playback
Gui, Show,, AHK Input Tester

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
			if (k = "LeftShift" or k = "RightShift") {
				k := "Shift"
			} else if (k = "Space") {
				k := "Space"
			} else {
				k := StrUpper(k)
			}
			Send, {%k% down}
			ToolTip, Sending: %k%
			currentKeys.Push(k)
		}
	}

	lastKeys := currentKeys
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

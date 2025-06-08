#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

filePath := "Tasability\PC\AHK\request.txt"
lastKeys := {}
tickInterval := 33

Gui, Add, Text,, Interval (ms):
Gui, Add, Edit, vIntervalBox w100, 33
Gui, Add, Button, gApplyInterval w80, Apply
Gui, Add, Button, gExitScript w200, Exit Tasability AHK
Gui, Show,, Tasability AHK Input Player

SetTimer, ReadInputs, %tickInterval%
return

ReadInputs:
	FileRead, rawInput, %filePath%
	StringTrimRight, rawInput, rawInput, 0
	StringReplace, rawInput, rawInput, `r`n,, All
	StringReplace, rawInput, rawInput, `n,, All
	keys := StrSplit(rawInput, ",")

	for i, k in lastKeys {
		if !IsInArray(k, keys) {
			Send, {%k% up}
		}
	}

	for i, k in keys {
		if (k != "") {
			Send, {%k% down}
		}
	}

	lastKeys := keys
return

ApplyInterval:
	GuiControlGet, newVal,, IntervalBox
	if (newVal is digit) && (newVal >= 5) {
		tickInterval := newVal
		SetTimer, ReadInputs, Off
		SetTimer, ReadInputs, %tickInterval%
	}
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
#NoEnv
SendMode Input
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

Gui, Add, Button, gExitScript w200, Exit AHK Playback
Gui, Show,, AHK Input Tester

filePath := "Tasability\PC\AHK\request.txt"
lastKeys := []

SetTimer, ReadInputs, 10
return

ReadInputs:
	FileRead, rawInput, %filePath%
	StringReplace, rawInput, rawInput, `r`n,, All
	StringReplace, rawInput, rawInput, `n,, All

	keys := StrSplit(rawInput, ",")
	currentKeys := []

	Loop % lastKeys.MaxIndex()
	{
		k := lastKeys[A_Index]
		if !IsInArray(k, keys) {
			Send, {%k% up}
		}
	}

	Loop % keys.MaxIndex()
	{
		k := keys[A_Index]
		if (k != "") {
			if (k = "LeftShift" or k = "RightShift") {
				k := "Shift"
			} else if (k = "Space") {
				k := "Space"
			} else {
				StringUpper, k, k
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
	Loop % lastKeys.MaxIndex()
	{
		k := lastKeys[A_Index]
		Send, {%k% up}
	}
	ExitApp
return

IsInArray(val, arr) {
	Loop % arr.MaxIndex()
	{
		if (arr[A_Index] = val)
			return true
	}
	return false
}

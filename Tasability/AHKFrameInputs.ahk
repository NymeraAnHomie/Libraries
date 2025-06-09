#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Gui, Add, Text,, TAS AHK is running...
Gui, Add, Button, gExitScript w200, Exit AHK Playback
Gui, Show,, Tasability AHK Player

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
		if !IsInArray(k, keys) and k != "WheelUp" and k != "WheelDown" {
			key := MapKey(k)
			if (key != "") {
				if (key = "LButton" or key = "RButton" or key = "MButton" or key = "XButton1" or key = "XButton2") {
					Click, up %key%
				} else {
					Send, {%key% up}
				}
			}
		}
	}

	Loop % keys.MaxIndex()
	{
		k := keys[A_Index]
		if (k != "") {
			key := MapKey(k)
			if (key = "WheelUp" or key = "WheelDown") {
				Send, {%key%}
			} else if (key = "LButton" or key = "RButton" or key = "MButton" or key = "XButton1" or key = "XButton2") {
				Click, down %key%
				currentKeys.Push(key)
			} else {
				Send, {%key% down}
				currentKeys.Push(key)
			}
		}
	}

	lastKeys := currentKeys
	ToolTip, %rawInput%
return

ExitScript:
	SetTimer, ReadInputs, Off
	Loop % lastKeys.MaxIndex()
	{
		k := lastKeys[A_Index]
		key := MapKey(k)
		if (key = "LButton" or key = "RButton" or key = "MButton" or key = "XButton1" or key = "XButton2") {
			Click, up %key%
		} else {
			Send, {%key% up}
		}
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

MapKey(k) {
	if (k = "MB1")
		return "LButton"
	if (k = "MB2")
		return "RButton"
	if (k = "MB3")
		return "MButton"
	if (k = "MB4")
		return "XButton1"
	if (k = "MB5")
		return "XButton2"
	if (k = "ScrollUp")
		return "WheelUp"
	if (k = "ScrollDown")
		return "WheelDown"
	StringUpper, k, k
	return k
}

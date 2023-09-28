﻿/* StringyLauncher
Version: 3
Last time modified: 2014.09.20 14:53

This script is a launcher. It requires you to first create a "rules.ini" file with the rules for this launcher.
The syntax for this file is the following:
0. You'd better set codepage to 65001 (UTF-8).
1. Each rule should be on it's own line.
2. Each rule consists of keyword(s) + path. All of them should be separated with pipes.
3. To bring support of launching files directly from archives:
	a. You should bind a keyword "archiver" to your archiver: currently, the script supports only 7-Zip (specify path to 7z.exe) and WinRar (specify path to WinRAR.exe, UnRAR.exe or RAR.exe).
	b. The syntax for such rules is the following: say, you need to launch "\archived_folder\with\test.exe" from "arch.rar", then the rule should be so: "keyword`|C:\path\to\arch.rar!archived_folder\with\test.exe".

Notes:
1. Currently the launching is limited to one place: all triggers work only if they were typed to "Win+R" or "Start>Run" (or "Пуск>Выполнить" in Windows with "ru" locale). To remove this limit you need to delete line "#IfWinActive, ahk_exe explorer.exe ahk_class #32770" but then you should consider adding some closing char to your keywords, otherwise the launcher will work out right after you finished typing a keyword.
2. You may specify a temporary folder to which archives will get unpacked to. And you also may specify not to remove the unpacked files after you closed the launched program that was in an archive.

Script author: Drugoy a.k.a. Drugmix
Contacts: idrugoy@gmail.com, drug0y@ya.ru
https://github.com/Drugoy/Autohotkey-scripts-.ahk/tree/master/StringyLauncher/StringyLauncher.ahk
*/

;{ Directives
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force
; #Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir, %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Include Hotstring.ahk	; Not needed if the lib put to the "%AutoHotkey%/Lib" folder.
#MaxThreadsPerHotkey, 20
;}

;{ Settings
Global extractTo := A_Temp "\executor"	; Path where to extract archives' contents to.
Global deleteUnpackedUponExit := 1	; 1 - remove files after the closing a launched program within from archive. 0 - leave them.
verbose := 1	; 1 - display a traytip (with basic info) when a trigger works out. 0 - do not use traytips.
;}

;{ Startup routine
launcherArray := {}
FileRead, rules, %A_ScriptDir%\rules.ini	; This file's contents consist of lines that each consists of two parts separated with a pipe. Left part is the hotstring trigger text and the right part is the full path.
Loop, Parse, rules, `n, `r
{
	If (A_LoopField)	; A safe check against empty lines.
	{
		tmp := StrSplit(A_LoopField, "|")
		Loop, % tmp.MaxIndex() - 1	; Each rule consists of N keywords + 1 trigger. N = tmp.MaxIndex() - 1.
		{
			If (tmp[A_Index] == "archiver")	; If the leftmost  part of a line is "archiver".
			{
				Global archiver := tmp[tmp.MaxIndex()]	; Then store the path from the right part of that line into a variable 'archiver' that will later be used for reaching files inside of archives.
				Continue
			}
			launcherArray.Insert(tmp[A_Index], tmp[tmp.MaxIndex()])
			Hotstring(tmp[A_Index], "subRoutine")
		}
	}
}
Return
;}

;{ Label and a help` hotstring
#IfWinActive, ahk_exe explorer.exe ahk_class #32770
subRoutine:
	If (verbose)	; Show traytips only if the setting says so.
		TrayTip, % A_ScriptName, % "keyword: " $ "`n" "Launching: " launcherArray[$], 5, 1
	launch(launcherArray[$])
Return

:*:help``::
	ControlGetFocus, activeControl, A
	If (activeControl == "Edit1")	; Win+R window: "Execute" (or "Выполнить" in Ru OS locale).
		WinClose
	MsgBox,, % A_ScriptName, % rules
Return

#IfWinActive
;}

;{ Functions
launch(input)
{
	ControlGetFocus, activeControl, A
	If (activeControl == "Edit1")	; Win+R window: "Execute" (or "Выполнить" in Ru OS locale).
	{
		WinClose, A	; Close the "Execute" (or "Выполнить" in Ru OS locale) window.
		IfInString, input, !	; Paths with "!" are the ones pointing to the files inside archives.
; Example path to an executable inside an archive: C:\Test.rar!subfolder\runme.exe
		{
			partialPath := StrSplit(input, "!")	; partialPath[1] contains the path to the archive. partialPath[2] contains the relative path to the executable withing the archive (where root is the archive itself).
			archiveName := SubStr(partialPath[1], InStr(partialPath[1], "\",, 0), InStr(partialPath[1], ".",, 0) - InStr(partialPath[1], "\",, 0))	; Archive's name (without extension) will be used to name the temporary folder where it will get unpacked to.
			If (archiver ~= "Si)^.*\\7z\.exe$")
				RunWait, % """" archiver """ x """ partialPath[1] """ -aoa -y -o""" extractTo archiveName """",, Hide	; Use 7-zip archiver to unpack the files.
			Else If (archiver ~= "Si)^.*\\WinRAR\.exe$") || (archiver ~= "Si)^.*\\UnRAR\.exe$") || (archiver ~= "Si)^.*\\Rar\.exe$")
				RunWait, % """" archiver """ x """ partialPath[1] """ """ extractTo archiveName "\"""	; Use WinRAR archiver to unpack the files.
			Else
			{
				MsgBox, % "Sorry, there was a problem with unpacking an archive.`nYou need to add a rule to rules.ini with trigger ""archive"" that points to an archiver with command line interface.`nCurrently only 7-Zip (7z.exe) and WinRar (WinRAR.exe/UnRAR.exe/RAR.exe) are supported."
				Return
			}
			runThis := extractTo archiveName "\" partialPath[2]
			If (deleteUnpackedUponExit)	; If user chose to delete unpacked files upon exit of the launched program.
				waitAndRemove(runThis, extractTo archiveName)	; Use a function with RunWait+FileRemoveDir.
			Else
				Run, %runThis%
		}
		Else	; The path points to a file outside archive.
			Run, %input%
	}
}

waitAndRemove(executable, fileRemoveDir)
{
	RunWait, %executable%
	FileRemoveDir, %fileRemoveDir%, 1	; Remove the unpacked stuff after it got closed.
}
;}
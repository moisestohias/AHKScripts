﻿/* Meta Shortcut
Version: 9
Last time modified: 2016.04.25 00:36

Summary: a single file that can store multiple shortcuts and provides access to them via dropdown menu.

Detailed description: the script shows a menu list of shortcuts to the files previously drag'n'dropped onto it.

Usage: at first, user just needs to drag'n'drop any files onto this script's file. The script will create an external *.txt file to store those files' (or folders') paths and their names.
Then, when the user will just execute this script - it will use the data from the *.txt file to create a menu list.
Clicking on any list item in that menu will run/open the corresponding file/folder.

Script author: Drugoy a.k.a. Drugmix
Contacts: idrugoy@gmail.com, drug0y@ya.ru
Script's homepage:
https://github.com/Drugoy/Autohotkey-scripts-.ahk/tree/master/Meta%20Shortcut/Meta%20Shortcut.ahk
*/

#NoEnv
#NoTrayIcon
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

smartLinks := true	; Defines how to handle *.url files when they get drag'n'dropped onto this script's file: true - store the URL from the *.url file (you may delete the file, the link shortcut will still work); false - use the link to the *.url file itself (if the file gets deleted - the link will get broken).
useThisBrowser := ""	; Define here the path to your browser, if you wish to use non-default one for opening http:// and ftp:// urls. For example: "iexplore.exe" will force to use Internet Explorer.

; Here we create var %settingstxt% that contains a name of the txt file (which is equal to the script's name, except it has a *.txt extension).
SplitPath, A_ScriptFullPath,,,, settingstxt
settingstxt .= ".txt"
; And then we check if that file already exists.
IfExist, %settingstxt%	; Nothing to show: settings file doesn't yet exist.
	settingsExist := 1

; This is a check: did user just run the script (to access stored shortcuts), or he drag'n'dropped a file(s) onto script to add the shortcut(s).

If (%0% == 0)	; User wanted to access the already stored shortcuts.
{
	If (settingsExist)	; There is at least one shortcut.
	{
		FileRead, settings, %settingstxt%
		paths := {}	; Initiating an array. We will use it to add bindings between MenuItem and the path to run when it will be selected.
		Loop, Parse, settings, `n, `r
		{
			StringSplit, singleRecordPart, A_LoopField, |	; We will use file names (without it's path) as menu item names. %singleRecordPart1% contains file name.
			Menu, ShortcutsList, Add, %A_Index%. %singleRecordPart1%, LaunchFiles	; Construct menu.
			If (singleRecordPart1 ~= "iS)^.*\.url$")	; Set icon for *.url files and URLs.
				Menu, ShortcutsList, Icon, %A_Index%. %singleRecordPart1%, shell32.dll, 14
			Else If (singleRecordPart1 ~= "iS)^.*\.exe$")	; Set icon for *.exe files.
				Menu, ShortcutsList, Icon, %A_Index%. %singleRecordPart1%, shell32.dll, 3
			Else If (singleRecordPart1 ~= "iS)^.*\\$")
				Menu, ShortcutsList, Icon, %A_Index%. %singleRecordPart1%, shell32.dll, 4
			Else	; Set icons for the rest of files (use icons from user's system).
			{
				thisFileExtension := chopString(singleRecordPart1)
				RegRead, temp, HKCR, .%thisFileExtension%
				RegRead, icoPath, HKCR, %temp%\DefaultIcon
				If !ErrorLevel
				{
					thisIconLibPath := chopString(icoPath, "`,", 1)
					thisIconNumberInLib := chopString(icoPath, "`,")
				}
				Else	; There's no path to the icon stored in the registry (example is .pdf being handled by "SumatraPDF portable")
				{
					RegRead, icoPath, HKCR, %temp%\shell\open\command
					thisIconNumberInLib := 1
				}
				If InStr(thisIconLibPath, """")
					thisIconLibPath := chopString(icoPath, """", 2)	; Might be unreliable. Usually the path is like '"C:\path\to\file.exe" "%1"' or just '"C:\path\to\file.exe"' and it has to be normalized for further use.
				Menu, ShortcutsList, Icon, %A_Index%. %singleRecordPart1%, %thisIconLibPath%, %thisIconNumberInLib%
			}
			paths.Insert(A_Index ". " singleRecordPart1, singleRecordPart2)	; Here we do bindings (using array) so we'll know later what to run.
		}
		Menu, ShortcutsList, Show, %A_GuiX%, %A_GuiY%	; Show the constructed menu.
	}
	Else	; The user has not yet added at least one shortcut.
		Msgbox You wanted to access the already stored shortcuts, but you don't have any settings file with at least one record yet.`nTo create one - just drag'n'drop any file you would like to have a shortcut to onto the this script's file.
}
Else	; User did drag'n'drop at least one file.
	Loop, %0%	; Usually %0% contains the number of command line parameters, but when the user drag'n'drops files onto the script - each of the dropped file gets sent to script as a separate command line parameter, so %0% contains the number of dropped files.
		Loop, % %A_Index%, 1
		{
			; File or folder.
			FileGetAttrib, isFileNotFolder, %A_LoopFileLongPath%
			isFileNotFolder := (InStr(isFileNotFolder, "d") ? 0 : 1)
			If smartLinks && isFileNotFolder && (A_LoopFileName ~= "iS)^.*\.url$")	; If the dropped down file is an *.url - the script will just use the URL it contains, instead of pointing to that *.url file itself.
			{
				IniRead, urlPath, %A_LoopFileName%, InternetShortcut, URL
				If (urlPath == "ERROR")	; Safe check against incorrect URLs.
					MsgBox, % "There was a problem retrieving the URL from the file, so the shortcut to that URL was not saved."
				Else
				{
					FileAppend, % (settingsExist ? "`n" : "") A_LoopFileName "|" urlPath, %settingstxt%
					settingsExist := 1
				}
			}
			Else
				FileAppend, % (settingsExist ? "`n" : "") A_LoopFileName (isFileNotFolder ? "" : "\") "|" A_LoopFileLongPath, %settingstxt%
		}
ExitApp

;{ Label to open selected file (or URL).
LaunchFiles:
	Run, % ((chopString(paths[A_ThisMenuItem], ":", 1) ~= "https?|ftp") ? (useThisBrowser ? useThisBrowser " " : "") : "") """" paths[A_ThisMenuItem] """"	; Since we used arrays - we know what the selected MenuItem is bound to. So we just run the path bound to the selected MenuItem.
Return
;}

;{ Function to get file's extension.
chopString(string, delimiter = ".", nthPart = 0)
{
; Input: string - input string to work with; delimiter - delimiter (remember to escape special symbols, if needed); nthPart: false - returns last part, else - returns the specified Nth part; removeDelimiter: true - removes the delimiter from the results, false - leaves it.
; Output: part of the input string.
	StringSplit, section, string, %delimiter%
	Return ((nthPart) ? (section%nthPart%) : (section%section0%))
}
;}
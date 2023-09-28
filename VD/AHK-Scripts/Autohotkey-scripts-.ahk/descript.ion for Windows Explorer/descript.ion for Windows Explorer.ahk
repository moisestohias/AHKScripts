﻿/* descript.ion for Windows Explorer v0.5
Last time modified: 2016.02.08 04:35

Summary: this script let's you get files' comments.

Description: if any files are selected - the comments will be shown only for them, otherwise - for all files in the folder.
Comments get taken from the descript.ion file that should be present in the folder.

Usage:
1. Select a file in Windows Explorer and hit Alt+F1 to set descriptions for files.
2. Select a file in Windows Explorer and hit F1 to show descriptions for the files. If none are selected - the whole folder will get scanned for files that have description.

Script author: Drugoy a.k.a. Drugmix
Contacts: idrugoy@gmail.com, drug0y@ya.ru
https://github.com/Drugoy/Autohotkey-scripts-.ahk/tree/master/descript.ion%20for%20Windows%20Explorer
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode, Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
CoordMode, Mouse, Screen
#MaxThreadsPerHotkey, 1

Global dFiles

#IfWinActive, ahk_exe explorer.exe
F1::
	htmlBody := "", currentFolderPath := Explorer_GetFolder()
	dFiles := getDescription(currentFolderPath, Explorer_GetSelectedFileNames())
	For k, v In dFiles
	{
		found := FileExist(currentFolderPath "\" k)
		htmlBody .= (A_Index == 1 ? "" : "`n") "`n`t`t<b class=""name" (found ? "" : " notfound") """>`n`t`t`t" k "`n`t`t</b>`n`t`t<div class=""description" (found ? "" : " notfound") """>`n`t`t`t" v "`n`t`t</div>"
		StringReplace, htmlBody, htmlBody, \n, `n`t`t`t<br>`n`t`t`t, All	; '\n' represents new lines, so converting them back.
	}
	htmlBody := RegExReplace(htmlBody, "Si)((https?://)([^\s/]+)\S*)", "<a href=""$1"">$2$3/…</a>")
	If htmlBody
	{
htmlPage =
(
<!DOCTYPE html>
<html>
	<head>
		<style>
			html, body
			{
				margin: 0;
				padding: 0;
				width: 100`%;
			}
			html
			{
				overflow: auto;
				height: 100`%;
				background-color: #DCE1E5;
			}
			body
			{
				width: auto;
				font-family: Sans-Serif;
				font-size: 10pt;
				border: 1px solid black;
			}
			.description
			{
				background-color: white;
				border: 1px solid #A9B8C2;
			}
			.notfound
			{
				color: red;
			}
			a:hover:after
			{
				content: ' > ' attr(href);
			}
		</style>
	</head>
	<body>%htmlBody%
	</body>
</html>
)
		Gui, New, +LastFound -Caption +AlwaysOnTop +ToolWindow
		Gui, Color, 123456
		WinSet, TransColor, 123456
		Gui, Margin, 0, 0
		; Gui, Add, Button, gOpenDescription, Open descript.ion
		Gui, Add, ActiveX, vWB w600 h800 x0 y+0, mshtml:<meta http-equiv="X-UA-Compatible" content="IE=Edge">
		Gui, Add, Button, x+0 gOpenIon, .ion
		Gui, Add, Button, y+0 gClear, Clear
		ControlFocus, AtlAxWin1	; Otherwise the html element will not be scrollable until clicked.
		WB.Write(htmlPage)
		WB.Close()
		Gui, Show, % "h" (WB.body.offsetHeight < 800 ? "" WB.body.offsetHeight : "800")
		KeyWait, %A_ThisHotkey%
		Gui, Destroy
	}
	KeyWait, %A_ThisHotkey%
Return

!F1::	; Edit
	dFiles := name := description := slctdName := slctdDesc := ""
	selected := Explorer_GetSelectedFileNames()
	If (selected.Length() == 1)	; Make it work only if 1 file was selected.
	{
		currentFolderPath := Explorer_GetFolder()
		dFiles := getDescription(currentFolderPath)
		For k, v In dFiles
		{
			If (k == selected[1])
			{
				slctdName := k, slctdDesc := v
				StringReplace, slctdDesc, slctdDesc, \n, `n, All	; '\n' represent new lines, so converting them back.
				Break
			}
		}
		Gui, New, +LastFound +Border
		; Gui, Color, 123456
		; WinSet, TransColor, 123456
		Gui, Margin, 1, 1
		Gui, Add, Edit, +ReadOnly vname, % (slctdName ? slctdName : selected[1])
		Gui, Add, Edit, Wrap y+0 w600 h400 +Multi vdescription, % slctdDesc
		Gui, Add, Button, y+0 x547 gSave, Save
		ControlFocus, Edit2
		Gui, Show
	}
Return
#IfWinActive

Save:
	Gui, Submit
	If (slctdName == name || !slctdName) && (description == slctdDesc)
		Return
	If (description)	; User saved a non-blank description.
		StringReplace, description, description, `n, \n, All
	setDescription(currentFolderPath, name, description)
Return

OpenIon:
	IfExist, %currentFolderPath%\descript.ion
		Run, %currentFolderPath%\descript.ion
Return

Clear:
	dead := grep(htmlBody, "Sim`a)name notfound"">\s++(.+?)$")
	For k, v In dFiles
	{
		For a, b In dead
			If (k == b)
				dFiles.Delete(k)
	}
	writeModified(currentFolderPath)
	Gui, Destroy
	GoSub, F1
Return

GuiClose:
GuiEscape:
	Gui, Destroy
Return

;{ Functions
	;{ Explorer_GetFolder()
Explorer_GetFolder()
{
	If !(window := Explorer_GetWindow())
		Return ErrorLevel := "ERROR"
	If (window = "desktop")
		Return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All 
	While RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
		StringReplace, path, path, `%%hex%, % Chr("0x" hex), All
	Return path
}
	;}
	;{ Explorer_GetWindow()
Explorer_GetWindow()
{
	WinGet, process, processName, % "ahk_id " hwnd := WinExist("A")
	WinGetClass, class, A
	If (process != "explorer.exe")
		Return ErrorLevel := "ERROR"
	If (class ~= "(Cabinet|Explore)WClass")
	{
		For window In ComObjCreate("Shell.Application").Windows
			If (window.hwnd == hwnd)
				Return window
	}
	Else If (class ~= "Progman|WorkerW") 
		Return "desktop" ; desktop found
}
	;}
	;{ Explorer_GetFileNames(forceAll = 0)	- returns selected (or all, if none were selected) files' names.
Explorer_GetSelectedFileNames()
{
	fileNames := []
	If !(window := Explorer_GetWindow())
		Return ErrorLevel := "ERROR"
	If (window = "desktop")
	{
		ControlGet, activeWinHWND, HWND,, SysListView321, ahk_class Progman
		If !activeWinHWND ; #D mode
			ControlGet, activeWinHWND, HWND,, SysListView321, A
		ControlGet, selectedFiles, List, % "Selected" "Col1",, ahk_id %activeWinHWND%
		folder := SubStr(A_Desktop, 0, 1) == "\" ? SubStr(A_Desktop, 1, -1) : A_Desktop
		Loop, Parse, selectedFiles, `n, `r
		{
			path := folder "\" A_LoopField
			IfExist %path% ; ignore special icons like Computer (at least for now)	; FIXME: fails on "*.lnk" files.
				fileNames.Insert(A_LoopField)
		}
	}
	Else
	{
		items := window.document.SelectedItems
		For item In items	; https://msdn.microsoft.com/en-us/library/ms970456.aspx
			fileNames.Insert(item.name)
	}
	Return fileNames
}
	;}
	;{ getDescription(folder, filesFilter = 0)	- returns an associative array with files as items, each item is an associative array of file name and file description.
getDescription(folder, filesFilter = "")
{
	describedFiles := {}
	IfExist, % folder "\descript.ion"
	{
		FileEncoding, cp1251
		FileRead, ionContentents, % folder "\descript.ion"
		If ionContentents
		{
			Loop, Parse, ionContentents, `n, `r
			{
				
				If !(A_LoopField)	; Skip empty lines (like the last one).
					Continue
				partname := part1 := part2 := part3 := ""
				RegExMatch(A_LoopField, "JSi)^(?:""(?P<name>.+)""|(?P<name>\S+?))\s(.*)$", part)
				StringReplace, part3, part3, В,, All	; 'В' is usually at the end of the line if description contained at least one '\n'.
				If filesFilter[1]
				{
					For k, v In filesFilter
						If (v == partname)	; Get description only of the files we need (of selected (if exist) or otherwise of all.)
							describedFiles[partname] := part3
				}
				Else
					describedFiles[partname] := part3
			}
			Return describedFiles
		}
	}
}
	;}
	;{ setDescription(folder, name, description)
setDescription(folder, name, description)
{
	For k, v In dFiles
	{
		If (k == name)	; k or v.name
		{
			descriptionExisted := 1
			If (description)
				dFiles[k] := description
			Else
				dFiles.Delete(k)
			Break
		}
	}
	For k, v In dFiles
		dFilesLength++
	If (description) && !(descriptionExisted)	; input description is not empty, while the descript.ion either lacks the corresponding description yet or doesn't yet exist.
	{
		writeMe := (InStr(name, " ") ? """" name """" : name) "`t" description (InStr(description, "\n") ? "В`n" : "`n")
		FileAppend, % writeMe, % folder "\descript.ion"	;, UTF-8
		FileSetAttrib, +H, % folder "\descript.ion"
	}
	Else If !(description) && (descriptionExisted) && !(dFilesLength)
		FileDelete, % folder "\descript.ion"
	Else If (descriptionExisted)	; Modify
		writeModified(folder)
}
	;}
	;{
writeModified(folder)
{
	For k, v In dFiles
		writeMe .= (InStr(k, " ") ? """" k """" : k) "`t" v (InStr(v, "\n") ? "В`n" : "`n")
	FileDelete, % folder "\descript.ion"
	FileAppend, % writeMe, % folder "\descript.ion"	;, UTF-8
	FileSetAttrib, +H, % folder "\descript.ion"
	;{ Fails
	; ion := FileOpen(folder "\descript.ion", "rw")
	; ion.Write(writeMe)
	; ion.Close()
	;}
}
	;}
	;{ grep()
grep(haystack, needle)
{
   output := []
   While (pos := RegExMatch(haystack, needle, match, (pos >= 1 ? pos : 1) + StrLen(match)))
      output.Insert(match1)
   Return output
}
	;}
;}
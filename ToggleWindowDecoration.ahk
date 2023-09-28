#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;-Caption
LWIN & LButton::
WinSet, Style, -0xC00000, A
return
;

;+Caption
LWIN & RButton::
WinSet, Style, +0xC00000, A
return
;


; Hide window decoration for all window, -Don't do it-
; WinGet, id, list,,, Program Manager
; Loop, %id%
; {
;     this_id := id%A_Index%
;     WinActivate, ahk_id %this_id%
;     WinGetClass, this_class, ahk_id %this_id%
;     WinGetTitle, this_title, ahk_id %this_id%
;     MsgBox 0x40004,, % "Visiting All Windows`n" a_index  " of " id  _
;     . "`nahk_id " this_id "`nahk_class "  this_class "`ntitlle " this_title "`n`nContinue?"
;     IfMsgBox, NO, break
;    ; WinSet, Style, +0xC00000, A

; }

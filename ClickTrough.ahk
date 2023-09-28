#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
FallThrough = 1

global RegistredWindows = []

^#LButton:: ; ClickThrough
MouseGetPos,,, MouseWin ; Get the ID of the Window under the mouse cursor.
WinGetTitle, WinTitle, ahk_id %MouseWin%
RegistredWindows.Push(WinTitle)
MsgBox, %RegistredWindows%
If InString, WinTitle, RegistredWindows
{
MsgBox, %RegistredWindows%
; if FallThrough = 1
; {
;   MsgBox, %WinTitle%
;   FallThrough = 0
;   WinSet, ExStyle, -0x20, % WinTitle
;   WinSet, Transparent, 255, % WinTitle
;   WinSet, AlwaysOnTop, Off, % WinTitle
;   RegistredWindows.Push(%WinTitle%)
; }
; else
; {
;   FallThrough = 1
;   WinSet, ExStyle, +0x20, % WinTitle
;   WinSet, Transparent, 90, % WinTitle
;   WinSet, AlwaysOnTop, On, % WinTitle
; }
}
return

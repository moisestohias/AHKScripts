#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Sublime style key binding and beyound
#if GetKeyState("LCtrl", "P") ; 'P' for pressed
b & c:: msgbox Hello
; ~a & b:: MsgBox "A and B"
; b:: MsgBox % "world" 
return


; ^!d:: ; toggle window decoration
; MouseGetPos,,, MouseWin ; Get the Window under the mouse cursor.
; WinGet, styl, Style, %MouseWin%
; if (not styl) {
;     WinSet, Style, -0xC00000, A  
;     WinGet, styl, Style, %MouseWin%
;     MsgBox 0xC00000
; }
; else
;     WinSet, Style, +0xC00000, A  
;     WinGet, styl, Style, %MouseWin%
; return

; WinGet, WinDecState, Style, +0xC00000, A
; if %WinDecState% {
;     WinSet, Style, -0xC00000, A
; }
; else {
;     WinSet, Style, +0xC00000, A
; }
; return

; MsgBox, % "%WinDecState%".
; WinMaximize, ahk_id %active_id%
; MsgBox, The active window's ID is "%active_id%".
; WinSet, Style, +0xC00000, A
; return 



; ^!g::
; Send, {ctrl down}{shift down}{end}
; Send, {right}
; Send, {Enter}
; Send, {ctrl down}{v}{ctrl up}
; ; Send, {ctrl k} {ctrl b}
; return 

; #w::
; whish := " I hope you are having a wonderful"
; greet := "Hello, "
; MsgBox % greet "To whom might be reading this" whish 
; ; FormatTime hh,, hh
; ; FormatTime cc,, tt
; ; if cc = "pm"
; ;     if hh > 6
; ;         DayTime := "Eveninig"
; return

; #q::
; whish := "I hope you are having a wonderful"
; MsgBox % whish " To whome might be reading this "  
; return

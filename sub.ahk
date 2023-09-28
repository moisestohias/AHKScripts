#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#s::  ; Ctrl+Alt+s
if WinExist("Sublime-text")
    WinActivate
else
    Run subl
return
; Add one for brave

#b::
run, https://google.com ;
#y::
run, https://youtube.com ; 





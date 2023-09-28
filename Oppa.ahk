#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#t:: ; display the transparency of the window under the cursor
MouseGetPos,,, MouseWin ; Get the Window under the mouse cursor.
WinGet, Transp, Transparent, ahk_id %MouseWin%  ; Transparency of window under the mouse cursor.
MsgBox, The transparency of this window is (%Transp% /100)
return

^#u:: ;  Decrease opacity
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255 
    newtrans := curtrans - 10
    WinSet, Transparent, %newtrans% , A
return

^#i:: ; Increase opacity
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255 
    newtrans := curtrans + 10
    WinSet, Transparent, %newtrans% , A
return

#o:: ; [Win+o] set opacity 25%
    WinSet, Transparent, 220, A
return

^#o:: ; [Ctrl+Win+o] Reset opacity 100%
    WinSet, Transparent, 255, A
    WinSet, Transparent, OFF, A
return

^#c:: ;
  WinSet, ExStyle, +0x20, % WinTitle
return

; ^#c:: ;
;   WinSet, ExStyle, +0x20, % WinTitle
;   WinSet, AlwaysOnTop, On, % WinTitle
;   WinSet, Transparent, 90, % WinTitle
; return

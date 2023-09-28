;Watch the YouTube video in the following link for guidance:
;ENG: https://youtu.be/5-wp9crAnNM
;KOR: https://youtu.be/UBGyaXh3gGY

; /* alternative method for double press only
; ~ESC::
; KeyWait, ESC, U
; KeyWait, ESC, D T0.2
; If !ErrorLevel
;     Msgbox ESC Double Pressed!
; return

; ~Space::
;     if (A_PriorHotkey <> "~Space" or A_TimeSincePriorHotkey > 200)
;         return
;     Msgbox Space Double Pressed!
; return
; /*

#SingleInstance,Force

^!ENTER::
if (KeyPressCount > 0) {
    KeyPressCount += 1 
} 
else { 
    KeyPressCount := 1
}

SetTimer, KeyPressMonitor, 300 ; run KeyPressMonitor after 300, Basically wait monitoring for subsequent key strokes, Before reporting
tooltip, % KeyPressCount
return
tooltip, "Done"

KeyPressMonitor:
if (KeyPressCount = 1) 
{
    msgbox single press
    ; Run, calc.exe
}
else if (KeyPressCount = 2) ; The key was pressed twice
{
    msgbox double press
    ; Run, fl-studio.exe
}
else if (KeyPressCount > 2)    ; The key was pressed more than twice
{
    msgbox triple or more presses
    ;Run, Chrome.exe
}
KeyPressCount := 0 ;reset the count to zero
SetTimer, KeyPressMonitor, Off ;turn label off to stop monitoring for key strokes
tooltip, ;turn tooltip off
Return

ESC::ExitApp

return
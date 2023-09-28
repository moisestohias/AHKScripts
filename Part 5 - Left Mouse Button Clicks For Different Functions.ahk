;Watch the YouTube video in the following link for guidance:
;ENG: https://youtu.be/z1827ksT3vE
;KOR: https://youtu.be/aSd5p_Jjhfk

#SingleInstance,Force

~RButton & LButton::

While GetKeyState("RButton", "P")
{
    If GetKeyState("LButton", "P") {
        KeyPressCount += 1
        tooltip, % KeyPressCount
        Sleep 200 ; because in the case of mouse keys, the key press is continious we need to split it to get press count instead of time (ms) 
    }
}

KeyWait, RButton
SetTimer, KeyPressMonitor, 300

return

KeyPressMonitor:
if (KeyPressCount = 1) ; The key was pressed only once
{
    msgbox single press
    ;Run, calc.exe
}
else if (KeyPressCount = 2) ; The key was pressed twice
{
    msgbox double press
    ;Run, cmd.exe
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
#Persistent
WinTitle = XAVA ;or whatever you want
SetTitleMatchMode, 2
FallThrough = 1
WinSet, ExStyle, +0x20, % WinTitle ; 0x20 = WS_EX_CLICKTHROUGH
WinSet, Transparent, 100, % WinTitle ; for convinience, but you can take this out
WinSet, AlwaysOnTop, On, % WinTitle
return

#c::
if FallThrough = 1
{
  FallThrough = 0
  WinSet, ExStyle, -0x20, % WinTitle
  WinSet, Transparent, 255, % WinTitle
  WinSet, AlwaysOnTop, Off, % WinTitle
}
else
{
  FallThrough = 1
  WinSet, ExStyle, +0x20, % WinTitle
  WinSet, Transparent, 150, % WinTitle
  WinSet, AlwaysOnTop, On, % WinTitle
}
return



+^#d:: ; [Ctrl+Win+d] Decrease opacity
    WinGet, curtrans, Transparent, % WinTitle
    if ! curtrans
        curtrans = 255
    newtrans := curtrans - 10
    WinSet, Transparent, %newtrans% , % WinTitle
return

+^#i:: ; [Ctrl+Win+d] Decrease opacity
    WinGet, curtrans, Transparent, % WinTitle
    if ! curtrans
        curtrans = 255
    newtrans := curtrans + 10
    WinSet, Transparent, %newtrans% , % WinTitle
return

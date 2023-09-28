AutoHotkey is one of the best Windows automation programs that can perform the simplest of actions to the hardest of tasks. AutoHotkey is a free and open-source program which uses its own scripting language to automate any of your daily Windows tasks. Even though the “scripting language” sounds intimidating, it is very easy to use, and you can do all sorts of cool things.

Let me share my favorite and most-used AutoHotkey scripts, which make daily tasks a little bit easier, and that may help you too.

Before starting, it’s assumed you already know [how to install and configure AutoHotkey](https://www.maketecheasier.com/use-autohotkey-automate-things-windows/ "What is AutoHotKey and How To Use It to Automate Things in Windows"). Moreover, please note that the lines starting with `;` are comments.

#### Content

-   [1\. Adjusting Volume](https://www.maketecheasier.com/favorite-autohotkey-scripts/#adjust-volume)
-   [2\. Get Mouse Coordinates](https://www.maketecheasier.com/favorite-autohotkey-scripts/#mouse-coordinates)
-   [3\. Show and Hide Hidden Files](https://www.maketecheasier.com/favorite-autohotkey-scripts/#show-hidden-files)
-   [4\. Change Keyboard Shortcuts](https://www.maketecheasier.com/favorite-autohotkey-scripts/#change-keyboard-shortcuts)
-   [5\. Google Search Shortcut](https://www.maketecheasier.com/favorite-autohotkey-scripts/#google-search)
-   [6\. AutoCorrect](https://www.maketecheasier.com/favorite-autohotkey-scripts/#autocorrect)
-   [7\. Repurpose those Function Keys](https://www.maketecheasier.com/favorite-autohotkey-scripts/#repurpose-function-keys)
-   [8\. Open Webpages Quickly](https://www.maketecheasier.com/favorite-autohotkey-scripts/#open-webpages)
-   [9\. Open Favorite Folders](https://www.maketecheasier.com/favorite-autohotkey-scripts/#open-favorite-folders)
-   [10\. Move Up a Folder in File Explorer](https://www.maketecheasier.com/favorite-autohotkey-scripts/#move-up-folder)
-   [11\. Set Default State of Lock Keys](https://www.maketecheasier.com/favorite-autohotkey-scripts/#lock-key-default-state)
-   [12\. Reconfigure Caps Lock](https://www.maketecheasier.com/favorite-autohotkey-scripts/#caps-lock)
-   [13\. Empty Recycle Bin](https://www.maketecheasier.com/favorite-autohotkey-scripts/#empty-recycle-bin)
-   [14\. Window Always on Top](https://www.maketecheasier.com/favorite-autohotkey-scripts/#always-on-top)
-   [15\. Temporarily Suspend AutoHotkey](https://www.maketecheasier.com/favorite-autohotkey-scripts/#suspend-ahk)

## 1\. Adjusting Volume

Even though it doesn’t have any multimedia keys, I love my keyboard, but the lack of volume control buttons is a bit uncomfortable for me. I use the following AutoHotkey script to control the volume of my system.

```
; Custom volume buttons
+NumpadAdd:: Send {Volume_Up} ;shift + numpad plus
+NumpadSub:: Send {Volume_Down} ;shift + numpad minus
break::Send {Volume_Mute} ; Break key mutes
return
```

Here’s a fun alternative to volume adjustment that lets you do it using your mouse wheel and the Alt key.

```
;Volume control, Alt+Scroll wheel (and Mbutton)
Alt & WheelUp::Volume_Up
Alt & WheelDown::Volume_Down
Alt & MButton::Volume_Mute
```

## 2\. Get Mouse Coordinates

If you’re a UX designer or web developer, then pinpointing the exact onscreen coordinates of your mouse could an extremely useful thing to do. To that end, some kind soul on Reddit created this script, which by pressing Shift + 1 copies your mouse coordinates to your clipboard so you can easily bring them up.

```
Hotkey +1, getMousePos
 
getMousePos() {
MouseGetPos, xpos, ypos
xy := "x" xpos " y" ypos
ToolTip %xy%
Clipboard := xy
SetTimer toolTipClear, -1000
}
 
tooltipClear() {
ToolTip
}
```

## 3\. Show and Hide Hidden Files
Hidden files are hidden for a reason, but on your own PC, you may want to quickly toggle seeing them without having to go through the usual process of checking the relevant box in File Explorer.

The AutoHotkey script for this is a little bit longer:

```
^F2::GoSub,CheckActiveWindow
CheckActiveWindow:
ID := WinExist("A")
WinGetClass,Class, ahk_id %ID%
WClasses := "CabinetWClass ExploreWClass"
IfInString, WClasses, %Class%
GoSub, Toggle_HiddenFiles_Display
Return
 
Toggle_HiddenFiles_Display:
RootKey = HKEY_CURRENT_USER
SubKey = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
 
RegRead, HiddenFiles_Status, % RootKey, % SubKey, Hidden
 
if HiddenFiles_Status = 2
RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 1
else
RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 2
PostMessage, 0x111, 41504,,, ahk_id %ID%
Return
```

The above script uses Ctrl + F2 to toggle the hidden file view, but you can change that to whatever you want by swapping out that `^F2` right at the start of the script.

## 4\. Change Keyboard Shortcuts

The default keyboard shortcuts in Windows are all well and good, but maybe they’re not quite comfortable for you. For example, the Task Manager is one of the most important windows on the operating system, but who wants to press Ctrl + Shift + Esc each and every time you do it?

Using the above as an example, we are changing that keyboard shortcut to something simpler: Ctrl + X:

```
^x::Send ^+<strong>{</strong>Esc<strong>}</strong>
```

If you want more information on all the syntax to help you change the default Windows keyboard shortcuts, head over to [our dedicated article on the topic](https://www.maketecheasier.com/change-default-keyboard-shortcuts-windows10/).

## 5\. Google Search Shortcut

Google had the right idea when it turned the unloved and underused Caps Lock key into a dedicated search button that searched both your computer and Google. In the spirit of Chromebooks, you can turn the Caps Lock key into a Google Search key.

The following AutoHotkey script will automatically search Google when you highlight a bit of text and press Ctrl + Shift + C:

```
; Google Search highlighted text
^+c::
{
 Send, ^c
 Sleep 50
 Run, http://www.google.com/search?q=%clipboard%
 Return
}
```

## 6\. AutoCorrect

In the time that Windows has existed, smartphones have evolved immeasurably to the point they now have touchscreens and autocorrect built in. So why not have autocorrect on Windows?

In Autohotkey’s repository of scripts, you can find an autocorrect script, which contains thousands of common spelling errors that most people can easily make, then automatically fix them as you write/make them.

Here’s the [link to download the script](https://www.autohotkey.com/download/AutoCorrect.ahk). Just press Ctrl + A to select everything in the script, then copy it to a Notepad file that you should then save as “AutoCorrect.ahk.”

## 7\. Repurpose those Function Keys

Most of us hardly ever use the Function keys on our keyboard except for F2 (rename), F5 (refresh), and F11 (full screen in the browser). Using AutoHotkey, you can repurpose those unused functions to do a variety of things, like launching web pages, launching programs, etc. For instance, I use the function keys to launch my most-used programs, like Snagit, Sublime Text, Photoshop, Calculator, Thunderbird, etc.

To launch a program, simply use the script below. Don’t forget to replace the program path with your favorite program.

```
;Launch Sublime Text
F7::Run "C:\Program Files\Sublime Text 2\sublime_text.exe"
return
```

## 8\. Open Webpages Quickly

Just like launching your favorite programs, you can create your own custom shortcuts to launch your favorite websites. For instance, I use Ctrl + Shift + T to launch MakeTechEasier. Use the following script to launch your favorite web page. Don’t forget to replace the web address with your favorite site.

```
; Launch MakeTechEasier
^+t::Run "www.maketecheasier.com" ; use ctrl+Shift+t
return
```

Just like the one above, you can create you own shortcuts using a combination of Ctrl(^), Shift(+), Alt(!), and Win(#) keys.

## 9\. Open Favorite Folders

Along with opening web pages and programs, you can also open your most-used folders with just a simple shortcut. For instance, most of us access the Downloads folder often, and to make it easier, we can use a simple script like the one below. You can customize the script to change the shortcut and the folder path according to your needs.

```
; Open Downloads folder
^+d::Run "C:\Users\Robert\Downloads" ; ctrl+shift+d
return
```

## 10\. Move Up a Folder in File Explorer

When you are in a folder, you often need to move up one folder. In previous versions of Windows, the backspace key has done the job, but now the backspace key moves you back in history. This is useful to many, but I still hate to click on that little icon to move up a folder, so I use the below script to move up a folder by clicking the middle mouse button.

```
; Press middle mouse button to move up a folder in Explorer
#IfWinActive, ahk_class CabinetWClass
~MButton::Send !{Up} 
#IfWinActive
return
```

If you want you can also reconfigure the useless tilde (~) key on your keyboard to do the same action.

```
; Press ~ to move up a folder in Explorer
#IfWinActive, ahk_class CabinetWClass
`::Send !{Up} 
#IfWinActive
return
```

![ahk-scripts-up-folder](https://www.maketecheasier.com/assets/uploads/2015/08/ahk-scripts-up-folder.png "ahk-scripts-up-folder")

## 11\. Set Default State of Lock Keys

Using AutoHotkey, you can easily set the default or permanent state of the lock keys on our keyboard, e.g. set Caps Lock to be turned off, Num Lock to be turned on and Scroll Lock to be turned off. This simple script is so helpful. Even if you press them accidentally, the lock state won’t change.

```
; Default state of lock keys
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff
return
```

## 12\. Reconfigure Caps Lock

After turning off the Caps Lock, you may want to reconfigure it to act as the Shift key. To reconfigure the Caps Lock key, use the below script.

```
; Caps Lock acts as Shift
Capslock::Shift
return
```

## 13\. Empty Recycle Bin

You can use the below script to quickly empty the trash bin. This simple script saves me from using my mouse to do that same task.

```
; Empty trash
#Del::FileRecycleEmpty ; win + del
return
```

![ahk-scripts-empty-recyclebin](https://www.maketecheasier.com/assets/uploads/2015/08/ahk-scripts-empty-recyclebin.png "ahk-scripts-empty-recyclebin")

## 14\. Window Always on Top

Sometimes you just want a window to be always on top, no matter which window you are working on or is in focus. For instance, when working on a spreadsheet, you may access the calculator app frequently, and having it on top of the spreadsheet is quite handy. Using AutoHotkey, you can easily do this with a single line of code.

```
; Always on Top
^SPACE:: Winset, Alwaysontop, , A ; ctrl + space
Return
```

The script was originally published by [labnol](https://www.labnol.org/software/tutorials/keep-window-always-on-top/5213/).

## 15\. Temporarily Suspend AutoHotkey

The shortcuts created using AutoHotkey may sometimes interfere with some programs. In those cases, you can temporarily disable AutoHotkey using the below script. Of course, if you don’t want to use a shortcut, then simply right-click on the AutoHotkey icon in the taskbar and select the option “Suspend Hotkeys.”

```
; Suspend AutoHotkey
#ScrollLock::Suspend ; Win + scrollLock
return
```

![ahk-scripts-suspend-hotkeys](https://www.maketecheasier.com/assets/uploads/2015/08/ahk-scripts-suspend-hotkeys.png "ahk-scripts-suspend-hotkeys")

As you can see, all the AutoHotkey scripts shared above are basic but do make things easier. Besides the easy stuff, you can do all sorts of complicated things, like automatically send emails, manage programs, automate certain Windows tasks, automatically correct spellings, etc.

For more secret Windows stuff, see how to [fix the ‘Critical Process Died’ error in Windows](https://www.maketecheasier.com/fix-critical-process-died-windows/). We also have a registry hack to [restore your OneDrive taskbar icon](https://www.maketecheasier.com/restore-missing-onedrive-icon-taskbar-windows10/), should it go missing.

Is this article useful?

Subscribe to our newsletter!

Our latest tutorials delivered straight to your inbox

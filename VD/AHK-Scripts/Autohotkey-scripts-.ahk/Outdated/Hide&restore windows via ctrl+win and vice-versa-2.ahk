global ArrayMinimisedID := [] ; � ���� ������ ����� ������������ ��� ���������������� ����
global EVENT_SYSTEM_MINIMIZESTART := 0x16
global EVENT_SYSTEM_MINIMIZEEND := 0x17
; ������ ���������� ����������� ������� ������� LWin, ������� ����� �������� ��� �������������.
Hotkey, *LWin, Win, Off   

WinGet, List, List
Loop % List
{
	WinGet, MinMax, MinMax, % "ahk_id" List%A_Index%
	if MinMax = -1
		ArrayMinimisedID.Insert(List%A_Index%)
}
; ������������� ���, ������������� ������� ����������� � ��������������
; ���������� � http://msdn.microsoft.com/en-us/library/windows/desktop/dd373640%28v=vs.85%29.aspx
DllCall("SetWinEventHook", UInt, EVENT_SYSTEM_MINIMIZESTART
						, UInt, EVENT_SYSTEM_MINIMIZEEND
						, UInt, 0
						, UInt, RegisterCallback("HookProc", "F")
						, UInt, 0 , UInt, 0 , UInt, 0)
Return
 
HookProc(hWinEventHook, event, hwnd)
{
	if (event = EVENT_SYSTEM_MINIMIZESTART)
		ArrayMinimisedID.Insert(1, hwnd) ; ��� ����������� ������-�. ���� ���������� ��� ������������� � ������

	if (event = EVENT_SYSTEM_MINIMIZEEND) ; ��� �������������� ������-�. ���� ��������� ��� ������������� �� �������
		for k, v in ArrayMinimisedID
			if (v = hwnd)
				ArrayMinimisedID.Remove(k, k)
}

~*LCtrl::
	if !GetKeyState("LWin", "P")
	{
		Hotkey, *LWin, On
		Return
	}
	if !GetKeyState("LShift", "P")
	{
	WinGetClass, class, A
	if !(class ~= "Progman|WorkerW|Shell_TrayWnd|Button")
		WinMinimize, A
	Return
	}

~*LCtrl Up:: Hotkey, *LWin, Off

Win:
	ID := ArrayMinimisedID.1
	WinRestore, % "ahk_id " ID
	WinActivate, % "ahk_id " ID
	Return
; Win+` = ��������/����� ��������� ���� ����� "������ ���� ����".
#`::Winset, Alwaysontop, , A

; Win+Shift+LCtrl = Win+D
#+LCtrl::Send, #d

; To do:
; ����-���� �� ����� � �������� ��������� ��, ���� ���� �� ����� ��������� ���� ���������� ������.
; ��������� �����/���� ��� ��������� - ����������� ���� �����/����.
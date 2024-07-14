#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!c::
IfWinExist ahk_exe Code.exe
	winactivate ahk_exe Code.exe
else
	run, "C:\Program Files\Microsoft VS Code\Code.exe"
WinWait ahk_exe Code.exe
WinActivate ahk_exe Code.exe
WinWaitActive ahk_exe Code.exe
return

!d::
IfWinExist ahk_exe dbeaver.exe
	winactivate ahk_exe dbeaver.exe
else
	run, "C:\Program Files\DBeaver\dbeaver.exe"
WinWait ahk_exe dbeaver.exe
WinActivate ahk_exe dbeaver.exe
WinWaitActive ahk_exe dbeaver.exe
return

!b::
IfWinExist ahk_exe brave.exe
	winactivate ahk_exe brave.exe
else
	run, "C:\Users\serrac\AppData\Local\BraveSoftware\Brave-Browser-Beta\Application\brave.exe"
WinWait ahk_exe brave.exe
WinActivate ahk_exe brave.exe
WinWaitActive ahk_exe brave.exe
return

!n::
IfWinExist ahk_exe Notion.exe
	winactivate ahk_exe Notion.exe
else
	run, "C:\Users\serrac\AppData\Local\Programs\Notion\Notion.exe"
WinWait ahk_exe Notion.exe
WinActivate ahk_exe Notion.exe
WinWaitActive ahk_exe Notion.exe
return

!m::
IfWinExist ahk_exe Teams.exe
	winactivate ahk_exe Teams.exe
else
	run, "C:\Users\serrac\AppData\Local\Microsoft\Teams\current\Teams.exe"
WinWait ahk_exe Teams.exe
WinActivate ahk_exe Teams.exe
WinWaitActive ahk_exe Teams.exe
return

!p::
IfWinExist ahk_exe Postman.exe
	winactivate ahk_exe Postman.exe
else
	run, "C:\Users\serrac\AppData\Local\Postman\Postman.exe"
WinWait ahk_exe Postman.exe
WinActivate ahk_exe Postman.exe
WinWaitActive ahk_exe Postman.exe
return

!t::
IfWinExist ahk_exe wezterm-gui.exe
	winactivate ahk_exe wezterm-gui.exe
else
	run, "C:\Program Files\WezTerm\wezterm-gui.exe"
WinWait ahk_exe wezterm-gui.exe
WinActivate ahk_exe wezterm-gui.exe
WinWaitActive ahk_exe wezterm-gui.exe
return
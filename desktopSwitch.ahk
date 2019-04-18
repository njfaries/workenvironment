#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2


^+j::Send ^!{Down}
^+k::Send ^!{Up}
^+h::Send ^!{Left}
^+l::Send ^!{Right}

XButton2 & WheelDown::AltTab
XButton2 & WheelUp::ShiftAltTab

^#SPACE:: Winset, Alwaysontop, , A

;/usr/bin/bash --login -i
; positioning of git window
; Winmove, "MINGW64:/c/formsGit",, 1517, 849

#Persistent
SetTimer, ClosePopup, 250
return

ClosePopup:
WinClose, WCF Service Host
return

#IfWinActive, Microsoft Teams
^Tab::Send !{Up}
^+Tab::Send !{Down}

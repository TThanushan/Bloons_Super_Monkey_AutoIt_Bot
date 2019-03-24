#include <functions.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <AutoItConstants.au3>
#include <Timers.au3>
#include <GuiRichEdit.au3>

#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Bloons Super Monkey autoIt Bot by Wombart", 382, 336, 221, 160)
GUISetBkColor(0xe6ffcc)
$Group1 = GUICtrlCreateGroup("", 3, 0, 374, 329)
$Radio1 = GUICtrlCreateRadio("On", 13, 16, 41, 17)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Click to run the bot")
$Radio2 = GUICtrlCreateRadio("Off", 64, 16, 49, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Click to stop the bot")
$Pic1 = GUICtrlCreatePic("C:\Users\lesim\Documents\Development\AutoIt\Bloons Super Monkey autoIt Bot\Ressources\BloonsSuperMonkeyMainImage.jpg", 248, 16, 116, 100)
GUICtrlSetTip(-1, "Bloons Super Monkey Flash Game on NinjaKiwi.com")
$Label2 = GUICtrlCreateLabel("R to run / S to stop / F1 to exit", 13, 304, 155, 17)
$Label1 = GUICtrlCreateLabel("Upgrade in :", 13, 76, 85, 17)
$Label3 = GUICtrlCreateLabel("Running time :", 13, 40, 192, 17)
$Label4 = GUICtrlCreateLabel("Points :", 13, 112, 39, 17)
$Label5 = GUICtrlCreateLabel("xxxxxxxx", 52, 112, 180, 33)
$Label6 = GUICtrlCreateLabel("xxxxxxxx", 57, 148, 108, 17)
$Label7 = GUICtrlCreateLabel("Target :", 13, 148, 44, 17)
$Label8 = GUICtrlCreateLabel("By Wombart", 312, 304, 59, 17)
GUICtrlSetTip(-1, "Time remaining before the next upgrades")
$Label9 = GUICtrlCreateLabel("xxxxxxxx", 122, 184, 212, 33)
$Label10 = GUICtrlCreateLabel("Program Speed (ms)", 13, 184, 105, 17)
$Label11 = GUICtrlCreateLabel("xxxxxxxx", 122, 220, 212, 81)
$Label12 = GUICtrlCreateLabel("Next upgrade name:", 13, 220, 105, 17)
GUICtrlSetTip(-1, "Time between loops")

GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;~ Change xp theme to allow custom progressBar
XPStyleToggle(1)
$Progress1 = GUICtrlCreateProgress(104, 76, 102, 17)
GUICtrlSetColor($Progress1, 0x1AC81E)
GUICtrlSetBkColor($Progress1, 0x9CEFC6)
XPStyleToggle(0)

WinSetOnTop($Form1_1, "", $WINDOWS_ONTOP)
WinMove($Form1_1, "", 27, 460)

HotKeySet("{F1}", "ExitPgr")

Init()



While 1
	$programSpeed = _Timer_Init()
	HotKeyFunc($Radio1, $Radio2)

	If ManageGUIData() = 1 Then

		RunMain()
	EndIf

WEnd

Func ManageGUIData()
	$return = 0
;~ 	If (Random() > 0.98) Then
		Local $minutes = (Int(_Timer_Diff($hStartTime) / 1000 / 60))
		Local $seconds = Mod((Int(_Timer_Diff($hStartTime) / 1000)), 60)
		GUICtrlSetData($Label3, "Running time : " & $minutes & " min " & $seconds & " s")
;~ 	EndIf
	GUICtrlSetData($Label5, "PowerBlops: " & $balloonsPopCount[5] & "/red: " & $balloonsPopCount[0] & "/blue: " & $balloonsPopCount[1] & "/green: " & $balloonsPopCount[2] & "/yellow: " & $balloonsPopCount[3] & "/pink: " & $balloonsPopCount[4])

	GUICtrlSetData($Progress1, $nextUpgradeTimer & "%")
	GUICtrlSetData($Label1, "Upgrade in ("&100-$nextUpgradeTimer&") :")

	GUICtrlSetData($Label6, $targetName)
	GUICtrlSetData($Label11, GetNextUpgradesName())

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitPgr()
		Case $Radio1
			SoundPlay("Ressources/GameResumedSfx.mp3")
		Case $Radio2
			SoundPlay("Ressources/GamePausedSfx.mp3")
	EndSwitch

	If (GUICtrlRead($Radio1) = 1) Then
		$return = 1
	EndIf

	DoProgramSpeedUpdate()
	GUICtrlSetData($Label9, $programSpeed & " / AVG : " & $programSpeedAverage & " / Max : " & $programSpeedMax & " / Min : " & $programSpeedMin)

	Return $return
EndFunc   ;==>ManageGUIData




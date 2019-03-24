#include-once
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <Timers.au3>
#include <ScreenCapture.au3>
#include <WinAPI.au3>
#include <APIConstants.au3>
#include <GUIConstants.au3>


Global Const $screenPos[4] = [567, 241, 1094, 700]
Global Const $mouseSpeed = 0
Global Const $sleep = 0

Global $programSpeed = 0
Global $programSpeedAverage = 0
Global $programSpeedMin = 500
Global $programSpeedMax = 0
Global $botState = False
Global $balloonsPopCount[6] = [0, 0, 0, 0, 0, 0]
Global $hStartTime = _Timer_Init()
Global $upgradeCount = 0
Global $nextUpgradeTimerhStartTime = 0
Global $nextUpgradeTimer = 0
Global $targetName = "Unknown"
Global $nextUpgradeName = "Fastest Dart"
Global $upgradeOrder[24] = [8, 16, 0, 17, 18, 9, 19, 1, 2, 10, 11, 3, 12, 13, 4, 5, 6, 7, 20, 21, 22, 23, 14, 15]
;~   Upgrade Line 1 [$name, $posX, $posY]
Global $upgradeInfo[24][3] = [["Fastest Dart", 599, 425], ["Twin Darts", 670, 427], ["Triple Darts", 727, 424], ["Extra Speed", 793, 427], ["Laser Vision", 856, 427], _
		["Twin Darts and Laser Vision", 919, 431], ["Triple Twin Lasers", 983, 426], ["DEATH RAY VISION", 1052, 428], _ ; Line 1
		["Boomer", 602, 499], ["Double Boomer", 665, 499], ["Heavy Missile", 729, 498], ["Twin Missiles", 793, 500], ["Smart Missile", 858, 498], ["Quad Missile", 921, 499], _
		["MOAB Maulers", 987, 498], ["Quad MOAB", 1052, 500], _ ; Line 2
		["Plasma Tentacle", 603, 563], ["Double Plasma", 670, 563], ["Triple Plasma", 733, 562], ["Quad Plasma", 795, 565], ["Super Plasma", 856, 562], ["Twin Super", 922, 560], _
		["Triple Super", 989, 564], ["Quad Super", 1048, 561]] ; Line 3

;~ Bot cursor window
Global $hWin = _GUI_Transparent_Client(30, 30, -30, 30, 3, 0xFF00CC)
Global $aPos = WinGetPos($hWin)
Global $cursorInfo[3] = [0, 0, 0xFF00CC]

Func MoveCursor($x, $y, $col = 0)
	Dim $cursorInfo[2] = [$x, $y]
	If $col <> 0 Then
		GUISetBkColor($col, $hWin)
	EndIf
	WinMove($hWin, "", $cursorInfo[0] - $aPos[2] / 2, $cursorInfo[1] - $aPos[3] / 2)
EndFunc   ;==>MoveCursor

Func WipeOffCursor()
	MoveCursor(0, -300)
EndFunc   ;==>WipeOffCursor

Func ResetPosition()
	MouseMove(839, 492, 0)
EndFunc   ;==>ResetPosition

Func Init()

	SoundPlay("Ressources/ButtonSfx3.mp3", 0)
	WipeOffCursor()
EndFunc   ;==>Init

Func ExitPgr()
	_ScreenCapture_Capture(@WorkingDir & "\ScreenCapture\GameOver_" & @MDAY & "_" & @MON & "_" & @HOUR & "h_" & @MIN & "_" & @SEC & "s.jpg", 555, 228, 1194, 707)

	SoundPlay("Ressources/ButtonSfx1.mp3", 1)
	Exit
EndFunc   ;==>ExitPgr

Func StopBot($btnId)
	$botState = False
	GUICtrlSetState($btnId, $GUI_CHECKED)
	SoundPlay("Ressources/GamePausedSfx.mp3")
	WipeOffCursor()

EndFunc   ;==>StopBot

Func HotKeyFunc($btnId1, $btnId2)
	If _IsPressed("52") Then ;R key
;~ 		SoundPlay("Ressources/GameResumedSfx.mp3")
		RunBot($btnId1)
	ElseIf _IsPressed("53") Then ;S key
;~ 		SoundPlay("Ressources/GamePausedSfx.mp3")
		StopBot($btnId2)
	ElseIf _IsPressed("41") Then ;A key
		SoundPlay("Ressources/UpgradeCompleteSfx.mp3")
		$upgradeCount += 1
		Sleep(300)
	EndIf
EndFunc   ;==>HotKeyFunc

Func RunBot($btnId)
	$botState = True

	WipeOffCursor()
	MouseClick("left", 687, 246, 1, 0)
	If ($nextUpgradeTimerhStartTime = 0) Then
		$nextUpgradeTimerhStartTime = _Timer_Init()
	EndIf

	GUICtrlSetState($btnId, $GUI_CHECKED)
	SoundPlay("Ressources/GameResumedSfx.mp3")

EndFunc   ;==>RunBot

Func FindABalloon($col, $targName, ByRef $popCount, $cursorCol, $shad = 0, $step = 1)
	Local $balloon = 0
	Local $balloon = PixelSearch($screenPos[2], $screenPos[3], $screenPos[0], $screenPos[1], $col, $shad, $step)
	If Not @error Then
		$targetName = $targName
		$popCount += 1
		If $targetName = "Power Blops" Then
			$balloon[1] -= 80
		EndIf
		MoveCursor($balloon[0], $balloon[1], $cursorCol)

	Else
		$balloon = 0
	EndIf

	Return $balloon
EndFunc   ;==>FindABalloon

Func SearchBalloons()

	$return = FindABalloon(0xCC0000, "Red Balloons", $balloonsPopCount[0], 0xff5050, 0, 15)

	If $return = 0 Then

		$return = FindABalloon(0x0E6DAD, "Blue Balloons", $balloonsPopCount[1], 0x3399ff, 0, 15)
	EndIf

	If $return = 0 Then
		$return = FindABalloon(0x339900, "Green Balloons", $balloonsPopCount[2], 0x66ff33, 0, 15)
	EndIf

	If $return = 0 Then
		$return = FindABalloon(0xDBDB02, "Yellow Balloons", $balloonsPopCount[3], 0xffff99, 0, 15)
	EndIf

	If $return = 0 Then
		$return = FindABalloon(0xF25162, "Pink Balloons", $balloonsPopCount[4], 0xff66ff, 0, 15)
	EndIf

	If $return = 0 Then
		$return = FindABalloon(0x61370F, "Ceramic Balloons", $balloonsPopCount[4], 0xD8A424, 0, 15)
	EndIf

	If $return = 0 Then
;~ 	Searching Power Blops.
		$return = FindABalloon(0x9DFFFF, "Power Blops", $balloonsPopCount[5], 0x3399ff, 0, 10)
	EndIf

	If $return = 0 Then
		$targetName = "Unknown"
		$return = -1

	EndIf

	Return $return
EndFunc   ;==>SearchBalloons

Func MoveOnBalloons($pos)
	If $pos <> -1 Then
		If $pos[1] + 80 > $screenPos[3] Then
			$pos[1] -= 80
		EndIf

		MouseMove($pos[0], $pos[1] + 50, $mouseSpeed)
;~ 		Sleep($sleep)
	Else
		WipeOffCursor()
		ResetPosition()
	EndIf
EndFunc   ;==>MoveOnBalloons

Func UpdateProgressBar()
	If $upgradeCount >= UBound($upgradeOrder) Then
		Return 0
	EndIf
	$nextUpgradeTimer = (Int(_Timer_Diff($nextUpgradeTimerhStartTime) / 500)) * 10
	If ($nextUpgradeTimer > 100) Then
		BuyUpgrades()
		$nextUpgradeTimerhStartTime = _Timer_Init()

	EndIf
EndFunc   ;==>UpdateProgressBar

Func CheckIfCanBuy($_nextUpgradeName, $x, $y)

	MouseMove($x, $y, 0)
	Sleep(100)
	$return = 0
;~ 	$boughtText = PixelChecksum(899, 325, 1076, 359)
	$boughtText = PixelChecksum(1107, 582, 1184, 621)

	MouseClick("left", $x, $y, 1, 0)
	Sleep(100)

	If $boughtText <> PixelChecksum(1107, 582, 1184, 621) Then
		SoundPlay("Ressources/UpgradeCompleteSfx.mp3", 0)
		$return = 1


		$nextUpgradeName = $_nextUpgradeName
		If $upgradeCount <= UBound($upgradeOrder) - 1 Then

			$upgradeCount += 1
		EndIf
	EndIf

	Return $return
EndFunc   ;==>CheckIfCanBuy

Func BuyUpgrades()
	Local $oldPos = MouseGetPos()


	MouseClick("left", 687, 246, 1, 0)

;~ 	Check if the score reward isn't on the screen
	If CheckNextWaveButton() Then
		SoundPlay("Ressources/ButtonSfx2.mp3", 0)
		_ScreenCapture_Capture(@WorkingDir & "\ScreenCapture\DebugScreenCapture\TropheReward" & @MDAY & "_" & @MON & "_" & @HOUR & "h_" & @MIN & "_" & @SEC & "s.jpg", 555, 228, 1194, 707)
		Sleep(4000)
		Return
	EndIf


	Send("{ESC}")
	WipeOffCursor()

	Local $index = $upgradeOrder[$upgradeCount]

	Local $upName = $upgradeInfo[$index][0]
	Local $upPosX = $upgradeInfo[$index][1]
	Local $upPosY = $upgradeInfo[$index][2]

	CheckIfAnimation()

	$state = CheckIfCanBuy($upName, $upPosX, $upPosY)

	MouseMove($oldPos[0], $oldPos[1], 0)
	Send("{ESC}")

EndFunc   ;==>BuyUpgrades

;~ Check if the screen has changed since the shop is open
Func CheckIfAnimation()
;~ 	Send("{ESC}")
	Sleep(100)
	Local $check = PixelChecksum(1007, 284, 1017, 294)
	Sleep(100)
	If $check <> PixelChecksum(1007, 284, 1017, 294) Then
		_ScreenCapture_Capture(@WorkingDir & "\ScreenCapture\DebugScreenCapture\AnimationOnGoing" & @MDAY & "_" & @MON & "_" & @HOUR & "h_" & @MIN & "_" & @SEC & "s.jpg", 555, 228, 1194, 707)

		SoundPlay("Ressources/ButtonSfx2.mp3", 1)
		SoundPlay("Ressources/ButtonSfx2.mp3", 0)
		Sleep(3000)
	EndIf
;~ 	Send("{ESC}")
EndFunc   ;==>CheckIfAnimation

Func GetNextUpgradesName()
	If $upgradeCount >= UBound($upgradeOrder) Then
		Return "All bought !"
	EndIf

	Local $index = $upgradeOrder[$upgradeCount]
	Local $return = " >" & $upgradeInfo[$index][0] & "< => "
	For $i = 1 To 5 Step 1
		If $index + $i >= UBound($upgradeInfo) Or $upgradeCount + $i >= UBound($upgradeOrder) Then
			ExitLoop
		EndIf

		$index = $upgradeOrder[$upgradeCount + $i]


		$return &= $upgradeInfo[$index][0] & " => "

	Next
	$return = StringTrimRight($return, 4)
	$return &= "..."
	Return $return
EndFunc   ;==>GetNextUpgradesName

Func RunMain()

	UpdateProgressBar()
	CheckNextWaveButton()

	$pos = SearchBalloons()
	If $pos = Null Then
		Return
	EndIf
	MoveOnBalloons($pos)


EndFunc   ;==>RunMain

Func DoProgramSpeedUpdate()


	$programSpeed = Int(_Timer_Diff($programSpeed))
	If $programSpeed > $programSpeedMax Then
		$programSpeedMax = $programSpeed
	EndIf
	If $programSpeed < $programSpeedMin And $botState = True Then
		$programSpeedMin = $programSpeed
	EndIf
	$programSpeedAverage = Int(($programSpeedAverage + $programSpeed) / 2)
EndFunc   ;==>DoProgramSpeedUpdate

Func CheckNextWaveButton()
	$return = 0
	$pos = PixelSearch(898, 616, 966, 642, 0xFFFE00, 3)
	If Not @error Then
		$gameOver = CheckGameOverScreen()
		If $gameOver = 0 Then
			Local $oldPos = MouseGetPos()
			MouseClick("left", 944, 632, 1, 0)
			MouseMove($oldPos[0], $oldPos[1], 0)
			$return = 1
		EndIf
	EndIf
	Return $return
EndFunc   ;==>CheckNextWaveButton

Func CheckGameOverScreen()
	$posPlayAgain = PixelSearch(1117, 248, 1185, 308, 0x5496F7)
	$return = 0
	If Not @error Then
		$posPlayAgain = PixelSearch(1117, 248, 1185, 308, 0x5496F7)

		If Not @error Then
			MoveCursor($posPlayAgain[0], $posPlayAgain[1], 0x090C12)
			_ScreenCapture_Capture(@WorkingDir & "\ScreenCapture\GameOver_" & @MDAY & "_" & @MON & "_" & @HOUR & "h_" & @MIN & "_" & @SEC & "s.jpg", 555, 228, 1194, 707)
			$return = 1
			ExitPgr()
		EndIf
	EndIf

	Return $return
EndFunc   ;==>CheckGameOverScreen


;~ Change xp theme for the GUI, used to change the progressBar color.
Func XPStyleToggle($OnOff = 1)
	Local $XS_n
	If Not StringInStr(@OSType, "WIN32_NT") Then Return 0
	If $OnOff Then
		$XS_n = DllCall("uxtheme.dll", "int", "GetThemeAppProperties")
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
		Return 1
	ElseIf IsArray($XS_n) Then
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", $XS_n[0])
		$XS_n = ""
		Return 1
	EndIf
	Return 0
EndFunc   ;==>XPStyleToggle


Func _GUI_Transparent_Client($iX, $iY, $iWidth, $iHeight, $iFrameWidth = 10, $iColor = 0)

	$hGUI = GUICreate("", $iX, $iY, $iWidth, $iHeight, $WS_POPUP, $WS_EX_TOPMOST)
	$aPos = WinGetPos($hGUI)
	_GuiHole($hGUI, $iFrameWidth, $iFrameWidth, $aPos[2] - 2 * $iFrameWidth, $aPos[3] - 2 * $iFrameWidth, $aPos[2], $aPos[3])
	GUISetBkColor($iColor)
	GUISetState()

	Return $hGUI

EndFunc   ;==>_GUI_Transparent_Client

Func _GuiHole($h_win, $i_x, $i_y, $i_sizew, $i_sizeh, $width, $height)

	Local $outer_rgn, $inner_rgn, $combined_rgn

	$outer_rgn = _WinAPI_CreateRectRgn(0, 0, $width, $height)
	$inner_rgn = _WinAPI_CreateRectRgn($i_x, $i_y, $i_x + $i_sizew, $i_y + $i_sizeh)
	$combined_rgn = _WinAPI_CreateRectRgn(0, 0, 0, 0)

	_WinAPI_CombineRgn($combined_rgn, $outer_rgn, $inner_rgn, $RGN_DIFF)

	_WinAPI_DeleteObject($outer_rgn)
	_WinAPI_DeleteObject($inner_rgn)

	_WinAPI_SetWindowRgn($h_win, $combined_rgn)

EndFunc   ;==>_GuiHole


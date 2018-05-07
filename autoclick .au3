#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <array.au3>

Global $Struct = DllStructCreate($tagPoint), $y_ctrl[0], $x_ctrl[0], $ctrl_hwnd[0]

HotKeySet("^a", "_Get_Win_Pos") ;;;nh?n phím Control + A d? luu các di?m click
HotKeySet("^s", "xem_cac_toa_do_da_chon") ;;;nh?n phím Control + S d? xem các t?a d? dã ch?n

Func xem_cac_toa_do_da_chon()
 _ArrayDisplay($x_ctrl, "x")
 _ArrayDisplay($y_ctrl, "y")
 _ArrayDisplay($ctrl_hwnd, "ctrl")
EndFunc   ;==>i

GUICreate("AutoClick", 200, 150, @DesktopWidth - 210, @DesktopHeight - 350, 0x2000)
GUISetState()
GUICtrlCreateLabel("Toa do:", 5, 5, 50, 15)
$tdx = GUICtrlCreateLabel("x1", 55, 5, 70, 15)
$tdy = GUICtrlCreateLabel("y1", 125, 5, 70, 15)
$win = GUICtrlCreateLabel("win", 55, 20, 200, 15)
GUICtrlCreateLabel("Sau ", 5, 60, 20, 15)
$thoigian = GUICtrlCreateInput("3000", 30, 58, 130, 15)
GUICtrlCreateLabel("ms", 170, 60, 50, 15)
$bd = GUICtrlCreateCheckbox("Bat dau", 5, 80, 80, 30,0x1000)
$thoat = GUICtrlCreateButton("Thoat", 85, 80, 80, 30)


While 1
 $msg = GUIGetMsg()
 Switch $msg
 Case $bd
 batdau()
 Case $thoat
 Exit
 EndSwitch
WEnd

Func batdau()
 $time = GUICtrlRead($thoigian)
 If $time = "" Then $time = 0
 While 1
 If GUICtrlRead($bd) = $gui_unchecked Then exitloop
 _Click_No_Detect_Mouse()
 Sleep($time)
 WEnd
EndFunc   ;==>batdau

Func _Get_Win_Pos()
 DllStructSetData($Struct, "x", MouseGetPos(0))
 DllStructSetData($Struct, "y", MouseGetPos(1))
 $hwnd = _WinAPI_WindowFromPoint($Struct)
 _WinAPI_ScreenToClient($hwnd, $Struct)
 $x_converted = DllStructGetData($Struct, "x")
 $y_converted = DllStructGetData($Struct, "y")
 _ArrayAdd($x_ctrl, $x_converted)
 _ArrayAdd($y_ctrl, $y_converted)
 _ArrayAdd($ctrl_hwnd, $hwnd)
 GUICtrlSetData($tdx, $x_converted)
 GUICtrlSetData($tdy, $y_converted)
EndFunc   ;==>_Get_Win_Pos

Func _Click_No_Detect_Mouse()
 For $i = 0 To UBound($ctrl_hwnd) - 1
 $lParam = ($y_ctrl[$i] * 65536) + ($x_ctrl[$i])
 _WinAPI_PostMessage($ctrl_hwnd[$i], 0x201, 0x1, $lParam)
 _WinAPI_PostMessage($ctrl_hwnd[$i], 0x202, 0, $lParam)
 Sleep(2000)
 Next
EndFunc   ;==>_Click_No_Detect_Mouse
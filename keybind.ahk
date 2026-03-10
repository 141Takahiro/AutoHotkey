#Requires AutoHotkey v2.0

; --- 特殊キーの変更---
; Caps Lock をEscに変更
vkF0::Esc
+CapsLock::Return

; 半角/全角キーの無効化（単体押しを無効にする）
vkF3::Return
vkF4::Return

; 無変換 (vk1D) を押すと「IMEをオフ（英語入力）」にする
vk1D::IME_SET(0)

; 変換 (vk1C) を押すと「IMEをオン（日本語入力）」にする
vk1C::IME_SET(1)

; --- Space単体押しの制御 ---
Space::Send "{Space}"

; --- テキスト編集用 ---
; Space + F で Enter
Space & f::Send "{Enter}"

; Space + R で BackSpace
Space & r::Send "{BS}"

; Space + V で Delete
Space & v::Send "{Delete}"

; Space + U で 「。」
Space & u::Send "{vkBE}"  ; ピリオド/句点

; Space + I で 「、」 
Space & i::Send "{vkBC}"  ; カンマ/読点

; Space + P で 「？」
Space & p::Send "+{vkBF}"  

; Space + O で 「!」 
Space & o::Send "+{vk31}"  

; ( ) 括弧
Space & w:: IME_Send("（", "(")
Space & s:: IME_Send("）", ")")

; { } 波括弧
Space & e:: IME_Send("「", "{")
Space & d:: IME_Send("」", "}")

; [ ] 角括弧
Space & q:: IME_Send("［", "[")
Space & a:: IME_Send("］", "]")

; < > 山括弧
Space & t::Send "<"
Space & g::Send ">"

; Space + Y で「/」
Space & y:: IME_Send("・", "/")

; Space + b で「_」
Space & b:: IME_Send("＿", "_")

; Space + n で「\」
Space & n:: IME_Send("￥", "\")

; --- 移動用 ---
Space & h::Send "{Left}"
Space & j::Send "{Down}"
Space & k::Send "{Up}"
Space & l::Send "{Right}"

; --- スペースでも切り替えられるように ---
Space & vkBB::Send "{+}" 
Space & vkBA::Send "*"    
Space & 1:: IME_Send("！", "!") 
Space & 2:: IME_Send("”", '"') 
Space & 3:: IME_Send("＃", "#")
Space & 4:: IME_Send("＄", "$")
Space & 5:: IME_Send("％", "%")
Space & 6:: IME_Send("＆", "&")
Space & 7:: IME_Send("’", "'") 
Space & -:: IME_Send("＝", "=")
Space & ^:: IME_Send("～", "~")
Space & \:: IME_Send("｜", "|")

; --- geminiを呼び出す関数 ---
global TerminalClass := "ahk_exe WindowsTerminal.exe"
Space & z:: {
    if WinExist("Gemini") {
        WinActivate("Gemini")
    } else {
        MsgBox("Geminiのウィンドウが見つかりません。")
    }
}

; --- neovimを呼び出す関数 ---
Space & x:: {
    if WinExist(TerminalClass) {
        WinActivate(TerminalClass)
    } else {
        MsgBox("ターミナルのウィンドウが見つかりません。")
    }
}

; --- メインブラウザを呼び出す関数 ---
Space & c:: {
   targetWindow := WinExist("ahk_exe chrome.exe", , "Gemini")
    if targetWindow {
        WinActivate(targetWindow)
    }
}

; --- gemini用テキストのショートカット ---
!k::Send "解説しなさい。"
!s::Send "修正しなさい。"
!r::Send "例示しなさい。"

; IME制御用の関数
IME_SET(SetSts) {
    try {
        hWnd := WinGetID("A")
    } catch {
        return
    }
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
    SendMessage(0x0283, 0x0006, SetSts, DefaultIMEWnd)
}

IME_Send(zenkaku, hankaku) {
    if (IME_GET()) {
        Send(zenkaku) ; IME ONなら指定された全角文字を送信
    } else {
        Send("{Text}" . hankaku) ; IME OFFなら半角文字を送信
    }
}

IME_GET(WinTitle := "A") {
    try {
        hWnd := WinGetID(WinTitle)
    } catch {
        return 0
    }
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hWnd, "Ptr")
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows(True)
    ; 0x0005 は IMC_GETOPENSTATUS
    res := SendMessage(0x0283, 0x0005, 0, DefaultIMEWnd)
    DetectHiddenWindows(DetectSave)
    return res
}
#Requires AutoHotkey v2.0

; --- Caps Lock をEscに変更---
vkF0::Esc

; --- 半角/全角キーの無効化（単体押しを無効にする） ---
vkF3::Return
vkF4::Return

; --- 変換・無変換をMac風の入力切替にする ---
; 無変換 (vk1D) を押すと「IMEをオフ（英語入力）」にする
vk1D::IME_SET(0)

; 変換 (vk1C) を押すと「IMEをオン（日本語入力）」にする
vk1C::IME_SET(1)

; --- IME制御用の関数（v2用） ---
IME_SET(SetSts) {
    try {
        hWnd := WinGetID("A")
    } catch {
        return
    }
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
    SendMessage(0x0283, 0x0006, SetSts, DefaultIMEWnd)
}

; Space + F で Enter
Space & f::Send "{Enter}"

; Space + R で BackSpace
Space & r::Send "{BS}"

; Space + V で Delete
Space & v::Send "{Delete}"

; --- Space単体押しの制御 ---
Space::Send "{Space}"

; Space + U で 「。」 (句点)
Space & u::Send "{vkBE}"  ; ピリオド/句点

; Space + I で 「、」 (読点)
Space & i::Send "{vkBC}"  ; カンマ/読点

; Space + P で 「？」 (クエスチョンマーク)
Space & p::Send "+{vkBF}"  ; Shift + / を送信

; Space + O で 「!」 (クエスチョンマーク)
Space & o::Send "+{vk31}"  ; Shift + / を送信


; --- 無変換(vk1D) との組み合わせでカッコを入力 ---
; ( ) 括弧
Space & e:: IME_Send("（", "(")
Space & d:: IME_Send("）", ")")

; { } 波括弧
Space & w:: IME_Send("「", "{")
Space & s:: IME_Send("」", "}")

; [ ] 角括弧
Space & q:: IME_Send("［", "[")
Space & a:: IME_Send("］", "]")

; Space + Y で「/」を入力 (IME連動)
Space & y:: IME_Send("／", "/")

Space & n:: IME_Send("＿", "_")


; [Vim風移動]
Space & h::Send "{Left}"
Space & j::Send "{Down}"
Space & k::Send "{Up}"
Space & l::Send "{Right}"

; --- 制御用関数：IMEの状態を見て送信文字を切り替える ---
IME_Send(zenkaku, hankaku) {
    if (IME_GET()) {
        Send(zenkaku) ; IME ONなら指定された全角文字を送信
    } else {
        Send("{Text}" . hankaku) ; IME OFFなら半角文字を送信
    }
}

; --- IMEの状態を取得する関数 ---
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
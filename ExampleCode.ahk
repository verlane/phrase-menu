#Include ClassPhrase.ahk
#Include ClassPhraseMenu.ahk
; --------------------
; Example usage
; --------------------
p := ClassPhrase ; p => shorthand for ClassPhrase

myPhrases := [
  p("&B Banking"), [
    p("Bank A"),              ; Plain text -> copies "Bank A" to clipboard
    p("Bank B"),              ; Plain text -> copies "Bank B" to clipboard
    p("https://www.bankC.com", "Bank C"),  ; URL -> opens in browser
    p("SubMenu"), [
      p("Check Balance"),   ; Plain text
      p("Transfer Funds"),  ; Plain text
    ]
  ],
  p("&P Prompts"), [
    p("&P Example Prompt`n`n"), ; Copies multiline text to clipboard
    p("Another Prompt"),        ; Plain text
  ],
  p("&W Web"), [
    p("https://www.youtube.com", "&Y YouTube"), ; URL -> opens in browser
    p("https://www.google.com", "&G Google"),   ; URL -> opens in browser
    p("notepad.exe", "&N Open Notepad", ClassPhrase.TYPE_COMMAND), ; Runs notepad.exe
  ],
  p("!r", "&R Press Alt+R", ClassPhrase.TYPE_AHK),               ; Sends the AHK keystroke: Alt+R
  p(""),  ; Empty string => separator
  p("&Z Test"), [
    p("Simple text snippet", "Sample Text"),  ; Copies text snippet to clipboard
    p(() => MsgBox("Function callback!"), "&F Show MsgBox"), ; Anonymous function -> MsgBox
  ],
  p(() => ExitApp(), "&X Exit"),  ; Anonymous function -> Exit the script
]

phraseMenu := ClassPhraseMenu(myPhrases)
phraseMenu.RunByShortcut("b1")
phraseMenu.RunByShortcut("pp")
phraseMenu.RunByShortcut("zf")
phraseMenu.Show()

^f:: {
  phraseMenu.Show()
}

::b1::
::;b2::
::;zf:: {
  phraseMenu.RunByShortcut(A_ThisHotkey)
}
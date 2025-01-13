; --------------------
; Example usage
; --------------------
#SingleInstance Force
#Include ClassOrderedMap.ahk
#Include ClassPhrase.ahk
#Include ClassPhraseMenu.ahk

phraseMenu := ClassPhraseMenu()

phraseMenu.AddPhrase("p", "Prompt")
phraseMenu.AddPhrase("pa", "Prompt A")
phraseMenu.AddPhrase("pb", "Prompt B")
phraseMenu.AddPhrase("p-0") ; sperator
phraseMenu.AddPhrase("pc", "Prompt B")
phraseMenu.AddPhrase("pd", "Prompt B")

phraseMenu.AddPhrase("-0") ; sperator

phraseMenu.AddPhrase("w", "Web")
phraseMenu.AddPhrase("wg", "Google", "https://www.google.com")
phraseMenu.AddPhrase("wy", "YouTube", "https://www.youtube.com")

phraseMenu.AddPhrase("-1") ; sperator

phraseMenu.AddPhrase("n", "Open Notepad", () => Run("notepad.exe"))
phraseMenu.AddPhrase("e", "Press Win+E", () => Send("#e"))
phraseMenu.AddPhrase("m", "Show MsgBox", () => MsgBox("Function callback!"))

^!f:: {
  phraseMenu.Show()
}

for k, v in phraseMenu.phraseShortcutMap {
  if (InStr(k, '-') || k == '') {
    continue
  }
  Hotstring("::" . k, (*) => (
    phraseMenu.RunByShortcut(SubStr(A_ThisHotkey, 3))
  ))
}
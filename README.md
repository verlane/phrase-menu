# AHK Phrase Menu

A dynamic **AutoHotkey** menu system that allows you to organize and run various actions such as:
- Copying text snippets to the clipboard
- Opening URLs in your default browser
- Executing callback functions

## Features

- **Nested Menus**: Easily create submenus for better organization.
- **Shortcut Keys**: Dynamically assign single-key or multi-key shortcuts (e.g., `b1`, `pp`, `zf`) to quickly run actions.
- **Versatile Actions**
  1. **Text**: Copy text to the clipboard and paste it.
  2. **URL**: Open a website in the default browser.
  3. **Callback**: Execute a user-defined function on click.

## Example

Below is a fully working example showing how to use the classes:

```autohotkey
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
phraseMenu.AddPhrase("-")
phraseMenu.AddPhrase("w", "Web")
phraseMenu.AddPhrase("wg", "Google", "https://www.google.com")
phraseMenu.AddPhrase("wy", "YouTube", "https://www.youtube.com")
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
```

## How It Works

### ClassPhrase
- Stores a body (text, URL, or function) and an optional title.
- Decides how to handle the action when `Run()` is called.

### ClassPhraseMenu
- Dynamically converts your list of `ClassPhrase` objects into an AutoHotkey menu.
- Allows calling `RunByShortcut("pa")` to trigger the matching phrase.

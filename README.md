# AHK Phrase Menu

A dynamic **AutoHotkey** menu system that allows you to organize and run various actions such as:  
- Copying text snippets to the clipboard  
- Opening URLs in your default browser  
- Running external commands or programs  
- Sending custom AHK keystrokes  
- Executing callback functions  

## Features

- **Nested Menus**: Easily create submenus for better organization.  
- **Shortcut Keys**: Dynamically assign single-key or multi-key shortcuts (e.g., `b1`, `pp`, `zf`) to quickly run actions.  
- **Versatile Actions**  
  1. **Text**: Copy text to the clipboard and paste it.  
  2. **URL**: Open a website in the default browser.  
  3. **Command**: Run external programs or commands.  
  4. **AHK**: Send AHK keystrokes.  
  5. **Callback**: Execute a user-defined function on click.

## Installation

1. Make sure you have [AutoHotkey](https://www.autohotkey.com/) installed.  
2. Copy both **ClassPhrase.ahk** and **ClassPhraseMenu.ahk** into your project, or include their code directly.  
3. Reference them in your main script.

## Example

Below is a fully working example showing how to use the classes:

```autohotkey
; -----------------------------------
; Include or paste ClassPhrase and ClassPhraseMenu definitions above this section.
; -----------------------------------

; p => shorthand for ClassPhrase
p := ClassPhrase

; Build your phrase list
myPhrases := [
  p("&B Banking"), [
    p("Bank A"),  ; Copies "Bank A" to clipboard
    p("Bank B"),  ; Copies "Bank B" to clipboard
    p("https://www.bankC.com", "Bank C"), ; Opens URL in browser
    p("SubMenu"), [
      p("Check Balance"),   
      p("Transfer Funds"),  
    ]
  ],
  p("&P Prompts"), [
    p("&P Example Prompt`n`n"), ; Copies multiline text
    p("Another Prompt"),        
  ],
  p("&W Web"), [
    p("https://www.youtube.com", "&Y YouTube"),  
    p("https://www.google.com", "&G Google"),    
    p("notepad.exe", "&N Open Notepad", ClassPhrase.TYPE_COMMAND), 
  ],
  p("!r", "&R Press Alt+R", ClassPhrase.TYPE_AHK), ; Sends Alt+R
  p(""),  ; Empty => menu separator
  p("&Z Test"), [
    p("Simple text snippet", "Sample Text"),
    p(() => MsgBox("Function callback!"), "&F Show MsgBox"),
  ],
  p(() => ExitApp(), "&X Exit")
]

; Create the menu from the phrase list
phraseMenu := ClassPhraseMenu(myPhrases)

; Optionally run some items by shortcuts
phraseMenu.RunByShortcut("b1")  ; Possibly runs "&b &1"
phraseMenu.RunByShortcut("pp")  ; Possibly runs "&p &p"
phraseMenu.RunByShortcut("zf")  ; Possibly runs "&z &f"

; Show the top-level menu
phraseMenu.Show()

; Show the top-level menu by shortcut
^f:: {
  phraseMenu.Show()
}

; Optional: Use hotstrings to run shortcuts
::b1::
::;b2::
::;zf:: {
  phraseMenu.RunByShortcut(A_ThisHotkey)
}
```

## How It Works

1. ClassPhrase

  * Stores a body (text, URL, command, AHK keystrokes, or function) and an optional title.
  * Decides how to handle the action when Run() is called.

2. ClassPhraseMenu

  * Dynamically converts your list of ClassPhrase objects into an AutoHotkey menu.
  * Extracts shortcuts from titles (e.g., &B in "&B Banking") or assigns them automatically.
  * Allows calling RunByShortcut("b1") to trigger the matching phrase.
; --------------------
; PhraseMenu Class
; Author: BSB
; --------------------
Class ClassPhraseMenu {
  __New() {
    this.topPhrase := ClassPhrase()
    this.phraseShortcutMap := Map()
    this.myMenu := ""
  }

  Show(x := "", y := "") {
    if (!this.myMenu) {
      this.myMenu := this.CreateMenuFromOrderedMap(this.topPhrase)
    }
    if (x && y) {
      this.myMenu.Show(x, y)
    } else {
      this.myMenu.Show()
    }
  }

  AddPhrase(key, title := "", body := "", isExecutable := false, iconFile := "", iconNumber := 0) {
    key := Trim(key)
    keyParts := StrSplit(key, "")
    phrase := ClassPhrase(title, body, isExecutable, iconFile, iconNumber)
    this.phraseShortcutMap[key] := phrase
    this.AddToOrderedMapRecursive(this.topPhrase, keyParts, phrase)
    this.myMenu := ""
  }

  RunByShortcut(shortcut, x := "", y := "") {
    if (this.phraseShortcutMap.Has(shortcut)) {
      phrase := this.phraseShortcutMap[shortcut]
      if (phrase.keys.Length < 1 || phrase.isExecutable) {
        phrase.Run()
        return
      }
    }

    this.ExecScript('Sleep(300)`nSend("' . shortcut . '")')
    this.Show(x, y)
  }

  ExecScript(script, wait := false) {
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(A_AhkPath " /ErrorStdOut *")
    exec.StdIn.Write("#NoTrayIcon`n" . script)
    exec.StdIn.Close()
    if wait
      return exec.StdOut.ReadAll()
  }

  AddToOrderedMapRecursive(myOrderedMap, keyParts, message) {
    if (keyParts.Length == 0) {
      return
    }

    str := ""
    for i, value in keyParts {
      str .= value
    }
    if (RegExMatch(str, "^\-")) {
      myOrderedMap.Set(str, ClassPhrase())
      return
    }

    currentKey := keyParts.RemoveAt(1)
    if (keyParts.Length == 0) {
      myOrderedMap.Set(currentKey, message)
    } else {
      if !myOrderedMap.Has(currentKey) {
        myOrderedMap.Set(currentKey, ClassPhrase())
      }
      this.AddToOrderedMapRecursive(myOrderedMap.Get(currentKey), keyParts, message)
    }
  }

  StrRepeat(str, count) {
    result := ""
    Loop count {
      result .= str
    }
    return result
  }

  StrShrink(t) {
    return (StrLen(t) > 60) ? SubStr(t, 1, 60) . "..." : t
  }

  CreateMenuFromOrderedMap(orderedMap, prefix := "") {
    myMenu := Menu()
    orderedMap.ForEach((key, phrase) => this.CreateMenuEntry(myMenu, key, phrase, prefix))
    return myMenu
  }

  CreateMenuEntry(myMenu, key, phrase, prefix := "") {
    if (RegExMatch(key, "^\-")) {
      myMenu.Add("")
      return
    }

    fullKey := prefix . key
    titleShrink := this.StrShrink(phrase.title)
    menuItemName := this.BuildMenuItemName(key, titleShrink)

    if (phrase.keys.Length > 0) {
      subMenu := this.CreateMenuFromOrderedMap(phrase, fullKey)
      if (phrase.isExecutable) {
        subMenu.Add("")
        runItemName := this.BuildRunItemName(fullKey)
        subMenu.Add(runItemName, (*) => phrase.Run())
      }
      myMenu.Add(menuItemName, subMenu)
    } else {
      myMenu.Add(menuItemName, (*) => phrase.Run())
    }

    if (phrase.iconFile) {
      myMenu.SetIcon(menuItemName, phrase.iconFile, phrase.iconNumber)
    }
  }

  BuildMenuItemName(key, titleShrink) {
    if (InStr(titleShrink, StrUpper(key), true)) {
      return StrReplace(titleShrink, StrUpper(key), "&" . StrUpper(key), true, , 1)
    }
    if (InStr(titleShrink, StrLower(key), true)) {
      return StrReplace(titleShrink, StrLower(key), "&" . StrLower(key), true, , 1)
    }
    return titleShrink . " (&" . key . ")"
  }

  BuildRunItemName(fullKey) {
    return "상위 항목 실행"
  }
}

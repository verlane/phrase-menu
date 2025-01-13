; --------------------
; PhraseMenu Class
; Author: BSB
; --------------------
Class ClassPhraseMenu {
  __New() {
    this.topPhrase := ClassPhrase()
    this.phraseShortcutMap := Map()
  }

  Show() {
    this.myMenu := this.CreateMenuFromOrderedMap(this.topPhrase)
    this.myMenu.Show()
  }

  AddPhrase(key, title := "", body := "") {
    key := Trim(key)
    keyParts := StrSplit(key, "")
    phrase := ClassPhrase(title, body)
    this.phraseShortcutMap[key] := phrase
    this.AddToOrderedMapRecursive(this.topPhrase, keyParts, phrase)
  }

  RunByShortcut(shortcut) {
    if (this.phraseShortcutMap.Has(shortcut)) {
      phrase := this.phraseShortcutMap[shortcut]
      if (phrase.keys.Length < 1) {
        phrase.Run()
        return
      }
    }

    this.ExecScript("Sleep(50)`nSend('" . shortcut . "')")
    this.Show()
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
    if (RegExMatch(str, "^\-")) { ; for seperator
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
    return (StrLen(t) > 30) ? SubStr(t, 1, 30) . "..." : t
  }

  CreateMenuFromOrderedMap(orderedMap) {
    myMenu := Menu()
    orderedMap.ForEach((key, phrase) => this.CreateMenuEntry(myMenu, key, phrase))
    return myMenu
  }

  CreateMenuEntry(myMenu, key, phrase) {
    if (phrase.keys.Length > 0) {
      subMenu := this.CreateMenuFromOrderedMap(phrase)
      myMenu.Add("&" . key . " " . this.StrShrink(phrase.title), subMenu)
    } else {
      if (RegExMatch(key, "^\-")) {
        myMenu.Add("")
      } else {
        myMenu.Add("&" . key . " " . this.StrShrink(phrase.title), (*) => phrase.Run())
      }
    }
  }
}
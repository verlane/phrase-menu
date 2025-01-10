; --------------------
; PhraseMenu Class
; Author: BSB
; --------------------
Class ClassPhraseMenu {
  __New(phraseList) {
    this.topMenu := Menu()
    this.phraseMenuMap := Map()
    this.phraseShortcutMap := Map()
    ; Build menu
    this.AddMenuItems(this.topMenu, phraseList)
  }

  ; Show top-level menu
  Show() {
    this.topMenu.Show()
  }

  ; Run item by typed shortcut (e.g., "b1" -> "&b &1")
  RunByShortcut(shortcut) {
    shortcut := RegExReplace(StrLower(shortcut), "[^a-zA-Z0-9]", "")
    local converted := ""
    for i, ch in StrSplit(shortcut)
      converted .= "&" . ch . " "
    if (this.phraseShortcutMap.Has(converted)) {
      this.phraseShortcutMap[converted].Run()
    } else {
      MsgBox "Shortcut not found: " . converted
    }
  }

  ; Recursively build menu/submenu
  AddMenuItems(targetMenu, items, level := 1, accumKey := "") {
    local shortcuts := StrSplit("zyxwvutsrqponmlkjihgfedcba0987654321")

    for i, item in items {
      nextItem := (i < items.Length) ? items[i + 1] : ""
      prevItem := (i > 1) ? items[i - 1] : ""

      if (level = 1)
        accumKey := ""

      if (!this.IsArrayType(item) && this.IsArrayType(nextItem)) {
        continue
      } else if this.IsArrayType(item) {
        sub := Menu()
        sc := this.GetShortcut(shortcuts, prevItem.title)
        accumKey .= sc
        this.AddMenuItems(sub, item, level + 1, accumKey)
        targetMenu.Add(sc . this.ShrinkTitle(prevItem.title), sub)
      } else {
        if (item.title = "") {
          targetMenu.Add("") ; separator
        } else {
          sc := this.GetShortcut(shortcuts, item.title)
          key := StrLower(accumKey . sc)
          this.phraseShortcutMap[key] := item
          targetMenu.Add(sc . this.ShrinkTitle(item.title), ObjBindMethod(this, "OnMenuItemClick"))
        }
        if !this.phraseMenuMap.Has(targetMenu.Handle)
          this.phraseMenuMap[targetMenu.Handle] := []
        this.phraseMenuMap[targetMenu.Handle].Push(item)
      }
    }
  }

  OnMenuItemClick(item, index, myMenu, *) {
    local items := this.phraseMenuMap[myMenu.Handle]
    if (index <= items.Length) {
      items[index].Run()
    }
  }

  IsArrayType(o) {
    return (Type(o) = "Array")
  }

  ShrinkTitle(t) {
    t := (StrLen(t) > 30) ? SubStr(t, 1, 30) . "..." : t
    return RegExReplace(t, "^`&([A-Za-z0-9]) ")
  }

  GetShortcut(shortcuts, title) {
    if (RegExMatch(title, "^`&([A-Za-z0-9]) ", &m)) {
      for i, v in shortcuts {
        if (v = m[1]) {
          shortcuts.RemoveAt(i)
          break
        }
      }
      return m[0]
    }
    return (shortcuts.Length > 0) ? "&" . shortcuts.Pop() . " " : ""
  }
}
; --------------------
; Phrase Class
; Author: BSB
; --------------------
Class ClassPhrase extends ClassOrderedMap {
  static className := "ClassPhrase"

  __New(title := "", body := "") {
    Super()
    this.title := title
    this.body := (body = "") ? title : body
  }

  Run() {
    if (Type(this.body) == "Func" || Type(this.body) == "Closure") {
      this.body.Call()
      return
    }

    if (RegExMatch(this.body, "i)^https?://")) {
      Run(this.body)
    } else {
      A_Clipboard := this.body
      ClipWait
      Send("^v")
    }
  }
}
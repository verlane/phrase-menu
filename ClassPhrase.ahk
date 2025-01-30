; --------------------
; Phrase Class
; Author: BSB
; --------------------
Class ClassPhrase extends ClassOrderedMap {
  static className := "ClassPhrase"

  __New(title := "", body := "", iconFile := "", iconNumber := 0) {
    Super()
    this.title := title
    this.body := (body = "") ? title : body
    this.iconFile := iconFile
    this.iconNumber := iconNumber
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
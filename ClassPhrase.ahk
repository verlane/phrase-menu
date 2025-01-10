; --------------------
; Phrase Class
; Author: BSB
; --------------------
Class ClassPhrase {
  static TYPE_TEXT := "TEXT"
  static TYPE_COMMAND := "COMMAND"
  static TYPE_AHK := "AHK"

  __New(body, title := "", type := ClassPhrase.TYPE_TEXT) {
    this.body := body
    this.title := (title = "") ? this.body : title
    this.type := type
  }

  Run() {
    ; If it's a function, call it
    if (Type(this.body) = "Func") {
      this.body.Call()
      return
    }
    ; Otherwise process as text/command/AHK
    body := RegExReplace(this.body, "^\&[A-Za-z0-9] ", "")
    if (this.type = ClassPhrase.TYPE_TEXT) {
      if (RegExMatch(body, "i)^https?://")) {
        Run(body)
      } else {
        A_Clipboard := body
        ClipWait
        Send("^v")
      }
    } else if (this.type = ClassPhrase.TYPE_COMMAND) {
      Run(body)
    } else if (this.type = ClassPhrase.TYPE_AHK) {
      Send(body)
    }
  }
}
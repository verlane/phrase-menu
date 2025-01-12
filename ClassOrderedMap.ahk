; --------------------
; OrderedMap Class
; Author: BSB
; --------------------
class ClassOrderedMap {
  __New() {
    this.Call()
  }

  Call() {
    this.keys := []
    this.myMap := Map()
  }

  Set(key, value) {
    if (!this.myMap.Has(key)) {
      this.keys.Push(key)
    }
    this.myMap[key] := value
  }

  Get(key) {
    return this.myMap.Has(key) ? this.myMap[key] : ""
  }

  Has(key) {
    return this.myMap.Has(key)
  }

  Delete(key) {
    if (this.myMap.Has(key)) {
      for i, v in this.keys {
        if (v = key) {
          this.keys.RemoveAt(i)
          break
        }
      }
      this.myMap.Delete(key)
    }
  }

  ForEach(callback) {
    for key in this.keys {
      callback(key, this.myMap[key])
    }
  }
}
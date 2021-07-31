pub struct Canvas {

  pub let width: UInt8
  pub let height: UInt8
  pub let pixels: String

  init(width: UInt8, height: UInt8, pixels: String) {
    self.width = width
    self.height = height
    // The following pixels
    // 123
    // 456
    // 789
    // should be serialized as
    // 123456789
    self.pixels = pixels
  }
}

pub fun serializeStringArray(_ lines: [String]): String {
  var buffer = ""
  for line in lines {
    buffer = buffer.concat(line)
  }

  return buffer
}

// pub fun addLine(text: String):String{
//   var newText = ""
//   newText = text.concat("|")
//   return newText
// }

pub fun display(canvas: Canvas){
  let border = "+-----+"
  let line = "|"
  
  log(border)
  log(line.concat(canvas.pixels.slice(from: 0, upTo: 5).concat(line))) 
  log(line.concat(canvas.pixels.slice(from: 5, upTo: 10).concat(line)))
  log(line.concat(canvas.pixels.slice(from: 10, upTo: 15).concat(line))) 
  log(line.concat(canvas.pixels.slice(from: 15, upTo: 20).concat(line))) 
  log(line.concat(canvas.pixels.slice(from: 20, upTo: 25).concat(line))) 
  log(border)
}

pub resource Picture {

  pub let canvas: Canvas
  
  init(canvas: Canvas) {
    self.canvas = canvas
  }
}

pub fun main() {
  let pixelsX = [
    "*   *",
    " * * ",
    "  *  ",
    " * * ",
    "*   *"
  ]
  let canvasX = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray(pixelsX)
  )
 
  let letterX <- create Picture(canvas: canvasX)
  log(letterX.canvas)
  display(canvas: canvasX)
  destroy letterX
}
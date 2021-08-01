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

pub resource Printer {
  pub let existList: [String] 

  init(existList:[String]){
    self.existList = existList
  }
  
  pub fun print(canvas: Canvas): @Picture? {
    if self.existList.contains(canvas.pixels) == false {
      // unique
      let picture <- create Picture(canvas: canvas)
      display(canvas: picture.canvas)
      self.existList.append(canvas.pixels)
      return <- picture
    }else
    {
      log("canvas duplicate")
      return nil
    }
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
  
  log("W1Q1")
  // let letterX <- create Picture(canvas: canvasX)
  // log(letterX.canvas)

  display(canvas: canvasX)
 

  log("W1Q2")
  let printer <- create Printer(existList:[""])
  let picture1 <- printer.print(canvas: canvasX)
  let picture2 <- printer.print(canvas: canvasX)
  destroy printer
  destroy picture1
  destroy picture2
  // destroy letterX

}
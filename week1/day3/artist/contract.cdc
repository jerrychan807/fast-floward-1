pub contract Artist {

  pub event PicturePrintSuccess(pixels: String)
  pub event PicturePrintFailure(pixels: String)
  pub event PicturePrintLengthFailure(pixels: String)

  pub struct Canvas {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
      self.width = width
      self.height = height
      self.pixels = pixels
    }
  }

  pub resource Collection {

    pub let pictures: @[Picture]

    init() {
      self.pictures <- []
    }

    pub fun deposit(picture: @Picture){
      self.pictures.append(<- picture)
    }

    pub fun getCanvases(): [Canvas] {
      var canvases: [Canvas] = []
      var index = 0

      while index < self.pictures.length {
        canvases.append(
          self.pictures[index].canvas
          )
        index = index + 1
      }
      return canvases
      }

    destroy() {
      destroy self.pictures
    }
}
  pub fun createCollection(): @Collection {
    return <- create Collection()
  }

  pub resource Picture {
    pub let canvas: Canvas
    
    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }

  pub resource Printer {
    pub let width: UInt8
    pub let height: UInt8
    pub let prints: {String: Canvas}

    init(width: UInt8, height: UInt8) {
      self.width = width;
      self.height = height;
      self.prints = {}
    }

    pub fun print(canvas: Canvas): @Picture? {
      // Canvas needs to fit Printer's dimensions.
      if canvas.pixels.length != Int(self.width * self.height) {
        emit PicturePrintLengthFailure(pixels: canvas.pixels)
        return nil
      }

      // Printer is only allowed to print unique canvases.
      if self.prints.containsKey(canvas.pixels) == false {
        log("printing new picture")
        let picture <- create Picture(canvas: canvas)
        self.prints[canvas.pixels] = canvas
        emit PicturePrintSuccess(pixels: canvas.pixels)
        return <- picture
      } else {
        emit PicturePrintFailure(pixels: canvas.pixels)
        log("picture exists")
        return nil
      }
    }

    pub fun display(canvas: Canvas): String{
      let border = "+-----+"
      let line = "|"
      var formatPicture: String = "" 
      log(border)
      
      log(line.concat(canvas.pixels.slice(from: 0, upTo: 5).concat(line))) 
      log(line.concat(canvas.pixels.slice(from: 5, upTo: 10).concat(line)))
      log(line.concat(canvas.pixels.slice(from: 10, upTo: 15).concat(line))) 
      log(line.concat(canvas.pixels.slice(from: 15, upTo: 20).concat(line))) 
      log(line.concat(canvas.pixels.slice(from: 20, upTo: 25).concat(line))) 
      log(border)

      formatPicture.concat(border)
      formatPicture.concat(line.concat(canvas.pixels.slice(from: 0, upTo: 5).concat(line)))
      formatPicture.concat(line.concat(canvas.pixels.slice(from: 5, upTo: 10).concat(line)))
      formatPicture.concat(line.concat(canvas.pixels.slice(from: 10, upTo: 15).concat(line)))
      formatPicture.concat(line.concat(canvas.pixels.slice(from: 15, upTo: 20).concat(line)))
      formatPicture.concat(line.concat(canvas.pixels.slice(from: 20, upTo: 25).concat(line)))
      formatPicture.concat(border)
      return formatPicture
    }
    
  }

  init() {
    self.account.save(
      <- create Printer(width: 5, height: 5),
      to: /storage/ArtistPicturePrinter
    )
    self.account.link<&Printer>(
      /public/ArtistPicturePrinter,
      target: /storage/ArtistPicturePrinter
    )
  }
}
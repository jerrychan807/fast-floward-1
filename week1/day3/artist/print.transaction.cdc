import Artist from "./contract.cdc"

// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: UInt8, height: UInt8, pixels: String) {
  
  let pixels: String
  let picture: @Artist.Picture?
  let collectionRef: &Artist.Collection

  prepare(account: AuthAccount) {
    let printerRef = getAccount(0x01cf0e2f2f715450)
      .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
      .borrow()
      ?? panic("Couldn't borrow printer reference.")

      self.collectionRef = account
        .getCapability(/public/ArtistPictureCollection)
        .borrow<&Artist.Collection>()
        ?? panic("couldn't borrow collection reference")
    
    // Replace with your own drawings.
    self.pixels = pixels
    let canvas = Artist.Canvas(
      width: width,
      height: height,
      pixels: self.pixels
    )
    
    self.picture <- printerRef.print(canvas: canvas)
  }

  execute {
    if (self.picture == nil) {
      log("Picture with ".concat(self.pixels).concat(" already exists! can't print for dublicate canvas"))
      destroy self.picture
    } else {
      log("Picture printed!")
    //   destroy self.picture
      self.collectionRef.deposit(picture: <- self.picture!)
    }
  }
}

import Artist from 0x02

pub fun main() {
  let accounts = [getAccount(0x01), getAccount(0x02), getAccount(0x03), getAccount(0x04), getAccount(0x05)]

  let printerRef = getAccount(0x02)
                  .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
                  .borrow()
                  ?? panic("Couldn't borrow printer reference.")

  for account in accounts{
    let collectionRef = account
    .getCapability(/public/ArtistPictureCollection)
    .borrow<&Artist.Collection>()

    //log(collectionRef)

    if collectionRef == nil {
        log("account".concat(account.address.toString()).concat("dont have a picture"))      
    }else {
        log("account's".concat(account.address.toString()).concat(" pictures"))

        for canvas in collectionRef!.getCanvases(){
            log("account".concat(account.address.toString()))
            printerRef.display(canvas: canvas)
            
        }
    }
  }
}

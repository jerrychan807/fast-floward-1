import Artist from "./contract.cdc"

// Create a Picture Collection for the transaction authorizer.
transaction {
    prepare(account: AuthAccount) {
        let collection <- Artist.createCollection()
        account.save(
            <- collection,
            to: /storage/ArtistPictureCollection
        )
        account.link<&Artist.Collection>(
            /public/ArtistPictureCollection,
            target: /storage/ArtistPictureCollection
        )
    }
}
public class  Product  : Codable, Identifiable {
    internal init(id: Int, name: String, description: String, image: String, price: Int, sellerId: Int, categoryName: String, numberOfViews: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.price = price
        self.sellerId = sellerId
        self.categoryName = categoryName
        self.numberOfViews = numberOfViews
    }
    
   
    public let id : Int
    let name : String
    let description : String
    let image : String
    let price : Int
    let sellerId : Int
    let categoryName : String
    var numberOfViews : Int
}

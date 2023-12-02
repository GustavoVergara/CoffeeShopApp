public struct DraftOrderProduct: Codable, Hashable {
    public var id: String
    public var name: String
    public var imageURL: String?
    public var sku: DraftOrderSKU
    public var quantity: Int
    
    public init(id: String, name: String, imageURL: String?, sku: DraftOrderSKU, quantity: Int) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.sku = sku
        self.quantity = quantity
    }
}

public struct DraftOrderSKU: Codable, Hashable {
    public var id: String
    public var price: Double
    public var attributes: [String: String]
    
    public init(id: String, price: Double, attributes: [String : String]) {
        self.id = id
        self.price = price
        self.attributes = attributes
    }
}

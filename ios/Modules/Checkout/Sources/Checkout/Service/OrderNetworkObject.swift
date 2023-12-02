import Foundation

struct OrderNetworkObject: Codable {
    var user: UserNetworkObject
    var skus: [SKUNetworkObject]
}

struct UserNetworkObject: Codable {
    var id: String
    var name: String
}

struct SKUNetworkObject: Codable {
    var productID: String
    var skuID: String
    var productName: String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case skuID = "sku_id"
        case productName = "product_name"
    }
}

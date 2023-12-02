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

struct PlaceOrderResponse: Codable {
    var orderID: String
    var date: Date
    var expectedDeliveryDate: Date
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case date
        case expectedDeliveryDate = "expected_delivery_date"
    }
}

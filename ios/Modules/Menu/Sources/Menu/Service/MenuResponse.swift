import Foundation

struct MenuResponse: Codable, Hashable {
    var storeID: String
    var storeName: String
    var products: [ProductResponse]
    
    struct ProductResponse: Codable, Identifiable, Hashable {
        var id: String
        var name: String
        var description: String
        var photo: String
        var skus: [SKUResponse]
        var allAttributes: [AttributeResponse]
    }
    
    struct SKUResponse: Codable, Hashable {
        var id: String
        var price: Double
        var attributes: [String: String]
    }
    
    struct AttributeResponse: Codable, Hashable {
        var key: String
        var description: String
    }
}

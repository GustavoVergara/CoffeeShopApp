import Foundation

struct MenuResponse: Codable, Hashable {
    var storeID: String
    var storeName: String
    var products: [ProductResponse]
    
    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case storeName = "store_name"
        case products
    }
    
    struct ProductResponse: Codable, Identifiable, Hashable {
        var id: String
        var name: String
        var description: String
        var photo: String?
        var skus: [SKUResponse]
        var allAttributes: [AttributeResponse]
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case description
            case photo
            case skus
            case allAttributes = "all_attributes"
        }
    }
    
    struct SKUResponse: Codable, Hashable {
        var id: String
        var price: Double
        var attributes: [String: String]
    }
    
    struct AttributeResponse: Codable, Hashable {
        var key: String
        var name: String
    }
}

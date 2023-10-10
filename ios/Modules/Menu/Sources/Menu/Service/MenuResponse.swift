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
}

struct SKUResponse: Codable, Hashable {
    var id: String
    var price: Double
    var attributes: [String: String]
    
    func displayPrice(formatter: NumberFormatter = .brlCurrencyFormatter) -> String? {
        formatter.string(for: price)
    }
}

struct AttributeResponse: Codable, Hashable {
    var key: String
    var name: String
}

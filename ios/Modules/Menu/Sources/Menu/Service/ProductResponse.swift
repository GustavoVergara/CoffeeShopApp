import Foundation

struct ProductResponse: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var description: String
    var photo: String?
    var skus: [SKUResponse]
    var allAttributes: [AttributeResponse]
    
    var basePrice: Double? {
        skus.min(by: { $0.price < $1.price })?.price
    }
    
    var hasDifferentPrices: Bool {
        guard let firstSKUPrice = skus.first?.price else {
            return false
        }
        return skus.dropFirst().contains(where: { $0.price != firstSKUPrice })
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case photo
        case skus
        case allAttributes = "all_attributes"
    }
}

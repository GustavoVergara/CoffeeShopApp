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

protocol ProductFormatting {
    func displayPrice(of product: ProductResponse) -> String
}

struct ProductFormatter: ProductFormatting {
    var currencyFormatter = NumberFormatter.brlCurrencyFormatter
    
    func displayPrice(of product: ProductResponse) -> String {
        var minPrice: Double?
        var hasHigherPrices = false
        for sku in product.skus {
            guard let currentMinPrice = minPrice, currentMinPrice != sku.price else {
                minPrice = sku.price
                continue
            }
            
            minPrice = min(currentMinPrice, sku.price)
            hasHigherPrices = true
        }
        
        guard let minPrice else {
            return "??"
        }
        
        if hasHigherPrices {
            return "apartir de \(currencyFormatter.string(for: minPrice) ?? "??")"
        } else {
            return currencyFormatter.string(for: minPrice) ?? "??"
        }
    }
}

extension NumberFormatter {
    static let brlCurrencyFormatter = {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "BRL"
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }()
}

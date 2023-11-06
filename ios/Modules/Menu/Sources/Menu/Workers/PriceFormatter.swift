import Foundation

protocol PriceFormatting {
    func displayPrice(_ price: Double?, hasHigherPrices: Bool) -> String
    func minimunDisplayPrice(in skus: [SKUResponse]) -> String
}

extension PriceFormatting {
    func displayPrice(_ price: Double?) -> String {
        displayPrice(price, hasHigherPrices: false)
    }
}

struct PriceFormatter: PriceFormatting {
    let formatter = NumberFormatter.brlCurrencyFormatter
    
    func displayPrice(_ price: Double?, hasHigherPrices: Bool) -> String {
        guard let price else { return "??" }
        if hasHigherPrices {
            return "apartir de \(formatter.string(for: price) ?? "??")"
        } else {
            return formatter.string(for: price) ?? "??"
        }
    }
    
    func minimunDisplayPrice(in skus: [SKUResponse]) -> String {
        var minPrice: Double?
        var hasHigherPrices = false
        for sku in skus {
            guard let currentMinPrice = minPrice, currentMinPrice != sku.price else {
                minPrice = sku.price
                continue
            }
            
            minPrice = min(currentMinPrice, sku.price)
            hasHigherPrices = true
        }
        
        return displayPrice(minPrice, hasHigherPrices: hasHigherPrices)
    }
}


import Core

extension PriceFormatting {
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

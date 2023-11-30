import SwiftUI
import Core
import OrderLibrary

class CartViewModel: ObservableObject, CartPresenting {
    @Published
    var items: [CartItemData] = []
    
    @Published
    var totalPrice: String = ""
    
    private let priceFormatter: PriceFormatting
    
    init(priceFormatter: PriceFormatting = PriceFormatter()) {
        self.priceFormatter = priceFormatter
    }
    
    func displayItems(_ products: [DraftOrderProduct]) {
        items = products.map({
            return CartItemData(productID: $0.id,
                                skuID: $0.sku.id,
                                image: $0.imageURL.flatMap(URL.init(string:)).map { CoreImage.url($0) } ?? .system("cup.and.saucer.fill"),
                                name: $0.name,
                                price: priceFormatter.displayPrice($0.sku.price),
                                quantity: $0.quantity)
        })
        
        let total = products.reduce(0, { $0 + $1.sku.price })
        totalPrice = priceFormatter.displayPrice(total)
    }
}

struct CartItemData: Identifiable {
    var id: Int {
        var hasher = Hasher()
        hasher.combine(productID)
        hasher.combine(skuID)
        return hasher.finalize()
    }
    var productID: String
    var skuID: String
    var image: CoreImage
    var name: String
    var price: String
    var quantity: Int
}

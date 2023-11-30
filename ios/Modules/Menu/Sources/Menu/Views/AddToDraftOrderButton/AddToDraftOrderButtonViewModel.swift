import SwiftUI
import Core

final class AddToDraftOrderButtonViewModel: ObservableObject, AddToDraftOrderPresenting {
    @Published var currentDisplayPrice: String
    @Published var selectedQuantity: Int
    @Published var canAddToDraftOrder: Bool
    
    private let priceFormatter: PriceFormatting
    
    init(
        priceFormatter: PriceFormatting = PriceFormatter(),
        currentPrice: Double?,
        selectedQuantity: Int,
        canAddToDraftOrder: Bool
    ) {
        self.priceFormatter = priceFormatter
        self.currentDisplayPrice = priceFormatter.displayPrice(currentPrice)
        self.selectedQuantity = selectedQuantity
        self.canAddToDraftOrder = canAddToDraftOrder
    }
    
    func displayQuantity(_ quantity: Int) {
        selectedQuantity = quantity
    }
    
    func displayPrice(_ price: Double) {
        currentDisplayPrice = priceFormatter.displayPrice(price)
    }
    
    func enableAddToDraftOrder(_ enabled: Bool) {
        canAddToDraftOrder = enabled
    }
}

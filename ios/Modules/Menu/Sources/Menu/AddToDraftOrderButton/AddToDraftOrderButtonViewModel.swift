import SwiftUI

final class AddToDraftOrderButtonViewModel: ObservableObject, AddToDraftOrderPresenting {
    func displayQuantity(_ quantity: Int) {
        selectedQuantity = quantity
    }
    
    func displayPrice(_ price: String) {
        currentDisplayPrice = price
    }
    
    @Published var currentDisplayPrice: String
    @Published var selectedQuantity: Int
    
    init(currentDisplayPrice: String, selectedQuantity: Int) {
        self.currentDisplayPrice = currentDisplayPrice
        self.selectedQuantity = selectedQuantity
    }
}

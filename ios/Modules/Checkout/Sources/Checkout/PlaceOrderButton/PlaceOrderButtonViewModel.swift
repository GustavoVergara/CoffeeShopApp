import SwiftUI
import Core

protocol PlaceOrderPresenter {
    func updateTotalPrice(to totalPrice: Double)
    func showConfirmation(errorMessage: String?)
    func updateUserName(_ userName: String)
}

class PlaceOrderButtonViewModel: ObservableObject, PlaceOrderPresenter {
    let priceFormatter: PriceFormatting = PriceFormatter()
    
    @Published
    var totalPrice: String = ""
    @Published
    var isConfirmationPresented = false
    var confirmationMessage = PlaceOrderButtonViewModel.defaultConfirmationMessage
    
    @Published
    var userName: String = ""
    
    func updateTotalPrice(to totalPrice: Double) {
        self.totalPrice = priceFormatter.displayPrice(totalPrice)
    }
    
    func showConfirmation(errorMessage: String?) {
        if let errorMessage {
            confirmationMessage = Self.defaultConfirmationMessage + "\n\n" + errorMessage
        } else {
            confirmationMessage = Self.defaultConfirmationMessage
        }
        isConfirmationPresented = true
    }
    
    func updateUserName(_ userName: String) {
        self.userName = userName
    }
    
    private static let defaultConfirmationMessage = "Seu nome será usado para te chamar quando seu pedido estiver pronto :)"
}

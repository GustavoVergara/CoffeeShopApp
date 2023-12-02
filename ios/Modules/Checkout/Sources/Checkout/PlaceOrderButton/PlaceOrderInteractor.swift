import Foundation
import Combine
import OrderLibrary

protocol PlaceOrderInteracting {
    func didPressPlaceOrder()
    func didConfirmOrder(name: String)
}

class PlaceOrderInteractor: PlaceOrderInteracting {
    let draftOrderTotalStream: DraftOrderTotalStreaming
    let presenter: PlaceOrderPresenter
    private var cancellables = Set<AnyCancellable>()
    
    init(draftOrderTotalStream: DraftOrderTotalStreaming, presenter: PlaceOrderPresenter) {
        self.draftOrderTotalStream = draftOrderTotalStream
        self.presenter = presenter
        
        draftOrderTotalStream.publisher().sink { totalPrice in
            presenter.updateTotalPrice(to: totalPrice)
        }.store(in: &cancellables)
    }
    
    func didPressPlaceOrder() {
        presenter.showConfirmation(errorMessage: nil)
    }
    
    func didConfirmOrder(name: String) {
        guard !name.isEmpty else {
            DispatchQueue.main.async { [weak self] in
                self?.presenter.showConfirmation(errorMessage: "Por favor preencher com nome válido.")
            }
            return
        }
    }
}

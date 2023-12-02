import Foundation
import Combine
import OrderLibrary

protocol PlaceOrderInteracting {
    func didPressPlaceOrder()
    func didConfirmOrder(name: String) async
}

class PlaceOrderInteractor: PlaceOrderInteracting {
    let draftOrderStream: any DraftOrderStreaming
    let draftOrderTotalStream: DraftOrderTotalStreaming
    let mutableUserSessionStream: MutableUserSessionStreaming
    let checkoutNetworker: CheckoutNetworking
    let presenter: PlaceOrderPresenter
    private var cancellables = Set<AnyCancellable>()
    
    init(
        draftOrderStream: any DraftOrderStreaming,
        draftOrderTotalStream: DraftOrderTotalStreaming,
        mutableUserSessionStream: MutableUserSessionStreaming,
        checkoutNetworker: CheckoutNetworking = CheckoutNetworker(),
        presenter: PlaceOrderPresenter
    ) {
        self.draftOrderStream = draftOrderStream
        self.draftOrderTotalStream = draftOrderTotalStream
        self.mutableUserSessionStream = mutableUserSessionStream
        self.checkoutNetworker = checkoutNetworker
        self.presenter = presenter
        
        draftOrderTotalStream.publisher().sink { totalPrice in
            presenter.updateTotalPrice(to: totalPrice)
        }.store(in: &cancellables)
        
        mutableUserSessionStream.publisher().removeDuplicates().sink { session in
            presenter.updateUserName(session?.name ?? "")
        }.store(in: &cancellables)
    }
    
    func didPressPlaceOrder() {
        presenter.showConfirmation(errorMessage: nil)
    }
    
    func didConfirmOrder(name: String) async {
        guard !name.isEmpty else {
            DispatchQueue.main.async { [weak self] in
                self?.presenter.showConfirmation(errorMessage: "Por favor preencher com nome válido.")
            }
            return
        }
        
        let order = orderNetworkObject(name: name)
        do {
            try await checkoutNetworker.placeOrder(order)
            print("Successfuly placed order")
            // present success screen
        } catch {
            // do something when it fails
            print("Failed to place order, error: '\(error)'")
        }
    }
    
    private func orderNetworkObject(name: String) -> OrderNetworkObject {
        return OrderNetworkObject(user: userSession(name: name), skus: skuNetworkObjects())
    }
    
    private func userSession(name: String) -> UserNetworkObject {
        if let session = mutableUserSessionStream.data, session.name == name {
            return UserNetworkObject(id: session.id, name: name)
        } else {
            let session = UserSession(id: UUID().uuidString, name: name)
            mutableUserSessionStream.emit(session)
            return UserNetworkObject(id: session.id, name: name)
        }
    }
    
    private func skuNetworkObjects() -> [SKUNetworkObject] {
        draftOrderStream.data.map { draftProduct in
            SKUNetworkObject(productID: draftProduct.id, skuID: draftProduct.sku.id, productName: draftProduct.name)
        }
    }
}

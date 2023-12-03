import Foundation
import Combine
import OrderLibrary
import Navigation

protocol PlaceOrderInteracting {
    func didPressPlaceOrder()
    func didConfirmOrder(name: String) async
}

class PlaceOrderInteractor: PlaceOrderInteracting {
    let draftOrderStore: DraftOrderStoring
    let draftOrderStream: any DraftOrderStreaming
    let draftOrderTotalStream: DraftOrderTotalStreaming
    let mutableUserSessionStream: MutableUserSessionStreaming
    let stacker: ViewStacking
    let checkoutNetworker: CheckoutNetworking
    let orderHistoryStore: OrderHistoryStoring
    let presenter: PlaceOrderPresenter
    private var cancellables = Set<AnyCancellable>()
    
    init(
        draftOrderStore: DraftOrderStoring,
        draftOrderStream: any DraftOrderStreaming,
        draftOrderTotalStream: DraftOrderTotalStreaming,
        mutableUserSessionStream: MutableUserSessionStreaming,
        stacker: ViewStacking,
        orderHistoryStore: OrderHistoryStoring = OrderHistoryStore(),
        checkoutNetworker: CheckoutNetworking = CheckoutNetworker(),
        presenter: PlaceOrderPresenter
    ) {
        self.draftOrderStore = draftOrderStore
        self.draftOrderStream = draftOrderStream
        self.draftOrderTotalStream = draftOrderTotalStream
        self.mutableUserSessionStream = mutableUserSessionStream
        self.stacker = stacker
        self.orderHistoryStore = orderHistoryStore
        self.checkoutNetworker = checkoutNetworker
        self.presenter = presenter
        
        draftOrderTotalStream.publisher().receive(on: DispatchQueue.main).sink { totalPrice in
            presenter.updateTotalPrice(to: totalPrice)
        }.store(in: &cancellables)
        
        mutableUserSessionStream.publisher().receive(on: DispatchQueue.main).removeDuplicates().sink { session in
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
            let response = try await checkoutNetworker.placeOrder(order)
            await onSuccessfulPlaceOrder(user: UserSession(id: order.user.id, name: order.user.name), draftOrderProducts: draftOrderStream.data, response: response)
        } catch {
            // do something when it fails
            print("Failed to place order, error: '\(error)'")
        }
    }
    
    @MainActor
    private func onSuccessfulPlaceOrder(user: UserSession, draftOrderProducts: [DraftOrderProduct], response: PlaceOrderResponse) {
        draftOrderStore.clear()
        stacker.push(OrderPlacedBuilder(stacker: stacker, response: response))
        
        orderHistoryStore.store(Order(id: response.orderID, products: draftOrderProducts, date: response.date, estimatedDeliveryDate: response.expectedDeliveryDate, user: user))
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

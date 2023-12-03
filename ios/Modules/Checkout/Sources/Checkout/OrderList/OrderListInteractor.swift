//import Combine
import Navigation
import Foundation
import OrderLibrary

protocol OrderListInteracting {
    func didAppear()
}

class OrderListInteractor: OrderListInteracting {
    let presenter: OrderListPresenting
    let orderHistoryStore: OrderHistoryStoring
    
    init(
        presenter: OrderListPresenting,
        orderHistoryStore: OrderHistoryStoring
    ) {
        self.presenter = presenter
        self.orderHistoryStore = orderHistoryStore
    }
    
    func didAppear() {
        let orders = orderHistoryStore.getOrders()
        presenter.displayOrders(orders)
    }
}

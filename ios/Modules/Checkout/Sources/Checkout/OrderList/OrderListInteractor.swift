import Combine
import Navigation
import Foundation
import OrderLibrary

protocol OrderListInteracting {
    func didAppear()
}

class OrderListInteractor: OrderListInteracting {
    let presenter: OrderListPresenting
    let orderHistoryStream: OrderHistoryStreaming
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        presenter: OrderListPresenting,
        orderHistoryStream: OrderHistoryStreaming
    ) {
        self.presenter = presenter
        self.orderHistoryStream = orderHistoryStream
        
        orderHistoryStream.publisher().sink { orders in
            presenter.displayOrders(orders.sorted(by: { $0.estimatedDeliveryDate > $1.estimatedDeliveryDate }))
        }.store(in: &cancellables)
    }
    
    func didAppear() {
//        let orders = orderHistoryStore.getOrders()
//        presenter.displayOrders(orders)
    }
}

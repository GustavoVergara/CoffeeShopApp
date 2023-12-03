import SwiftUI
import Navigation
import OrderLibrary

public struct OrderListBuilder: ViewBuilding {
    let orderHistoryStore: OrderHistoryStoring
    
    public init(orderHistoryStore: OrderHistoryStoring) {
        self.orderHistoryStore = orderHistoryStore
    }
    
    public var id: String { "OrderList" }
    
    public func build() -> some View {
        let viewModel = OrderListViewModel()
        let interactor = OrderListInteractor(presenter: viewModel, orderHistoryStore: orderHistoryStore)
        return OrderListView(interactor: interactor, viewModel: viewModel)
    }
}


struct PreviewOrderListBuilder: ViewBuilding {
    var id: String { "OrderList" }
    
    func build() -> some View {
        let orders = [
            Order(id: "0", products: [], date: Date(), estimatedDeliveryDate: Date().addingTimeInterval(2 * 60), user: UserSession(id: "user-id", name: "Gustavo (Preview)")),
            Order(id: "1", products: [], date: Date(), estimatedDeliveryDate: Date().addingTimeInterval(-2 * 24 * 60 * 60), user: UserSession(id: "user-id", name: "Gustavo (Preview)")),
            Order(id: "2", products: [], date: Date(), estimatedDeliveryDate: Date().addingTimeInterval(-14 * 24 * 60 * 60), user: UserSession(id: "user-id", name: "Gustavo (Preview)")),
        ]
        let viewModel = OrderListViewModel()
        let interactor = OrderListInteractor(presenter: viewModel, orderHistoryStore: PreviewOrderHistoryStore(orders: orders))
        return OrderListView(interactor: interactor, viewModel: viewModel)
    }
}

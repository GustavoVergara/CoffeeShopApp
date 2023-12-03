import SwiftUI
import Navigation
import OrderLibrary

public struct OrderListBuilder: ViewBuilding {
    let orderHistoryStream: OrderHistoryStreaming
    
    public init(orderHistoryStream: OrderHistoryStreaming) {
        self.orderHistoryStream = orderHistoryStream
    }
    
    public var id: String { "OrderList" }
    
    public func build() -> some View {
        let viewModel = OrderListViewModel()
        let interactor = OrderListInteractor(presenter: viewModel, orderHistoryStream: orderHistoryStream)
        return OrderListView(interactor: interactor, viewModel: viewModel)
    }
}


struct PreviewOrderListBuilder: ViewBuilding {
    var id: String { "OrderList/preview" }
    
    func build() -> some View {
        let viewModel = OrderListViewModel()
        let interactor = OrderListInteractor(presenter: viewModel, orderHistoryStream: PreviewOrderHistoryStream())
        return OrderListView(interactor: interactor, viewModel: viewModel)
    }
}

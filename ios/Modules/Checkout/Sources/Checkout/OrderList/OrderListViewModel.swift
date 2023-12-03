import Combine
import Foundation
import Core
import OrderLibrary

protocol OrderListPresenting {
    func displayOrders(_ orders: [Order])
}

class OrderListViewModel: ObservableObject, OrderListPresenting {
    private let priceFormatter: PriceFormatting = PriceFormatter()
    private let dateFormatter = RelativeDateTimeFormatter()
    
    @Published
    var orders: [OrderViewData] = []
    
    func displayOrders(_ orders: [Order]) {
        self.orders = orders.map { order in
            let totalPrice = order.products.reduce(0, { $0 + ($1.sku.price * Double($1.quantity)) })
            return OrderViewData(id: order.id,
                                 storeName: "Loja A",
                                 state: Date().distance(to: order.estimatedDeliveryDate) > 0 ? "preparando" : "entregue",
                                 date: dateFormatter.string(for: order.estimatedDeliveryDate) ?? "",
                                 totalPrice: priceFormatter.displayPrice(totalPrice))
        }
    }
}


struct OrderViewData: Identifiable, Hashable {
    var id: String
    var storeName: String
    var state: String
    var date: String
    var totalPrice: String
}

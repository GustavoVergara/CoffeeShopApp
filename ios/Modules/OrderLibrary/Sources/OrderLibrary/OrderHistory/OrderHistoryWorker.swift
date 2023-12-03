import Combine

public class OrderHistoryWorker {
    private let mutableOrderHistoryStream: MutableOrderHistoryStreaming
    private let orderHistoryStore: OrderHistoryStoring
    
    private var cancellables = Set<AnyCancellable>()
    private var lastEmittedOrders = [Order]()
    
    init(mutableOrderHistoryStream: MutableOrderHistoryStreaming, orderHistoryStore: OrderHistoryStoring) {
        self.mutableOrderHistoryStream = mutableOrderHistoryStream
        self.orderHistoryStore = orderHistoryStore
    }
    
    public convenience init(mutableOrderHistoryStream: MutableOrderHistoryStreaming) {
        self.init(mutableOrderHistoryStream: mutableOrderHistoryStream, orderHistoryStore: OrderHistoryStore())
    }
    
    public func start() {
        lastEmittedOrders = orderHistoryStore.getOrders()
        mutableOrderHistoryStream.emit(lastEmittedOrders)
        mutableOrderHistoryStream.publisher().sink { [unowned self] orders in
            let diff = orders.difference(from: lastEmittedOrders)
            for change in diff {
                switch change {
                case .insert(_, let element, _):
                    orderHistoryStore.store(element)
                case .remove(_, let element, _):
                    print("Attempting to remove order from history, which is not allowed. OrderID: '\(element.id)'")
                }
            }
            lastEmittedOrders = orders
        }.store(in: &cancellables)
    }
}

import Combine
import Foundation

public protocol OrderHistoryStreaming {
    var data: [Order] { get }
    func publisher() -> AnyPublisher<[Order], Never>
}

public protocol MutableOrderHistoryStreaming: OrderHistoryStreaming {
    func emit(_ data: [Order])
    func addOrder(_ order: Order)
}

public class OrderHistoryStream: MutableOrderHistoryStreaming, ObservableObject {
    @Published
    public var data: [Order] = []
    
    public init() {}

    public func publisher() -> AnyPublisher<[Order], Never> {
        $data.eraseToAnyPublisher()
    }
    
    public func emit(_ data: [Order]) {
        self.data = data
    }
    
    public func addOrder(_ order: Order) {
        data.append(order)
    }
}
 
public class PreviewOrderHistoryStream: MutableOrderHistoryStreaming {
    let stream = {
        let stream = OrderHistoryStream()
        let now = Date()
        stream.emit([
            Order(id: "0", products: [], date: Date(), estimatedDeliveryDate: now.addingTimeInterval(2 * 60), user: UserSession(id: "user-id", name: "Gustavo (Preview)")),
            Order(id: "1", products: [], date: Date(), estimatedDeliveryDate: now.addingTimeInterval(-2 * 24 * 60 * 60), user: UserSession(id: "user-id", name: "Gustavo (Preview)")),
            Order(id: "2", products: [], date: Date(), estimatedDeliveryDate: now.addingTimeInterval(-14 * 24 * 60 * 60), user: UserSession(id: "user-id", name: "Gustavo (Preview)")),
        ])
        return stream
    }()
    
    public init() {}
    
    public var data: [Order] { stream.data }
    
    public func emit(_ data: [Order]) {
        stream.emit(data)
    }
    
    public func addOrder(_ order: Order) {
        stream.addOrder(order)
    }
    
    public func publisher() -> AnyPublisher<[Order], Never> {
        stream.publisher()
    }
}

import Combine

public protocol DraftOrderStreaming {
    var data: [DraftOrderProduct] { get }
    func publisher() -> AnyPublisher<[DraftOrderProduct], Never>
}

public protocol MutableDraftOrderStreaming: DraftOrderStreaming {
    func emit(_ products: [DraftOrderProduct])
}

public class DraftOrderStream: MutableDraftOrderStreaming, ObservableObject {
    @Published
    public var data: [DraftOrderProduct] = []
    
    public init() {}

    public func publisher() -> AnyPublisher<[DraftOrderProduct], Never> {
        $data.eraseToAnyPublisher()
    }
    
    public func emit(_ products: [DraftOrderProduct]) {
        self.data = products
    }
}


public protocol DraftOrderTotalStreaming {
    func publisher() -> AnyPublisher<Double, Never>
}

public struct DraftOrderTotalStream<P: DraftOrderStreaming>: DraftOrderTotalStreaming {
    let draftOrderStream: P
    
    public init(draftOrderStream: P) {
        self.draftOrderStream = draftOrderStream
    }
    
    public func publisher() -> AnyPublisher<Double, Never> {
        draftOrderStream.publisher().map { products in
            products.reduce(0, { $0 + ($1.sku.price * Double($1.quantity)) })
        }.eraseToAnyPublisher()
    }
}

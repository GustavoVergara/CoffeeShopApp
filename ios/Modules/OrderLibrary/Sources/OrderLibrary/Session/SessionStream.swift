import Combine

public protocol UserSessionStreaming {
    var data: UserSession? { get }
    func publisher() -> AnyPublisher<UserSession?, Never>
}

public protocol MutableUserSessionStreaming: UserSessionStreaming {
    func emit(_ data: UserSession?)
}

public class UserSessionStream: MutableUserSessionStreaming, ObservableObject {
    @Published
    public var data: UserSession?
    
    public init() {}

    public func publisher() -> AnyPublisher<UserSession?, Never> {
        $data.eraseToAnyPublisher()
    }
    
    public func emit(_ data: UserSession?) {
        self.data = data
    }
}

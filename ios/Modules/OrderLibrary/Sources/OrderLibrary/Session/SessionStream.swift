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

 
public class PreviewUserSessionStream: MutableUserSessionStreaming {
    let stream = {
        let stream = UserSessionStream()
        stream.emit(UserSession(id: "preview-id", name: "Gustavo (Preview)"))
        return stream
    }()
    
    public init() {}
    
    public var data: UserSession? { stream.data }
    
    public func emit(_ data: UserSession?) {
        stream.emit(data)
    }
    
    public func publisher() -> AnyPublisher<UserSession?, Never> {
        stream.publisher()
    }
}
